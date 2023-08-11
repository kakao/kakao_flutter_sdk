class UserApiParameter {
  final List<String>? properties;
  final String? result;
  final List<String> tags;
  final List<String>? serviceTerms;
  final List<String> scopes;

  UserApiParameter({
    this.properties = const [],
    this.result,
    this.tags = const [],
    this.serviceTerms = const [],
    this.scopes = const [],
  });
}
