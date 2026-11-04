# SARA HOCAM — Native Android (Kotlin)

This is the native Android edition of SARA HOCAM, built with Kotlin and Jetpack Compose.

## Shared learning content

The Android module reads the existing repository content directly from the shared `content/` directory:
- `content/catalog.json`
- `content/lessons/{LEVEL}/{UNIT_ID}/{LESSON_ID}.json`

Lesson titles and lesson data are loaded at runtime from JSON. The app does not duplicate lesson text inside Kotlin source files.

## Open and build

Open the `android-kotlin/` folder in Android Studio (Hedgehog or newer), allow Gradle sync, then run the `app` configuration on an Android device or emulator.

Requirements:
- JDK 17
- Android SDK 35
- Android Gradle Plugin 8.7.3

Command-line build from this folder (after Gradle is installed):
`gradle :app:assembleDebug`

The Flutter application remains unchanged. This is a separate native Android implementation on its own feature branch.
