---
name: apk-release-checker
description: Use to prepare and validate an Android APK release build. Invoke when generating an APK for distribution or reviewing the release process.
---

# APK Release Checker

Prepares the Android **release APK** build and verifies the project is ready. See `.claude/rules/release-apk.md`.

## Pre-release checks

Run and make sure they pass, in order:

- [ ] `flutter pub get`
- [ ] `dart format .`
- [ ] `flutter analyze` (no errors)
- [ ] `flutter test` (all passing)

## Configuration

- [ ] **App version in `pubspec.yaml`** up to date (`version: x.y.z+build`).
- [ ] **App name** correct (`AndroidManifest.xml` / label).
- [ ] **Android permissions** reviewed — only what is needed (an offline app should not request unnecessary network access).
- [ ] **Keystore is not versioned** — `*.jks`/`*.keystore`, passwords and `key.properties` in `.gitignore`, never committed.
- [ ] **Passwords/secrets are not versioned.**

## Build

- [ ] Build with `flutter build apk --release`.
- [ ] Locate the APK at `build/app/outputs/flutter-apk/app-release.apk`.

## Documentation

- [ ] **README instructions** — how to generate the APK, where to find it, and how to configure signing locally.
