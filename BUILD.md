# Build & Run (Xcode Doctor)

## Quick Start

Use the Xcode Doctor script to clean caches, resolve packages, pick a valid iOS runtime, build, install and launch:

```bash
bash Tools/xcode_doctor.sh
```

## What the Doctor Does

The Xcode Doctor automatically:
1. **Ensures shared scheme exists** - copies from user schemes if needed
2. **Cleans DerivedData** - removes EverForm-specific build artifacts only
3. **Resolves Swift Package dependencies** - refreshes SPM caches
4. **Selects best iOS runtime** - prefers highest available iOS version
5. **Creates/boots simulator** - uses iPhone 16 Pro or fallback device
6. **Builds the app** - handles signing issues gracefully
7. **Installs and launches** - deploys to simulator and runs the app

## Manual Device Selection

To use a specific device:

```bash
# List available devices
xcrun simctl list devices

# Set specific device UDID
export EF_DEVICE="YOUR_DEVICE_UDID"
bash Tools/xcode_doctor.sh
```

## Common Issues & Fixes

### Build Signing Errors
The doctor automatically handles signing issues by:
- First attempting normal build
- If failed, retrying with `CODE_SIGNING_ALLOWED=NO` for compile verification
- Then proceeding with install/launch normally

### Simulator Won't Boot
```bash
# Reset simulator runtime
xcrun simctl shutdown all
xcrun simctl erase all

# Or create fresh device
xcrun simctl create "EF Fresh" "iPhone 16 Pro" "iOS 18.6"
```

### SPM Dependencies Stuck
```bash
# Manually resolve packages
xcodebuild -resolvePackageDependencies -project EverForm.xcodeproj -scheme EverForm
```

### DerivedData Issues
```bash
# Full DerivedData cleanup (more aggressive)
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## Project Structure

```
EverForm/
├── EverForm.xcodeproj/
│   └── xcshareddata/xcschemes/
│       └── EverForm.xcscheme        # Shared scheme
├── Tools/
│   └── xcode_doctor.sh             # Build/launch script
└── BUILD.md                         # This file
```

## Requirements

- Xcode Command Line Tools
- iOS Simulator runtime (iOS 17.0+ recommended)
- `xcpretty` (optional, for colored output)

## Script Options

The script can be modified by editing these variables at the top:
- `PROJECT`: Project file (default: EverForm.xcodeproj)
- `SCHEME`: Build scheme (default: EverForm)
- `CONFIG`: Build configuration (default: Debug)

## Revert Changes

To remove the doctor script and revert any shared scheme changes:

```bash
# Remove doctor script
rm -rf Tools/

# Remove shared scheme (if it was copied from user scheme)
rm -f EverForm.xcodeproj/xcshareddata/xcschemes/EverForm.xcscheme
```

## Troubleshooting

**Xcode not found**: Install Xcode Command Line Tools
```bash
xcode-select --install
```

**No iOS runtimes**: Install iOS Simulator via Xcode > Preferences > Platforms

**Permission errors**: Ensure script has execute permissions
```bash
chmod +x Tools/xcode_doctor.sh
```