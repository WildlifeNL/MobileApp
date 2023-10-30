# wildlife_nl_app

The project for the first version of the WildlifeNL app

## Getting Started

This project has the following folder structure

```
android/       # Android-specific
└── app/       # Android-specific assets
assets/        # Assets used across both platforms
├── app-icon/  # App Icon source
├── fonts/     # Fonts (including icons)
└── symbols/   # Icon sources
ios/           # iOS-specific files
lib/           # Source code
├── generated/ # All generated files that have to be checked into git (for now only localization)
├── l10n/      # Localization
├── models/    # Data models used inside the app
├── pages/     # Widgets that fill up an entire screen and are part of the main layout
├── screens/   # Widgets that fill up an entire screen
├── services/  # Access to things outside of the app (API)
├── state/     # Riverpod/State management
├── utilities/ # Re-usable pieces of logic
└── widgets/   # Re-usable widgets
test/          # Tests
```

If anything is found that doesn't fit in these bounds, just create the code and it it processed during Review.

For State management Riverpod is used, we use the Riverpod annotations to automatically generate our Riverpod providers for us.

For localization we use l10n, for this you need an Android Studio (possibly also available for VSCode) plugin called Flutter Intl.

Also recommended are the following plugins for Android Studio: Flutter snippets and Flutter Riverpod snippets, for these plugins there probably exist an equivalent VSCode version.