class Endpoint {
  final String url;
  final String method;
  final dynamic body;
  final Map<String, dynamic>? query;

  const Endpoint({
    required this.url,
    required this.method,
    this.body,
    this.query,
  });

  factory Endpoint.get({
    required String url,
    Map<String, dynamic>? query,
  }) {
    return Endpoint(
      url: Uri.encodeFull(url),
      method: 'GET',
      query: query,
    );
  }

  factory Endpoint.post({
    required String url,
    dynamic body,
  }) {
    return Endpoint(
      url: url,
      method: 'POST',
      body: body,
    );
  }

  factory Endpoint.put({
    required String url,
    dynamic body,
  }) {
    return Endpoint(
      url: url,
      method: 'PUT',
      body: body,
    );
  }

  factory Endpoint.patch({
    required String url,
    dynamic body,
  }) {
    return Endpoint(
      url: url,
      method: 'PATCH',
      body: body,
    );
  }

  factory Endpoint.delete({
    required String url,
  }) {
    return Endpoint(
      url: url,
      method: 'DELETE',
    );
  }
}
