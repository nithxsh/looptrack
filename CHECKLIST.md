# 📋 LoopTrack Setup Checklist

## Before Building

- [ ] Review `PROJECT_OVERVIEW.md` to understand what was built
- [ ] Read `GET_STARTED.md` for build instructions
- [ ] Create GitHub repository (if using GitHub Actions)

## Building via GitHub Actions (Recommended)

- [ ] Install Git (if not already installed)
- [ ] Create GitHub account (if you don't have one)
- [ ] Create new repo: https://github.com/new
- [ ] Initialize git in LoopTrack folder
- [ ] Push to GitHub
- [ ] Run workflow manually or wait for auto-trigger
- [ ] Download APK from Actions → Artifacts

## Building Locally (Alternative)

- [ ] Install Flutter SDK: https://flutter.dev/docs/get-started/install
- [ ] Add Flutter to PATH
- [ ] Run `flutter doctor`
- [ ] Install Android Studio (includes Android SDK)
- [ ] Accept licenses: `flutter doctor --android-licenses`
- [ ] Build: `flutter build apk --release`

## After Building

- [ ] Transfer APK to Android device
- [ ] Enable "Install from unknown sources" in phone settings
- [ ] Install APK
- [ ] Test daily tasks (add, toggle, delete)
- [ ] Test persistent notes (add, edit, delete)
- [ ] Check history view
- [ ] Wait for midnight reset (or trigger manually)

## Optional Enhancements

- [ ] Add custom app icon to `assets/icon.png` (512x512)
- [ ] Change app name in `android/app/src/main/res/values/strings.xml`
- [ ] Adjust timezone in `lib/services/reset_service.dart` (line 46)
- [ ] Customize colors in `android/app/src/main/res/values/colors.xml`
- [ ] Add your own features!

## Troubleshooting

If build fails:
- [ ] Check GitHub Actions logs (for GitHub builds)
- [ ] Run `flutter doctor` (for local builds)
- [ ] Run `flutter clean` then rebuild
- [ ] Check Android SDK version (API 34+ recommended)

---

**Quick reference for APK file location after local build:**
```
LoopTrack/build/app/outputs/flutter-apk/app-release.apk
```