String? dateTimeWithoutMillis(DateTime? dateTime) {
  if (dateTime == null) return null;

  return '${dateTime.toIso8601String().substring(0, dateTime.toIso8601String().length - 5)}Z';
}
