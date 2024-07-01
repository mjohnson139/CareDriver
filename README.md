# CareDriver Take Home Interview Project

## Overview

### Architecture

The project is organized into Swift packages for modularity, testability, and reusability:

- **ApiClient**: Handles networking and API calls.
- **ConfirmationAlert**: Customizable confirmation alert controller.
- **Models**: Data models used across the application.
- **MyRidesFeature**: Main rides feature, including view models and view controllers.
- **StyleSheet**: UI styles and extensions.

### Key Components

1. **AppDelegate and SceneDelegate**:
   - Sets up the application window and initial view controller.

2. **ApiClient**:
   - Includes `LiveApiClient` for real data and `MockApiClient` for testing.

3. **Models**:
   - Defines data structures (`Trips`, `Trip`, `Passenger`, `PlannedRoute`, `Leg`, `Waypoint`, `Location`) with JSON serialization/deserialization.

4. **RidesViewModel**:
   - Manages loading and grouping trips, using dependency injection for different API clients.

5. **RidesTableViewController**:
   - Displays a list of trips using a table view, handling user interactions.

6. **ConfirmationAlertController**:
   - A customizable alert controller for confirmation dialogs.

### Third-Party Libraries

- **SnapKit**: For defining Auto Layout constraints programmatically.

## Improvements and Notes

### Improvements

1. **ConfirmationAlertController Animation**:
   - Change the animation style to be similar to `UIAlertController`, which animates from the center.

2. **Unit Tests**:
   - Add more comprehensive tests for `RidesViewModel` to cover edge cases and improve code coverage.

### Notes

1. **Previews and Mock Objects**:
   - Using SwiftUI Previews and `MockApiClient` allows efficient testing and development without hitting real endpoints.

```swift
#Preview {
  UINavigationController(rootViewController: RidesTableViewController(viewModel: .init(apiClient: MockApiClient())))
}
```

### Project Usage

1. **Running the Project**:
   - Open the CareDriver.xcworkspace file in Xcode.  Select the iOS scheme and run on a simulator or device. The initial screen displays trips fetched from the mock API client.

2. **Testing**:
   - Unit tests for various components can be run using the Xcode test navigator, focusing on API interactions and model serialization.

3. **Customizing Confirmation Alerts**:
   - Customize `ConfirmationAlertController` with titles, subtitles, primary, and secondary buttons using builder methods.

4. **Extending the Project**:
   - Create additional Swift packages or extend existing ones, ensuring new features include relevant tests.

## Conclusion

This project demonstrates modular architecture, dependency injection, and testability in a Swift application. By leveraging Swift packages and mock objects, the codebase remains clean and maintainable. Using SnapKit for layout and a customizable confirmation alert controller enhances the overall user experience.
