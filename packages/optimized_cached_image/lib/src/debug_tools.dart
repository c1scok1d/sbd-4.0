import 'dart:developer' as developer;

mixin Logger {
  static bool enableLogging = false;
  static const String TAG = 'optimized_image_cache';
}

void log(String message) {
  if (Logger.enableLogging) {
    developer.log(message, name: Logger.TAG);
  }
}
