# LW13 — Narxoz Geotagged Photo Diary

Flutter application for Laboratory Work 13: Multimedia and Device Hardware Features.

## Features
- Camera capture and gallery image selection
- Image optimization (`imageQuality: 80`, `maxWidth: 1080`)
- Runtime camera and GPS permission handling
- GPS latitude, longitude, altitude and accuracy
- Location services check with a shortcut to device location settings
- Local photo copies and offline diary metadata persistence
- Scrollable diary feed with thumbnails, captions, coordinates and timestamps

## Test / run

Open this folder in VS Code, then run:

```bash
flutter create .
flutter pub get
flutter run
```

`flutter create .` generates any missing Flutter platform scaffolding. The Android permission declarations and iOS usage-description keys are included in their platform configuration files.

For Android, verify that `android/app/src/main/AndroidManifest.xml` contains the camera, fine location, coarse location and READ_MEDIA_IMAGES permissions.

For iOS, verify `ios/Runner/Info.plist` contains:
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSLocationWhenInUseUsageDescription`

## Notes
- Test camera and GPS features on a physical device; simulators may not provide real camera/GPS hardware.
- Diary metadata is stored locally with SharedPreferences. Captured/selected photos are copied into the app documents directory, so entries remain available offline.
- On Android 13+, the system photo picker can grant access to selected images without broad gallery permission.
- iOS builds require macOS with Xcode.
