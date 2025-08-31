# Path EPOS – iPad Demo (v1.0)

A SwiftUI EPOS demo for iPad with a Square‑style UI.

## Features
- Inventory grid with custom icons and prices (€, EU locale)
- Right sidebar cart (rounded), running total, Complete Transaction
- Payment flow (Cash / Card) with scrollable summary
- Branding: Path logo, primary color #3B9F40
- Layout fixes: status bar/system background, safe‑area handling

## Build
1. Open `PathEPOSDemo.xcodeproj` in Xcode 15+
2. Target: iPadOS 17+
3. Run on iPad simulator or device

## Structure
- `PathEPOSDemo/` – app sources (SwiftUI views, models)
- `Assets.xcassets/` – app icons, custom item icons

## Version 1.0 Notes
- Fixed status bar white strip via safe‑area background strategy
- Rounded cart sidebar with header above, aligned to grid
- SystemGray6 insets above/below cart; bottom padding visible
- Payment view header fixed; content scrolls

## Next Ideas
- Persisted cart, discounts, receipt sharing
- Real card SDK integration

---
© Path – Demo use only.
