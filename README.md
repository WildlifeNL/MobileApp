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

For State management Riverpod is used, we use the Riverpod annotations to automatically generate our Riverpod providers for us.

## Revert back to vector tilemap

Set the variable "mapURL" in ``MobileApp\lib\pages\map.dart``  to a MapBox style URL or an alternative URL of a vector tile map.

Also uncomment all code that is related to this in the map.dart. Also comment the TileLayer with OSM inside.

## Flutter Beta track

It might be that you still get errors when trying to build the project even after following the steps below.

Then you need to switch to the flutter beta track with ``flutter channel beta``

Then you need to do a flutter upgrade to update flutter and then it should all work.

## How to run this project locally

1. Install Dependencies:
Navigate to the project directory and ``run flutter pub get`` to install the required dependencies.
2. Generate the auto generated code with ``dart run build_runner build``
3. Run the app with the run-button (main_prod, main_dev)  in Android-studio or with ``flutter run --flavor dev`` or ``flutter run --flavor prod``

## Build the project apk

1. Install Dependencies:
   Navigate to the project directory and ``run flutter pub get`` to install the required dependencies.
2. Generate the auto generated code with ``dart run build_runner build``
3. Build the apk with ``flutter build apk --flavor prod``

## Build the project iOS app

1. Install Dependencies:
   Navigate to the project directory and ``run flutter pub get`` to install the required dependencies.
2. Generate the auto generated code with ``dart run build_runner build``
3. Run the app with the run-button (main_prod) in Android-studio or with ``flutter run --flavor prod``