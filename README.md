# LoopTrack 🔄

A lightweight, privacy-focused productivity app that combines a daily routine reset with persistent note-taking. All data is stored locally on your device — no cloud accounts required.

## Features

- **Daily Loop** – Recurring daily tasks that automatically reset at midnight
- **Persistent Notes** – Long-term notes and lists that never reset
- **Visual History** – Calendar view showing your consistency streaks and completion rates
- **Home Screen Widget** – Quick access to toggle tasks (coming soon)
- **100% Private** – All data stored in SQLite on your device
- **Ultra-lightweight** – Minimal background footprint

## Tech Stack

- **Flutter** – Cross-platform UI
- **SQLite** – Local database
- **Flutter Local Notifications** – Midnight reset scheduling
- **Table Calendar** – Visual history calendar

## Building the APK

### Prerequisites

Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install).

```bash
flutter doctor
```

### Local Build

```bash
cd LoopTrack
flutter pub get
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### GitHub Actions Build (Recommended)

1. **Push your code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/your-username/looptrack.git
   git push -u origin main
   ```

2. **Enable GitHub Actions**
   - Go to your repo → Actions tab
   - Enable workflows (if prompted)

3. **Trigger the build**
   - Push to `main` branch, or
   - Go to Actions → "Build LoopTrack APK" → "Run workflow"

4. **Download the APK**
   - Click on the completed workflow run
   - Scroll to "Artifacts" section
   - Download `looptrack-universal-apk` (preferred) or `looptrack-arm64-apk`

5. **Install on your device**
   - Transfer APK to phone
   - Enable "Install from unknown sources" in settings
   - Open APK file to install

## How to Use

### Daily Loop

1. Tap the **+** button to add daily tasks
2. Check off tasks as you complete them
3. At midnight, all tasks automatically reset for the new day

### Persistent Notes

1. Switch to the "Persistent Notes" tab
2. Tap **+** to add new notes
3. Notes never reset — perfect for long-term lists and ideas

### History View

1. Tap the **history icon** (📅) in the app bar
2. See your completion rates, streaks, and consistency scores
3. Tap any calendar day to see details

### Midnight Reset

Daily tasks reset automatically at 12:00 AM. You'll receive a silent notification when this happens.

## Project Structure

```
LoopTrack/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models
│   │   ├── daily_task.dart
│   │   ├── persistent_note.dart
│   │   └── history_entry.dart
│   ├── services/                    # Business logic
│   │   ├── database_helper.dart     # SQLite wrapper
│   │   ├── reset_service.dart       # Midnight reset logic
│   │   ├── daily_tasks_service.dart
│   │   ├── persistent_notes_service.dart
│   │   └── history_service.dart
│   ├── screens/                     # UI screens
│   │   ├── home_screen.dart
│   │   ├── history_screen.dart
│   │   ├── task_add_screen.dart
│   │   └── note_detail_screen.dart
│   └── widgets/                     # Reusable widgets
│       ├── daily_task_item.dart
│       └── note_item.dart
├── android/                         # Android native code
│   └── app/src/main/AndroidManifest.xml
├── pubspec.yaml                     # Dependencies
└── .github/workflows/               # CI/CD
    └── build-apk.yml
```

## Development

**Run in debug mode:**
```bash
flutter run
```

**Run tests:**
```bash
flutter test
```

**Analyze code:**
```bash
flutter analyze
```

## Configuration

**Change timezone for midnight reset:**
Edit `lib/services/reset_service.dart` line 46:
```dart
tz.setLocalLocation(tz.getLocation('America/New_York')); // or your timezone
```

## Permissions Used

- `RECEIVE_BOOT_COMPLETED` – Restart midnight reset after phone reboot
- `SCHEDULE_EXACT_ALARM` – Schedule midnight reset precisely
- `POST_NOTIFICATIONS` – Show silent reset notification

No network permissions — your data stays on-device.

## License

MIT License – feel free to use, modify, and distribute.

## Contributing

Contributions welcome! Feel free to open issues or submit pull requests.

---

Built with ❤️ for privacy-focused productivity.