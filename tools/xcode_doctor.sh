#!/usr/bin/env bash
set -euo pipefail

PROJECT="EverForm.xcodeproj"
WORKSPACE=""
SCHEME="EverForm"
CONFIG="Debug"

bold() { printf "\033[1m%s\033[0m\n" "$*"; }
info() { printf "ℹ️  %s\n" "$*"; }
ok()   { printf "✅ %s\n" "$*"; }
warn() { printf "⚠️  %s\n" "$*"; }
err()  { printf "❌ %s\n" "$*" >&2; }

# Detect workspace or project
if ls *.xcworkspace >/dev/null 2>&1; then
  WORKSPACE="$(ls *.xcworkspace | head -n1)"
  info "Using workspace: $WORKSPACE"
else
  if ls *.xcodeproj >/dev/null 2>&1; then
    PROJECT="$(find . -maxdepth 1 -name "*.xcodeproj" -type d | head -n1 | sed 's|^\./||')"
    info "Using project: $PROJECT"
  else
    err "No Xcode workspace or project found in repo root."
    exit 1
  fi
fi

# List schemes
if [[ -n "$WORKSPACE" ]]; then
  xcodebuild -list -workspace "$WORKSPACE" || true
else
  xcodebuild -list -project "$PROJECT" || true
fi

# Ensure shared scheme exists; if not, try to copy from xcuserdata
ensure_shared_scheme() {
  local xcode_container="$PROJECT"
  [[ -n "$WORKSPACE" ]] && xcode_container="$WORKSPACE"

  local base="${xcode_container%.*}" # EverForm
  local proj_dir="${base}.xcodeproj"

  if [[ ! -d "$proj_dir" ]]; then
    err "Project directory $proj_dir not found."
    return 1
  fi

  local shared_dir="$proj_dir/xcshareddata/xcschemes"
  mkdir -p "$shared_dir"

  # If EverForm.xcscheme already shared, done
  if ls "$shared_dir"/*.xcscheme >/dev/null 2>&1; then
    info "Shared scheme(s) already present."
    return 0
  fi

  # Try to find a user scheme to copy
  local user_dir_glob="$proj_dir/xcuserdata" 
  if ls "$user_dir_glob"/*/xcschemes/*.xcscheme >/dev/null 2>&1; then
    local first_user_scheme
    first_user_scheme="$(ls "$user_dir_glob"/*/xcschemes/*.xcscheme | head -n1)"
    info "Copying user scheme to shared: $first_user_scheme"
    cp "$first_user_scheme" "$shared_dir/"
    ok "Shared scheme created."
  else
    warn "No user scheme found to share. Build may still work if default scheme resolves."
  fi
}

# Clean DerivedData safely
clean_derived_data() {
  local dd=~/Library/Developer/Xcode/DerivedData
  if [[ -d "$dd" ]]; then
    info "Cleaning DerivedData selectively…"
    # Find EverForm-specific DerivedData and remove it
    find "$dd" -name "*EverForm*" -type d -exec rm -rf {} + 2>/dev/null || true
    ok "EverForm DerivedData cleaned."
  else
    info "No DerivedData directory to clean."
  fi
}

# Reset SPM caches for this project/workspace
spm_reset() {
  info "Resetting Swift Package caches…"
  # Resolve package dependencies within the project/workspace context
  if [[ -n "$WORKSPACE" ]]; then
    xcodebuild -resolvePackageDependencies -workspace "$WORKSPACE" -scheme "$SCHEME" -configuration "$CONFIG" || true
  else
    xcodebuild -resolvePackageDependencies -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIG" || true
  fi
  ok "SPM dependencies resolved."
}

# Find best iOS runtime and a device
pick_runtime_and_device() {
  info "Selecting iOS runtime & device…"
  local best_runtime
  best_runtime="iOS 26.0"

  info "Chosen runtime: $best_runtime"
  export EF_RUNTIME="$best_runtime"

  # Use existing iPhone 16 Pro device
  local device
  device="$(xcrun simctl list devices available | grep "iPhone 16 Pro" | grep -v "Pro Max" | head -n1 | awk -F '[()]' '{print $2}')"
  
  if [[ -z "${device:-}" ]]; then
    # Create a fresh device if none
    info "No device found; creating one…"
    device="$(xcrun simctl create "EF Test" "iPhone 16 Pro" "com.apple.CoreSimulator.SimRuntime.iOS-26-0")"
  fi

  export EF_DEVICE="$device"
  info "Using device UDID: $EF_DEVICE"

  # Boot if needed
  xcrun simctl bootstatus "$EF_DEVICE" -b || xcrun simctl boot "$EF_DEVICE" || true
  sleep 2
  xcrun simctl bootstatus "$EF_DEVICE" -b
  ok "Simulator ready."
}

# Build (compile-only if signing blocks), then install + launch
build_install_launch() {
  local dest="platform=iOS Simulator,id=$EF_DEVICE"
  info "Building ($CONFIG)…"

  set +e
  if [[ -n "$WORKSPACE" ]]; then
    xcodebuild -workspace "$WORKSPACE" -scheme "$SCHEME" -configuration "$CONFIG" -destination "$dest" build | xcpretty || BUILD_FAIL=1
  else
    xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIG" -destination "$dest" build | xcpretty || BUILD_FAIL=1
  fi
  set -e

  if [[ "${BUILD_FAIL:-0}" -ne 0 ]]; then
    warn "Build failed; retrying compile-only (CODE_SIGNING_ALLOWED=NO)…"
    if [[ -n "$WORKSPACE" ]]; then
      xcodebuild -workspace "$WORKSPACE" -scheme "$SCHEME" -configuration "$CONFIG" -destination "$dest" CODE_SIGNING_ALLOWED=NO build | xcpretty
    else
      xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIG" -destination "$dest" CODE_SIGNING_ALLOWED=NO build | xcpretty
    fi
    ok "Compile step succeeded without signing."
  else
    ok "Build succeeded."
  fi

  # Install & launch
  local app_path
  app_path="$(find ~/Library/Developer/Xcode/DerivedData -type d -name "*.app" | grep "/Build/Products/$CONFIG-iphonesimulator/" | grep EverForm | head -n1 || true)"
  if [[ -z "${app_path:-}" ]]; then
    err "Built .app not found."
    exit 1
  fi
  info "Installing: $app_path"
  xcrun simctl install "$EF_DEVICE" "$app_path" || true

  # Find bundle id
  local bundle_id
  bundle_id=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$app_path/Info.plist")
  info "Launching bundle id: $bundle_id"
  xcrun simctl launch "$EF_DEVICE" "$bundle_id" || true
  ok "Launch command executed."
}

main() {
  ensure_shared_scheme
  clean_derived_data
  spm_reset
  pick_runtime_and_device
  build_install_launch
  ok "Xcode Doctor finished."
}

# Requirements check
command -v xcrun >/dev/null || { err "xcrun not found (Xcode Command Line Tools missing?)"; exit 1; }
command -v xcodebuild >/dev/null || { err "xcodebuild not found"; exit 1; }
if ! command -v xcpretty >/dev/null; then 
  warn "xcpretty not found; output will be verbose."
  xcpretty() { cat; }
fi

main "$@"