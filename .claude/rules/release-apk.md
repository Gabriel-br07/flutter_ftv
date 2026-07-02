# Rule: APK Release (Android)

The initial target is **Android APK**. There is no Play Store in the MVP — distribution is by release APK.

## Before release

Run and make sure everything passes:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

Do not release with failing tests or static-analysis errors.

## Build the APK

```bash
flutter build apk --release
```

The generated APK is at `build/app/outputs/flutter-apk/app-release.apk`.

## Security and versioning

- **Do not version keystore files** (`*.jks`, `*.keystore`).
- **Do not version passwords/secrets** or `key.properties` — keep them out of version control (`.gitignore`).
- Reference signing via a local, git-ignored file.

## Documentation

- **Document APK build instructions in the README** when release work starts — commands, where to find the APK, and how to configure signing locally.
- Keep the app version in `pubspec.yaml` (`version: x.y.z+build`) up to date per release.

## MVP constraint

- **Do not configure Play Store publishing in the MVP.**
