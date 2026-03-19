class CustomData {
  CustomData({
    required this.templateId,
    required this.channelId,
    required this.calendarEventId,
    required this.scopes,
    required this.serviceTerms,
  });

  final int templateId;
  final String channelId;
  final String calendarEventId;
  final List<String> scopes;
  final List<String> serviceTerms;
}
