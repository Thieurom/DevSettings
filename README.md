# DevSettings
A simple SwiftUI view to manage development settings in your SwiftUI application. This package provides a user-friendly interface for showing and toggling a few development settings that are useful during the development phase but should not be exposed in production.

## Installation
To integrate DevSettings into your Xcode project, add it as a Swift Package Manager dependency:
https://github.com/Thieurom/DevSettings.git

## Usage
1. Ensure you call `DevSettings.configure()` in your app's `init` method or in the `AppDelegate`'s `didFinishLaunching` method to properly configure the settings.

2. Embed the `DevelopmentSettingsView` in your SwiftUI views to manage and display your settings conveniently.

## Credits
DevSettings makes use of the following awesome libraries:
- [ShowTime](https://github.com/Thieurom/ShowTime)
- [Wormholy](https://github.com/pmusolino/Wormholy)
