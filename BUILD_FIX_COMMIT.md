fix(theme): add EFTextTheme + EFTextRole and wire EFText

## Summary
- Created canonical EFTextRole enum and EFTextTheme system
- Fixed missing type errors across 30+ files using efText()
- Maintained backward compatibility with legacy theme system
- Added environment support for existing EFText usage patterns

## Changes

### New Files
- **UI/Theme/EFTextTheme.swift** - Complete text theming system with EFTextRole enum and EFTextTheme struct

### Modified Files  
- **UI/Foundation/EFText.swift** - Updated to work with new EFTextRole, removed duplicate efText extension
- **DesignSystem/Modifiers/EFText.swift** - Deprecated in favor of canonical implementation
- **Features/Scan/ScanView.swift** - Fixed textTheme reference to use efText() modifier
- **EverForm/EverFormApp.swift** - Fixed preferredColorScheme nil typing

## Technical Details
- EFTextRole: primary, secondary, muted, inverse, header
- EFTextTheme.color(for:scheme:) handles dark/light mode colors
- Environment values preserved for legacy compatibility
- 100+ existing efText() calls now work without changes

## Verification
- ✅ Build succeeds for iPhone 16 Pro simulator
- ✅ No "cannot find type 'EFTextRole'" errors
- ✅ All existing efText() usage preserved
- ✅ Only non-functional color resolution changes
- ✅ Target membership: EverForm app target

## Revert
To revert these changes:
1. Delete UI/Theme/EFTextTheme.swift
2. Restore original EFText.swift and DesignSystem/Modifiers/EFText.swift
3. Revert ScanView.swift and EverFormApp.swift changes