class Endpoint {
  const Endpoint({
    required this.url,
    this.query,
    this.headers,
  });

  final String url;
  final Map<String, dynamic>? query;
  final Map<String, String>? headers;
}
