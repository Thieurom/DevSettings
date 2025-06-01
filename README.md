# DevSettings
A simple SwiftUI view to manage development settings in your SwiftUI application.

This package provides a user-friendly interface for showing and toggling a few development settings that are useful during the development phase but should not be exposed in production.

https://github.com/user-attachments/assets/a89200a0-c361-4856-bbd8-f9597b6c1d46


## Installation
To integrate DevSettings into your Xcode project, add it as a Swift Package Manager dependency:
https://github.com/Thieurom/DevSettings.git

## Usage
1. Call `DevSettings.start()` in your app's `init` or in the AppDelegate's `didFinishLaunching`.

2. Embed the `DevelopmentSettingsView` in your SwiftUI views to manage and display your settings conveniently. For example:
```swift
#if DEV
    .navigationDestination(isPresented: $showSettings) {
        DevelopmentSettingsView()
            .navigationTitle("Development Settings")
        }
    }
#endif
```

## Credits
DevSettings makes use of the following awesome libraries:
- [ShowTime](https://github.com/Thieurom/ShowTime)
- [Wormholy](https://github.com/pmusolino/Wormholy)
