# SARA HOCAM — Native Android (Kotlin)

This is the native Android edition of SARA HOCAM, built with Kotlin and Jetpack Compose.

## Shared learning content

The Android module reads the repository's existing content directly from the shared `content/` directory:
- `content/catalog.json`
- `content/lessons/{LEVEL}/{UNIT_ID}/{LESSON_ID}.json`

Lesson titles and lesson data are loaded at runtime from JSON. Lesson content is not duplicated inside Kotlin source files. The automated workflow validates every lesson path, JSON syntax, and lesson ID against the catalog before building the APK.

## Implemented in this starter edition

- Arabic right-to-left interface and SARA HOCAM branding.
- Home screen with level filters (A1–C2), unit search, and course catalog.
- Unit lesson list and JSON-driven lesson details.
- Lesson goals, grammar/rule text, vocabulary (when present), examples, dialogue, and speaking task (when present).
- Multiple-choice questions with answer checking and explanations.
- Local lesson-completion tracking using Android SharedPreferences.
- Course progress indicator on the home screen.

## Build and install

Open the `android-kotlin/` folder in Android Studio, allow Gradle sync, then run the `app` configuration on an Android device or emulator.

Requirements:
- JDK 17
- Android SDK 35
- Android Gradle Plugin 8.7.3
- Gradle 8.9

A debug APK is built automatically by GitHub Actions and uploaded as the artifact `sara-hocam-android-debug` on each relevant push. Open the repository's Actions tab, select the latest **Build SARA HOCAM Android (Kotlin)** run, and download its artifact.

Command-line build from this folder (after Gradle is installed):
`gradle :app:assembleDebug`

The Flutter application and original lesson JSON files remain unchanged. This is a separate native Android implementation on its own feature branch. It is an initial native edition; advanced Flutter features such as full vocabulary browsing, conversation practice, assessment dashboards, and missed-question analytics still need dedicated Kotlin screens before feature parity.
