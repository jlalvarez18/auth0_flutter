part of auth0_flutter_platform_interface;

class BiometricsOptions {
  /// iOS ///
  final String? cancelTitle;
  final String? fallbackTitle;

  /// Android ///
  final int requestCode;
  final String? description;

  /// requestCode: Must be a valid number between 1 an 255
  /// description: The text to use as description in the authentication screen. On some Android versions it might not be shown. Passing null will result in using the OS's default value.
  BiometricsOptions({
    required this.requestCode,
    this.description,
    this.cancelTitle,
    this.fallbackTitle,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (Platform.isIOS) {
      map['cancelTitle'] = cancelTitle;
      map['fallbackTitle'] = fallbackTitle;
    }

    if (Platform.isAndroid) {
      if (requestCode >= 1 && requestCode <= 255) {
        throw AssertionError(
            'requestCode must be a valid number between 1 and 255');
      }

      map['description'] = description;
      map['requestCode'] = requestCode;
    }

    return map;
  }
}
