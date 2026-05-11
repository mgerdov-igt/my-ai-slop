# Who's Turn? 🎲

> A Flutter app that spins a meeple wheel to decide which player goes first — because rock-paper-scissors takes too long.

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Building for Release](#building-for-release)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Contributing](#contributing)

---

## About

**Who's Turn?** is a mobile app for board game nights. Select the number of players (2–12), tap the meeple, and watch it spin to a random stop — the highlighted sector decides who goes first.

---

## Features

- 🎯 **2–12 players** — configurable player count with +/– buttons
- 🌈 **Color-coded sectors** — each player gets a unique vibrant color
- 🌀 **Smooth spin animation** — realistic ease-out deceleration
- ✨ **Pulsating glow effect** — animated yellow halo around the meeple
- 📍 **Smart result placement** — result badge repositions to avoid overlapping the meeple tip
- 🌙 **Dark theme** — easy on the eyes at the game table

---

## Screenshots

> _Add screenshots here once available._

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.11.5`
- Dart SDK (bundled with Flutter)
- Android SDK / Android Studio (for Android builds)
- A connected device or emulator

Verify your Flutter setup:

```bash
flutter doctor
```

### Installation

```bash
# Clone the repository
git clone https://github.com/mgerdov-igt/whos-turn.git
cd whos-turn/whos_turn_app

# Install dependencies
flutter pub get
```

### Running the App

```bash
# Run in debug mode on a connected device
flutter run

# Run on a specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

---

## Building for Release

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

Install directly to a connected device:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
```

> **Note:** This project uses the debug signing key by default. For Play Store distribution, configure a signing keystore in `android/key.properties`.

### App Icon

Icons are generated from `assets/images/app_icon.png` using [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons):

```bash
dart run flutter_launcher_icons
```

---

## Project Structure

```
lib/
├── main.dart                    # App entry point & root widget
├── constants/
│   ├── app_colors.dart          # Color palette & gradient definitions
│   ├── app_constants.dart       # Numeric & string app-wide constants
│   └── constants.dart           # Barrel export
├── painters/
│   ├── sector_painter.dart      # CustomPainter for pie-chart sectors
│   └── painters.dart            # Barrel export
├── screens/
│   ├── player_count_screen.dart # Screen 1: choose number of players
│   ├── spinner_screen.dart      # Screen 2: spin & display result
│   └── screens.dart             # Barrel export
└── widgets/
    ├── counter_button.dart      # +/– icon button
    ├── instruction_badge.dart   # "Tap the meeple!" hint overlay
    ├── result_badge.dart        # "Player X goes first!" result overlay
    ├── spinning_meeple.dart     # Animated meeple with pulsing glow
    └── widgets.dart             # Barrel export
```

---

## Tech Stack

| | |
|---|---|
| Framework | [Flutter](https://flutter.dev) |
| Language | Dart `^3.11.5` |
| SVG rendering | [`flutter_svg`](https://pub.dev/packages/flutter_svg) `^2.3.0` |
| Icon generation | [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) `^0.14.4` |
| Platform | Android (primary) |

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m "Add my feature"`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request
