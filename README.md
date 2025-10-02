# ⏰ Alarm Clock App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Hacktoberfest](https://img.shields.io/badge/Hacktoberfest-2025-FF6B6B?style=for-the-badge)

A beautiful, modern, and feature-rich alarm clock application built with Flutter. Designed with a sleek dark theme and smooth animations for the best user experience.

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Contributing](#-contributing) • [License](#-license)

</div>

---

## ✨ Features

- 🎨 **Sleek Dark Theme** - Modern, minimal UI with gradient cards and smooth animations
- ⏰ **Create & Manage Alarms** - Easy-to-use interface for setting up alarms
- 🔄 **Recurring Alarms** - Set alarms for specific days of the week
- 🏷️ **Custom Labels** - Add personalized labels to your alarms
- 🔔 **Local Notifications** - Reliable alarm notifications using flutter_local_notifications
- 📱 **Material Design 3** - Beautiful, modern UI following Material Design guidelines
- 🚀 **GetX State Management** - Efficient reactive state management
- 💾 **Persistent Storage** - Alarms saved locally using SharedPreferences
- 🎯 **Precise Scheduling** - Accurate alarm timing with timezone support
- ⚡ **Smooth Animations** - Delightful transitions and micro-interactions
- 🌐 **Cross-Platform** - Works on both Android and iOS

## 🏗️ Architecture

This app follows clean architecture principles with:

- **GetX** for state management and navigation
- **Model-View-Controller (MVC)** pattern
- **Service Layer** for business logic separation
- **Reactive Programming** with Rx observables
- **Modular Structure** for maintainability

### Project Structure

```
lib/
├── core/
│   └── constants/
│       └── app_constants.dart      # Colors, strings, styles
├── controllers/
│   └── alarm_controller.dart        # GetX state management
├── models/
│   └── alarm.dart                   # Alarm data model
├── screens/
│   ├── home_screen.dart            # Main alarm list screen
│   └── add_edit_alarm_screen.dart  # Alarm creation/editing
├── services/
│   ├── alarm_storage.dart          # Local storage service
│   └── notification_service.dart    # Notification handling
└── main.dart                        # App entry point
```

## 📱 Screenshots

> Screenshots will be added soon!

## 🚀 Installation

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extension
- Android device/emulator (Android 5.0+) or iOS device/simulator (iOS 12.0+)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/alarm_clock_app.git
   cd alarm_clock_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- [get](https://pub.dev/packages/get) - State management and navigation
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) - Local notification support
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Persistent key-value storage
- [intl](https://pub.dev/packages/intl) - Date and time formatting
- [permission_handler](https://pub.dev/packages/permission_handler) - Permission management
- [uuid](https://pub.dev/packages/uuid) - Unique ID generation

## 🎯 Usage

### Creating an Alarm

1. Tap the **"+ Add Alarm"** button on the home screen
2. Select your desired time using the time picker
3. (Optional) Add a label for your alarm
4. Select repeat days if you want the alarm to recur
5. Tap **"Save Alarm"** to create the alarm

### Managing Alarms

- **Toggle Alarm**: Use the switch on each alarm card to enable/disable
- **Edit Alarm**: Tap on an alarm card to edit its details
- **Delete Alarm**: Tap the delete icon or swipe to remove an alarm
- **Clear All**: Use the menu option to clear all alarms at once

## 🤝 Contributing

We welcome contributions from the community! This project is participating in **Hacktoberfest 2025**.

### How to Contribute

1. **Fork the repository**
2. **Create a new branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
5. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style and architecture
- Write clear, descriptive commit messages
- Add comments for complex logic
- Test your changes thoroughly on both Android and iOS (if possible)
- Update documentation if needed
- Be respectful and constructive in discussions

### Good First Issues

Look for issues labeled with:
- `good first issue` - Perfect for newcomers
- `hacktoberfest` - Hacktoberfest-specific issues
- `help wanted` - We need your help!
- `enhancement` - New features to add
- `bug` - Bugs to fix

### Ideas for Contributions

- 🎨 Add more themes (light theme, custom colors)
- 🔊 Custom alarm sounds and ringtones
- 😴 Snooze functionality
- 📊 Alarm statistics and history
- 🌍 Multi-language support
- ♿ Accessibility improvements
- 📱 Widget support
- 🧪 Unit and widget tests
- 📝 Documentation improvements
- 🐛 Bug fixes and optimizations

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🏗️ Building

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributors

Thanks to all the amazing people who have contributed to this project!

<!-- Add contributor badges here -->

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for efficient state management
- All open-source contributors

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/harshbsv/alarm_clock_app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/harshbsv/alarm_clock_app/discussions)

## 🌟 Show Your Support

If you like this project, please consider giving it a ⭐️!

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#-alarm-clock-app)

</div>
