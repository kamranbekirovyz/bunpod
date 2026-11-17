import 'dart:convert';
import 'dart:ui';

import 'package:bunpod/bunpod.dart';
import 'package:dio/dio.dart';

// Apple errors for countries without Apple Podcasts, so calls retry in the US.
class ApplePodcastsRemoteData {
  const ApplePodcastsRemoteData();

  static const String _fallbackCountry = 'us';

  Future<List<ChannelPreview>> topShows({int? genre, int limit = 30}) {
    return _withFallbackCountry((country) async {
      final Map<String, dynamic> body = await _get(
        ApplePodcastsEndpoints.topShows(
          country: country,
          limit: limit,
          genre: genre,
        ),
      );

      // `entry` is an object for one show, and missing for none.
      final Object? entry = body['feed']?['entry'];
      final List<dynamic> entries = switch (entry) {
        final List<dynamic> list => list,
        null => const [],
        _ => [entry],
      };

      return [for (final dynamic entry in entries) _fromChartEntry(entry)];
    });
  }

  Future<List<ChannelPreview>> search(String term, {int limit = 25}) {
    return _withFallbackCountry((country) async {
      final Map<String, dynamic> body = await _get(
        ApplePodcastsEndpoints.search(term, country: country, limit: limit),
      );

      final List<dynamic> results = body['results'] ?? [];

      return [for (final dynamic result in results) _fromSearchResult(result)];
    });
  }

  ChannelPreview _fromChartEntry(Map<String, dynamic> entry) {
    final List<dynamic> images = entry['im:image'] ?? [];

    return ChannelPreview(
      appleId: int.tryParse(entry['id']?['attributes']?['im:id'] ?? ''),
      title: entry['im:name']?['label'],
      author: entry['im:artist']?['label'],
      // Covers go smallest to largest.
      image: images.isEmpty ? null : _resize(images.last['label']),
    );
  }

  ChannelPreview _fromSearchResult(Map<String, dynamic> result) {
    return ChannelPreview(
      appleId: result['collectionId'],
      title: result['collectionName'],
      author: result['artistName'],
      image: result['artworkUrl600'] ?? _resize(result['artworkUrl100']),
    );
  }

  String? _resize(String? url) {
    return url?.replaceFirst(RegExp(r'/\d+x\d+bb\.\w+$'), '/600x600bb.jpg');
  }

  Future<T> _withFallbackCountry<T>(
    Future<T> Function(String country) call,
  ) async {
    final String country =
        PlatformDispatcher.instance.locale.countryCode?.toLowerCase() ??
        _fallbackCountry;

    try {
      return await call(country);
    } catch (error) {
      if (country == _fallbackCountry) rethrow;

      logarte.log('apple failed for "$country", using $_fallbackCountry');
      return call(_fallbackCountry);
    }
  }

  // Apple sometimes sends JSON as `text/javascript`.
  Future<Map<String, dynamic>> _get(Endpoint endpoint) async {
    final Response<String> response = await endpoint.send<String>(
      responseType: .plain,
    );

    return jsonDecode(response.data ?? '{}') as Map<String, dynamic>;
  }
}
