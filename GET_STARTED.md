# Get Started: Build Your APK

You have two options to build the LoopTrack APK:

---

## Option 1: GitHub Actions (Recommended — Free & Easy)

**No local Flutter installation needed!**

### Step 1: Push to GitHub

```bash
cd LoopTrack
git init
git add .
git commit -m "Initial LoopTrack project"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/looptrack.git
git push -u origin main
```

### Step 2: Trigger Build

Go to your repo on GitHub:
1. Click **Actions** tab
2. Select "Build LoopTrack APK" workflow
3. Click **Run workflow** → **Run workflow**

Or just push to `main` branch — it builds automatically!

### Step 3: Download APK

After the build completes (2-3 minutes):
1. Click the workflow run
2. Scroll to **Artifacts** section
3. Download `looptrack-universal-apk` ✅ (recommended)
4. Extract the zip → you'll get `app-release.apk`

### Step 4: Install on Phone

1. Transfer `app-release.apk` to your Android phone (via USB, email, cloud, etc.)
2. Enable "Install from unknown sources":
   - **Settings** → **Security** → **Install unknown apps**
   - Enable for your file manager/browser
3. Open the APK file → Install → Done!

---

## Option 2: Local Build With Flutter

**Requires Flutter SDK installation**

### Step 1: Install Flutter

**Windows:**
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter
# Add to PATH: C:\flutter\bin

flutter doctor
```

**Required tools:**
- Android Studio (includes Android SDK)
- Android SDK (API 34 or later)

### Step 2: Configure Flutter

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Verify setup
flutter doctor
```

### Step 3: Build APK Locally

```bash
cd LoopTrack

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# APK location: LoopTrack/build/app/outputs/flutter-apk/app-release.apk
```

### Step 4: Install

Same as Step 4 in Option 1.

---

## Which APK Should You Use?

The GitHub Action builds **two APK variants**:

| APK | Size | Devices | Recommend |
|-----|------|---------|-----------|
| **Universal** | ~8MB | Most phones (arm64 + arm-v7a) | ✅ Best choice |
| **ARM64** | ~7.5MB | Newer phones only | Niche use |

**Universal** works on 99% of devices. Only pick ARM64 if you know your phone is 64-bit only.

---

## Troubleshooting

### GitHub Actions Issues

**"Workflow not found"**
- Check file is at: `.github/workflows/build-apk.yml` (not `.yml.yaml`!)

**"Artifact not available"**
- Wait for workflow to complete (green checkmark)
- Check if you're logged into GitHub

**"Flutter build failed"**
- Check the workflow logs (click the red X)
- Common issue: Flutter action version mismatch

### Local Build Issues

**"flutter: command not found"**
- Flutter not in PATH. Add `C:\flutter\bin` to System Environment Variables

**"Android SDK not found"**
- Open Android Studio → SDK Manager
- Install "Android SDK Platform-Tools" and "Android SDK Build-Tools"

**"License not accepted"**
- Run: `flutter doctor --android-licenses`
- Type `y` repeatedly

**"Gradle sync failed"**
- Delete `.gradle` folder in `android/app` directory
- Run `flutter clean` then `flutter build apk --release` again

---

## Quick Reference

```bash
# GitHub Actions (recommended)
# Just push to main → automatic build!

# LocalFlutter commands
cd LoopTrack
flutter pub get              # Install dependencies
flutter clean                # Clean build cache
flutter build apk --release  # Build APK

# View logs
flutter run --verbose        # Run with detailed logs
flutter doctor               # Check Flutter setup
```

---

## Build Output Locations

**After GitHub Actions:**
- Download from Actions tab → Artifacts

**After local build:**
```
LoopTrack/build/app/outputs/flutter-apk/
├── app-release.apk              # Universal APK
├── app-armeabi-v7a-release.apk  # 32-bit devices (older)
└── app-arm64-v8a-release.apk    # 64-bit devices (newer)
```

---

## Installing on Device

**Via USB:**
```bash
# If you have ADB installed
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Manual:**
1. Copy APK to phone via USB or cloud storage
2. Allow "Unknown sources" in settings
3. Tap APK file → Install

---

**Need help?** Check the [README.md](README.md) for full documentation.