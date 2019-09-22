part of auth0_flutter;

DateTime dateFromString(String value) {
  if (value == null) {
    return null;
  }

  final intValue = int.tryParse(value);
  if (intValue != null) {
    final seconds = intValue * Duration.millisecondsPerSecond;

    return DateTime.fromMillisecondsSinceEpoch(seconds, isUtc: true);
  }

  return DateTime.tryParse(value);
}
