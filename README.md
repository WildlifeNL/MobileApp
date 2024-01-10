# wildlife_nl_app

Welcome to the WildlifeNL Frontend Flutter Project repository! This project is a mobile application developed to enhance the experience of tracking the biodiversity in (for foresters only right now). By leveraging the power of Flutter, this app provides an intuitive and visually appealing interface for users to explore and engage with the rich biodiversity of the region.

## Features
- Map page
    - Map
    - Multiple types of markers
    - Filter marker type
    - User location
    - Button to go back to users location
    - Report info dialog
- List page
    - Filter report type
    - Report info dialog
    - Sorted on day
- Report flow
    - Choice dialog report type
    - Choice dialog animal
    - Dynamic form based on admin-dashboard
    - Image upload (camera and gallery)
    - Upload report (dynamic fields)

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


## How to run this project locally

1. Set the variable "mapURL" in ``MobileApp\lib\pages\map.dart``  to a MapBox style URL or an alternative URL of a vector tile map.
2. Install Dependencies:
Navigate to the project directory and ``run flutter pub get`` to install the required dependencies.
3. Build the project with ``dart run build_runner build``
4. Run the app with the run-button in Android-studio
