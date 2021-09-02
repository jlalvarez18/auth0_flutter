part of auth0_flutter;

class BiometricsOptions {
  final IOSBiometricsOptions? _ios;
  final AndroidBiometricsOptions _android;

  BiometricsOptions({
    required AndroidBiometricsOptions android,
    IOSBiometricsOptions? ios,
  })  : _android = android,
        _ios = ios;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (Platform.isIOS) {
      final iosMap = _ios?.toMap();
      if (iosMap != null) {
        map.addAll(iosMap);
      }
    }

    if (Platform.isAndroid) {
      map.addAll(_android.toMap());
    }

    return map;
  }
}

class IOSBiometricsOptions {
  final String? cancelTitle;
  final String? fallbackTitle;

  IOSBiometricsOptions({
    this.cancelTitle,
    this.fallbackTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'cancelTitle': cancelTitle,
      'fallbackTitle': fallbackTitle,
    };
  }
}

class AndroidBiometricsOptions {
  /// Must be a valid number between 1 an 255
  final int requestCode;

  /// the text to use as description in the authentication screen. On some Android versions it might not be shown. Passing null will result in using the OS's default value.
  final String? description;

  AndroidBiometricsOptions({
    required this.requestCode,
    this.description,
  }) : assert(requestCode >= 1 && requestCode <= 255);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'requestCode': requestCode,
    };
  }
}
