part of auth0_flutter;

DateTime dateFromString(String value) {
  if (value == null) {
    return null;
  }

  final intValue = int.tryParse(value);
  if (intValue != null) {
    final milliseconds = intValue * Duration.millisecondsPerSecond;

    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  return DateTime.tryParse(value);
}

DateTime dateFromDouble(double value) {
  if (value == null) {
    return null;
  }

  final intValue = value.toInt();
  final milliseconds = intValue * Duration.millisecondsPerMinute;

  return DateTime.fromMillisecondsSinceEpoch(milliseconds);
}
