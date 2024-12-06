import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platformu için DefaultFirebaseOptions.web kullanın.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'MacOS platformu için DefaultFirebaseOptions.macos kullanın.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows platformu desteklenmiyor.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux platformu desteklenmiyor.',
        );
      default:
        throw UnsupportedError(
          'Desteklenmeyen platform: $defaultTargetPlatform',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUdvlnvQn1xZD8OCHir8LwK7w26ObD0zs',
    appId: '1:962738949203:ios:18492b4df2d808d6c24aa6',
    messagingSenderId: '962738949203',
    projectId: 'kur-ye-4a906',
    storageBucket: 'kur-ye-4a906.firebasestorage.app',
    iosBundleId: 'com.kurye.kurYe',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB40ltl3RloB4e9YMOqZ9WCO-vLqD1jIX4',
    appId: '1:962738949203:android:bb657f70eb146b5bc24aa6',
    messagingSenderId: '962738949203',
    projectId: 'kur-ye-4a906',
    storageBucket: 'kur-ye-4a906.firebasestorage.app',
  );
} 