// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RssFeedsTable extends RssFeeds with TableInfo<$RssFeedsTable, RssFeed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RssFeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _feedUrlMeta = const VerificationMeta(
    'feedUrl',
  );
  @override
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
    'feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<String> lastModified = GeneratedColumn<String>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshedAtMeta = const VerificationMeta(
    'refreshedAt',
  );
  @override
  late final GeneratedColumn<DateTime> refreshedAt = GeneratedColumn<DateTime>(
    'refreshed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    feedUrl,
    channelId,
    title,
    image,
    etag,
    lastModified,
    refreshedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rss_feeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<RssFeed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feed_url')) {
      context.handle(
        _feedUrlMeta,
        feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('refreshed_at')) {
      context.handle(
        _refreshedAtMeta,
        refreshedAt.isAcceptableOrUnknown(
          data['refreshed_at']!,
          _refreshedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedUrl};
  @override
  RssFeed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RssFeed(
      feedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_url'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified'],
      ),
      refreshedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}refreshed_at'],
      ),
    );
  }

  @override
  $RssFeedsTable createAlias(String alias) {
    return $RssFeedsTable(attachedDatabase, alias);
  }
}

class RssFeed extends DataClass implements Insertable<RssFeed> {
  final String feedUrl;
  final int? channelId;
  final String? title;
  final String? image;
  final String? etag;
  final String? lastModified;
  final DateTime? refreshedAt;
  const RssFeed({
    required this.feedUrl,
    this.channelId,
    this.title,
    this.image,
    this.etag,
    this.lastModified,
    this.refreshedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feed_url'] = Variable<String>(feedUrl);
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<int>(channelId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<String>(lastModified);
    }
    if (!nullToAbsent || refreshedAt != null) {
      map['refreshed_at'] = Variable<DateTime>(refreshedAt);
    }
    return map;
  }

  RssFeedsCompanion toCompanion(bool nullToAbsent) {
    return RssFeedsCompanion(
      feedUrl: Value(feedUrl),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      refreshedAt: refreshedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshedAt),
    );
  }

  factory RssFeed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RssFeed(
      feedUrl: serializer.fromJson<String>(json['feedUrl']),
      channelId: serializer.fromJson<int?>(json['channelId']),
      title: serializer.fromJson<String?>(json['title']),
      image: serializer.fromJson<String?>(json['image']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<String?>(json['lastModified']),
      refreshedAt: serializer.fromJson<DateTime?>(json['refreshedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'feedUrl': serializer.toJson<String>(feedUrl),
      'channelId': serializer.toJson<int?>(channelId),
      'title': serializer.toJson<String?>(title),
      'image': serializer.toJson<String?>(image),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<String?>(lastModified),
      'refreshedAt': serializer.toJson<DateTime?>(refreshedAt),
    };
  }

  RssFeed copyWith({
    String? feedUrl,
    Value<int?> channelId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> image = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<String?> lastModified = const Value.absent(),
    Value<DateTime?> refreshedAt = const Value.absent(),
  }) => RssFeed(
    feedUrl: feedUrl ?? this.feedUrl,
    channelId: channelId.present ? channelId.value : this.channelId,
    title: title.present ? title.value : this.title,
    image: image.present ? image.value : this.image,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    refreshedAt: refreshedAt.present ? refreshedAt.value : this.refreshedAt,
  );
  RssFeed copyWithCompanion(RssFeedsCompanion data) {
    return RssFeed(
      feedUrl: data.feedUrl.present ? data.feedUrl.value : this.feedUrl,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      title: data.title.present ? data.title.value : this.title,
      image: data.image.present ? data.image.value : this.image,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      refreshedAt: data.refreshedAt.present
          ? data.refreshedAt.value
          : this.refreshedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RssFeed(')
          ..write('feedUrl: $feedUrl, ')
          ..write('channelId: $channelId, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('refreshedAt: $refreshedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    feedUrl,
    channelId,
    title,
    image,
    etag,
    lastModified,
    refreshedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RssFeed &&
          other.feedUrl == this.feedUrl &&
          other.channelId == this.channelId &&
          other.title == this.title &&
          other.image == this.image &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.refreshedAt == this.refreshedAt);
}

class RssFeedsCompanion extends UpdateCompanion<RssFeed> {
  final Value<String> feedUrl;
  final Value<int?> channelId;
  final Value<String?> title;
  final Value<String?> image;
  final Value<String?> etag;
  final Value<String?> lastModified;
  final Value<DateTime?> refreshedAt;
  final Value<int> rowid;
  const RssFeedsCompanion({
    this.feedUrl = const Value.absent(),
    this.channelId = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.refreshedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RssFeedsCompanion.insert({
    required String feedUrl,
    this.channelId = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.refreshedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : feedUrl = Value(feedUrl);
  static Insertable<RssFeed> custom({
    Expression<String>? feedUrl,
    Expression<int>? channelId,
    Expression<String>? title,
    Expression<String>? image,
    Expression<String>? etag,
    Expression<String>? lastModified,
    Expression<DateTime>? refreshedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (feedUrl != null) 'feed_url': feedUrl,
      if (channelId != null) 'channel_id': channelId,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (refreshedAt != null) 'refreshed_at': refreshedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RssFeedsCompanion copyWith({
    Value<String>? feedUrl,
    Value<int?>? channelId,
    Value<String?>? title,
    Value<String?>? image,
    Value<String?>? etag,
    Value<String?>? lastModified,
    Value<DateTime?>? refreshedAt,
    Value<int>? rowid,
  }) {
    return RssFeedsCompanion(
      feedUrl: feedUrl ?? this.feedUrl,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      image: image ?? this.image,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      refreshedAt: refreshedAt ?? this.refreshedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<String>(lastModified.value);
    }
    if (refreshedAt.present) {
      map['refreshed_at'] = Variable<DateTime>(refreshedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RssFeedsCompanion(')
          ..write('feedUrl: $feedUrl, ')
          ..write('channelId: $channelId, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('refreshedAt: $refreshedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RssEpisodesTable extends RssEpisodes
    with TableInfo<$RssEpisodesTable, RssEpisode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RssEpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _feedUrlMeta = const VerificationMeta(
    'feedUrl',
  );
  @override
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
    'feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
    'guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioBytesMeta = const VerificationMeta(
    'audioBytes',
  );
  @override
  late final GeneratedColumn<int> audioBytes = GeneratedColumn<int>(
    'audio_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    feedUrl,
    guid,
    title,
    description,
    image,
    audioUrl,
    audioBytes,
    duration,
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rss_episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RssEpisode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feed_url')) {
      context.handle(
        _feedUrlMeta,
        feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('guid')) {
      context.handle(
        _guidMeta,
        guid.isAcceptableOrUnknown(data['guid']!, _guidMeta),
      );
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('audio_bytes')) {
      context.handle(
        _audioBytesMeta,
        audioBytes.isAcceptableOrUnknown(data['audio_bytes']!, _audioBytesMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedUrl, guid};
  @override
  RssEpisode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RssEpisode(
      feedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_url'],
      )!,
      guid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      audioBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_bytes'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
    );
  }

  @override
  $RssEpisodesTable createAlias(String alias) {
    return $RssEpisodesTable(attachedDatabase, alias);
  }
}

class RssEpisode extends DataClass implements Insertable<RssEpisode> {
  final String feedUrl;
  final String guid;
  final String? title;
  final String? description;
  final String? image;
  final String? audioUrl;
  final int? audioBytes;
  final int? duration;
  final DateTime? publishedAt;
  const RssEpisode({
    required this.feedUrl,
    required this.guid,
    this.title,
    this.description,
    this.image,
    this.audioUrl,
    this.audioBytes,
    this.duration,
    this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feed_url'] = Variable<String>(feedUrl);
    map['guid'] = Variable<String>(guid);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || audioBytes != null) {
      map['audio_bytes'] = Variable<int>(audioBytes);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    return map;
  }

  RssEpisodesCompanion toCompanion(bool nullToAbsent) {
    return RssEpisodesCompanion(
      feedUrl: Value(feedUrl),
      guid: Value(guid),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      audioBytes: audioBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(audioBytes),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
    );
  }

  factory RssEpisode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RssEpisode(
      feedUrl: serializer.fromJson<String>(json['feedUrl']),
      guid: serializer.fromJson<String>(json['guid']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      audioBytes: serializer.fromJson<int?>(json['audioBytes']),
      duration: serializer.fromJson<int?>(json['duration']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'feedUrl': serializer.toJson<String>(feedUrl),
      'guid': serializer.toJson<String>(guid),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'audioBytes': serializer.toJson<int?>(audioBytes),
      'duration': serializer.toJson<int?>(duration),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
    };
  }

  RssEpisode copyWith({
    String? feedUrl,
    String? guid,
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> image = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    Value<int?> audioBytes = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
  }) => RssEpisode(
    feedUrl: feedUrl ?? this.feedUrl,
    guid: guid ?? this.guid,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
    image: image.present ? image.value : this.image,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    audioBytes: audioBytes.present ? audioBytes.value : this.audioBytes,
    duration: duration.present ? duration.value : this.duration,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
  );
  RssEpisode copyWithCompanion(RssEpisodesCompanion data) {
    return RssEpisode(
      feedUrl: data.feedUrl.present ? data.feedUrl.value : this.feedUrl,
      guid: data.guid.present ? data.guid.value : this.guid,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      image: data.image.present ? data.image.value : this.image,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      audioBytes: data.audioBytes.present
          ? data.audioBytes.value
          : this.audioBytes,
      duration: data.duration.present ? data.duration.value : this.duration,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RssEpisode(')
          ..write('feedUrl: $feedUrl, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('audioBytes: $audioBytes, ')
          ..write('duration: $duration, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    feedUrl,
    guid,
    title,
    description,
    image,
    audioUrl,
    audioBytes,
    duration,
    publishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RssEpisode &&
          other.feedUrl == this.feedUrl &&
          other.guid == this.guid &&
          other.title == this.title &&
          other.description == this.description &&
          other.image == this.image &&
          other.audioUrl == this.audioUrl &&
          other.audioBytes == this.audioBytes &&
          other.duration == this.duration &&
          other.publishedAt == this.publishedAt);
}

class RssEpisodesCompanion extends UpdateCompanion<RssEpisode> {
  final Value<String> feedUrl;
  final Value<String> guid;
  final Value<String?> title;
  final Value<String?> description;
  final Value<String?> image;
  final Value<String?> audioUrl;
  final Value<int?> audioBytes;
  final Value<int?> duration;
  final Value<DateTime?> publishedAt;
  final Value<int> rowid;
  const RssEpisodesCompanion({
    this.feedUrl = const Value.absent(),
    this.guid = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.audioBytes = const Value.absent(),
    this.duration = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RssEpisodesCompanion.insert({
    required String feedUrl,
    required String guid,
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.audioBytes = const Value.absent(),
    this.duration = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : feedUrl = Value(feedUrl),
       guid = Value(guid);
  static Insertable<RssEpisode> custom({
    Expression<String>? feedUrl,
    Expression<String>? guid,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? image,
    Expression<String>? audioUrl,
    Expression<int>? audioBytes,
    Expression<int>? duration,
    Expression<DateTime>? publishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (feedUrl != null) 'feed_url': feedUrl,
      if (guid != null) 'guid': guid,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (audioBytes != null) 'audio_bytes': audioBytes,
      if (duration != null) 'duration': duration,
      if (publishedAt != null) 'published_at': publishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RssEpisodesCompanion copyWith({
    Value<String>? feedUrl,
    Value<String>? guid,
    Value<String?>? title,
    Value<String?>? description,
    Value<String?>? image,
    Value<String?>? audioUrl,
    Value<int?>? audioBytes,
    Value<int?>? duration,
    Value<DateTime?>? publishedAt,
    Value<int>? rowid,
  }) {
    return RssEpisodesCompanion(
      feedUrl: feedUrl ?? this.feedUrl,
      guid: guid ?? this.guid,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      audioUrl: audioUrl ?? this.audioUrl,
      audioBytes: audioBytes ?? this.audioBytes,
      duration: duration ?? this.duration,
      publishedAt: publishedAt ?? this.publishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (audioBytes.present) {
      map['audio_bytes'] = Variable<int>(audioBytes.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RssEpisodesCompanion(')
          ..write('feedUrl: $feedUrl, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('audioBytes: $audioBytes, ')
          ..write('duration: $duration, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EpisodeProgressTable extends EpisodeProgress
    with TableInfo<$EpisodeProgressTable, EpisodeProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodeProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _feedUrlMeta = const VerificationMeta(
    'feedUrl',
  );
  @override
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
    'feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
    'guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [feedUrl, guid, position, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episode_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<EpisodeProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feed_url')) {
      context.handle(
        _feedUrlMeta,
        feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('guid')) {
      context.handle(
        _guidMeta,
        guid.isAcceptableOrUnknown(data['guid']!, _guidMeta),
      );
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedUrl, guid};
  @override
  EpisodeProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeProgressData(
      feedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_url'],
      )!,
      guid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guid'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $EpisodeProgressTable createAlias(String alias) {
    return $EpisodeProgressTable(attachedDatabase, alias);
  }
}

class EpisodeProgressData extends DataClass
    implements Insertable<EpisodeProgressData> {
  final String feedUrl;
  final String guid;
  final int position;
  final bool completed;
  const EpisodeProgressData({
    required this.feedUrl,
    required this.guid,
    required this.position,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feed_url'] = Variable<String>(feedUrl);
    map['guid'] = Variable<String>(guid);
    map['position'] = Variable<int>(position);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  EpisodeProgressCompanion toCompanion(bool nullToAbsent) {
    return EpisodeProgressCompanion(
      feedUrl: Value(feedUrl),
      guid: Value(guid),
      position: Value(position),
      completed: Value(completed),
    );
  }

  factory EpisodeProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodeProgressData(
      feedUrl: serializer.fromJson<String>(json['feedUrl']),
      guid: serializer.fromJson<String>(json['guid']),
      position: serializer.fromJson<int>(json['position']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'feedUrl': serializer.toJson<String>(feedUrl),
      'guid': serializer.toJson<String>(guid),
      'position': serializer.toJson<int>(position),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  EpisodeProgressData copyWith({
    String? feedUrl,
    String? guid,
    int? position,
    bool? completed,
  }) => EpisodeProgressData(
    feedUrl: feedUrl ?? this.feedUrl,
    guid: guid ?? this.guid,
    position: position ?? this.position,
    completed: completed ?? this.completed,
  );
  EpisodeProgressData copyWithCompanion(EpisodeProgressCompanion data) {
    return EpisodeProgressData(
      feedUrl: data.feedUrl.present ? data.feedUrl.value : this.feedUrl,
      guid: data.guid.present ? data.guid.value : this.guid,
      position: data.position.present ? data.position.value : this.position,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeProgressData(')
          ..write('feedUrl: $feedUrl, ')
          ..write('guid: $guid, ')
          ..write('position: $position, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(feedUrl, guid, position, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeProgressData &&
          other.feedUrl == this.feedUrl &&
          other.guid == this.guid &&
          other.position == this.position &&
          other.completed == this.completed);
}

class EpisodeProgressCompanion extends UpdateCompanion<EpisodeProgressData> {
  final Value<String> feedUrl;
  final Value<String> guid;
  final Value<int> position;
  final Value<bool> completed;
  final Value<int> rowid;
  const EpisodeProgressCompanion({
    this.feedUrl = const Value.absent(),
    this.guid = const Value.absent(),
    this.position = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EpisodeProgressCompanion.insert({
    required String feedUrl,
    required String guid,
    required int position,
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : feedUrl = Value(feedUrl),
       guid = Value(guid),
       position = Value(position);
  static Insertable<EpisodeProgressData> custom({
    Expression<String>? feedUrl,
    Expression<String>? guid,
    Expression<int>? position,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (feedUrl != null) 'feed_url': feedUrl,
      if (guid != null) 'guid': guid,
      if (position != null) 'position': position,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodeProgressCompanion copyWith({
    Value<String>? feedUrl,
    Value<String>? guid,
    Value<int>? position,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return EpisodeProgressCompanion(
      feedUrl: feedUrl ?? this.feedUrl,
      guid: guid ?? this.guid,
      position: position ?? this.position,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeProgressCompanion(')
          ..write('feedUrl: $feedUrl, ')
          ..write('guid: $guid, ')
          ..write('position: $position, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appleIdMeta = const VerificationMeta(
    'appleId',
  );
  @override
  late final GeneratedColumn<int> appleId = GeneratedColumn<int>(
    'apple_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feedUrlMeta = const VerificationMeta(
    'feedUrl',
  );
  @override
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
    'feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastEpisodeAtMeta = const VerificationMeta(
    'lastEpisodeAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastEpisodeAt =
      GeneratedColumn<DateTime>(
        'last_episode_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    channelId,
    appleId,
    feedUrl,
    title,
    author,
    description,
    image,
    language,
    lastEpisodeAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('apple_id')) {
      context.handle(
        _appleIdMeta,
        appleId.isAcceptableOrUnknown(data['apple_id']!, _appleIdMeta),
      );
    }
    if (data.containsKey('feed_url')) {
      context.handle(
        _feedUrlMeta,
        feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('last_episode_at')) {
      context.handle(
        _lastEpisodeAtMeta,
        lastEpisodeAt.isAcceptableOrUnknown(
          data['last_episode_at']!,
          _lastEpisodeAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_id'],
      )!,
      appleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apple_id'],
      ),
      feedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      lastEpisodeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_episode_at'],
      ),
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int channelId;
  final int? appleId;
  final String feedUrl;
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final DateTime? lastEpisodeAt;
  const Subscription({
    required this.channelId,
    this.appleId,
    required this.feedUrl,
    this.title,
    this.author,
    this.description,
    this.image,
    this.language,
    this.lastEpisodeAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<int>(channelId);
    if (!nullToAbsent || appleId != null) {
      map['apple_id'] = Variable<int>(appleId);
    }
    map['feed_url'] = Variable<String>(feedUrl);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || lastEpisodeAt != null) {
      map['last_episode_at'] = Variable<DateTime>(lastEpisodeAt);
    }
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      channelId: Value(channelId),
      appleId: appleId == null && nullToAbsent
          ? const Value.absent()
          : Value(appleId),
      feedUrl: Value(feedUrl),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      lastEpisodeAt: lastEpisodeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEpisodeAt),
    );
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      channelId: serializer.fromJson<int>(json['channelId']),
      appleId: serializer.fromJson<int?>(json['appleId']),
      feedUrl: serializer.fromJson<String>(json['feedUrl']),
      title: serializer.fromJson<String?>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      language: serializer.fromJson<String?>(json['language']),
      lastEpisodeAt: serializer.fromJson<DateTime?>(json['lastEpisodeAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<int>(channelId),
      'appleId': serializer.toJson<int?>(appleId),
      'feedUrl': serializer.toJson<String>(feedUrl),
      'title': serializer.toJson<String?>(title),
      'author': serializer.toJson<String?>(author),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
      'language': serializer.toJson<String?>(language),
      'lastEpisodeAt': serializer.toJson<DateTime?>(lastEpisodeAt),
    };
  }

  Subscription copyWith({
    int? channelId,
    Value<int?> appleId = const Value.absent(),
    String? feedUrl,
    Value<String?> title = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> image = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<DateTime?> lastEpisodeAt = const Value.absent(),
  }) => Subscription(
    channelId: channelId ?? this.channelId,
    appleId: appleId.present ? appleId.value : this.appleId,
    feedUrl: feedUrl ?? this.feedUrl,
    title: title.present ? title.value : this.title,
    author: author.present ? author.value : this.author,
    description: description.present ? description.value : this.description,
    image: image.present ? image.value : this.image,
    language: language.present ? language.value : this.language,
    lastEpisodeAt: lastEpisodeAt.present
        ? lastEpisodeAt.value
        : this.lastEpisodeAt,
  );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      appleId: data.appleId.present ? data.appleId.value : this.appleId,
      feedUrl: data.feedUrl.present ? data.feedUrl.value : this.feedUrl,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      description: data.description.present
          ? data.description.value
          : this.description,
      image: data.image.present ? data.image.value : this.image,
      language: data.language.present ? data.language.value : this.language,
      lastEpisodeAt: data.lastEpisodeAt.present
          ? data.lastEpisodeAt.value
          : this.lastEpisodeAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('channelId: $channelId, ')
          ..write('appleId: $appleId, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('language: $language, ')
          ..write('lastEpisodeAt: $lastEpisodeAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    channelId,
    appleId,
    feedUrl,
    title,
    author,
    description,
    image,
    language,
    lastEpisodeAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.channelId == this.channelId &&
          other.appleId == this.appleId &&
          other.feedUrl == this.feedUrl &&
          other.title == this.title &&
          other.author == this.author &&
          other.description == this.description &&
          other.image == this.image &&
          other.language == this.language &&
          other.lastEpisodeAt == this.lastEpisodeAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> channelId;
  final Value<int?> appleId;
  final Value<String> feedUrl;
  final Value<String?> title;
  final Value<String?> author;
  final Value<String?> description;
  final Value<String?> image;
  final Value<String?> language;
  final Value<DateTime?> lastEpisodeAt;
  const SubscriptionsCompanion({
    this.channelId = const Value.absent(),
    this.appleId = const Value.absent(),
    this.feedUrl = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.language = const Value.absent(),
    this.lastEpisodeAt = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.channelId = const Value.absent(),
    this.appleId = const Value.absent(),
    required String feedUrl,
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.language = const Value.absent(),
    this.lastEpisodeAt = const Value.absent(),
  }) : feedUrl = Value(feedUrl);
  static Insertable<Subscription> custom({
    Expression<int>? channelId,
    Expression<int>? appleId,
    Expression<String>? feedUrl,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? description,
    Expression<String>? image,
    Expression<String>? language,
    Expression<DateTime>? lastEpisodeAt,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (appleId != null) 'apple_id': appleId,
      if (feedUrl != null) 'feed_url': feedUrl,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (language != null) 'language': language,
      if (lastEpisodeAt != null) 'last_episode_at': lastEpisodeAt,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<int>? channelId,
    Value<int?>? appleId,
    Value<String>? feedUrl,
    Value<String?>? title,
    Value<String?>? author,
    Value<String?>? description,
    Value<String?>? image,
    Value<String?>? language,
    Value<DateTime?>? lastEpisodeAt,
  }) {
    return SubscriptionsCompanion(
      channelId: channelId ?? this.channelId,
      appleId: appleId ?? this.appleId,
      feedUrl: feedUrl ?? this.feedUrl,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      image: image ?? this.image,
      language: language ?? this.language,
      lastEpisodeAt: lastEpisodeAt ?? this.lastEpisodeAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (appleId.present) {
      map['apple_id'] = Variable<int>(appleId.value);
    }
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (lastEpisodeAt.present) {
      map['last_episode_at'] = Variable<DateTime>(lastEpisodeAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('channelId: $channelId, ')
          ..write('appleId: $appleId, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('language: $language, ')
          ..write('lastEpisodeAt: $lastEpisodeAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RssFeedsTable rssFeeds = $RssFeedsTable(this);
  late final $RssEpisodesTable rssEpisodes = $RssEpisodesTable(this);
  late final $EpisodeProgressTable episodeProgress = $EpisodeProgressTable(
    this,
  );
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final Index rssEpisodesFeedDate = Index(
    'rss_episodes_feed_date',
    'CREATE INDEX rss_episodes_feed_date ON rss_episodes (feed_url, published_at)',
  );
  late final Index rssEpisodesDate = Index(
    'rss_episodes_date',
    'CREATE INDEX rss_episodes_date ON rss_episodes (published_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rssFeeds,
    rssEpisodes,
    episodeProgress,
    subscriptions,
    rssEpisodesFeedDate,
    rssEpisodesDate,
  ];
}

typedef $$RssFeedsTableCreateCompanionBuilder = RssFeedsCompanion Function({
  required String feedUrl,
  Value<int?> channelId,
  Value<String?> title,
  Value<String?> image,
  Value<String?> etag,
  Value<String?> lastModified,
  Value<DateTime?> refreshedAt,
  Value<int> rowid,
});
typedef $$RssFeedsTableUpdateCompanionBuilder = RssFeedsCompanion Function({
  Value<String> feedUrl,
  Value<int?> channelId,
  Value<String?> title,
  Value<String?> image,
  Value<String?> etag,
  Value<String?> lastModified,
  Value<DateTime?> refreshedAt,
  Value<int> rowid,
});

class $$RssFeedsTableFilterComposer
    extends Composer<_$AppDatabase, $RssFeedsTable> {
  $$RssFeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RssFeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $RssFeedsTable> {
  $$RssFeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RssFeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RssFeedsTable> {
  $$RssFeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get feedUrl =>
      $composableBuilder(column: $table.feedUrl, builder: (column) => column);

  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get refreshedAt => $composableBuilder(
    column: $table.refreshedAt,
    builder: (column) => column,
  );
}

class $$RssFeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RssFeedsTable,
          RssFeed,
          $$RssFeedsTableFilterComposer,
          $$RssFeedsTableOrderingComposer,
          $$RssFeedsTableAnnotationComposer,
          $$RssFeedsTableCreateCompanionBuilder,
          $$RssFeedsTableUpdateCompanionBuilder,
          (RssFeed, BaseReferences<_$AppDatabase, $RssFeedsTable, RssFeed>),
          RssFeed,
          PrefetchHooks Function()
        > {
  $$RssFeedsTableTableManager(_$AppDatabase db, $RssFeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RssFeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RssFeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RssFeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> feedUrl = const Value.absent(),
                Value<int?> channelId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<DateTime?> refreshedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RssFeedsCompanion(
                feedUrl: feedUrl,
                channelId: channelId,
                title: title,
                image: image,
                etag: etag,
                lastModified: lastModified,
                refreshedAt: refreshedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String feedUrl,
                Value<int?> channelId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<DateTime?> refreshedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RssFeedsCompanion.insert(
                feedUrl: feedUrl,
                channelId: channelId,
                title: title,
                image: image,
                etag: etag,
                lastModified: lastModified,
                refreshedAt: refreshedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RssFeedsTable, RssFeed>(table),
                  BaseReferences<_$AppDatabase, $RssFeedsTable, RssFeed>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RssFeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RssFeedsTable,
      RssFeed,
      $$RssFeedsTableFilterComposer,
      $$RssFeedsTableOrderingComposer,
      $$RssFeedsTableAnnotationComposer,
      $$RssFeedsTableCreateCompanionBuilder,
      $$RssFeedsTableUpdateCompanionBuilder,
      (RssFeed, BaseReferences<_$AppDatabase, $RssFeedsTable, RssFeed>),
      RssFeed,
      PrefetchHooks Function()
    >;
typedef $$RssEpisodesTableCreateCompanionBuilder =
    RssEpisodesCompanion Function({
      required String feedUrl,
      required String guid,
      Value<String?> title,
      Value<String?> description,
      Value<String?> image,
      Value<String?> audioUrl,
      Value<int?> audioBytes,
      Value<int?> duration,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });
typedef $$RssEpisodesTableUpdateCompanionBuilder =
    RssEpisodesCompanion Function({
      Value<String> feedUrl,
      Value<String> guid,
      Value<String?> title,
      Value<String?> description,
      Value<String?> image,
      Value<String?> audioUrl,
      Value<int?> audioBytes,
      Value<int?> duration,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });

class $$RssEpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $RssEpisodesTable> {
  $$RssEpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioBytes => $composableBuilder(
    column: $table.audioBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RssEpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $RssEpisodesTable> {
  $$RssEpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioBytes => $composableBuilder(
    column: $table.audioBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RssEpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RssEpisodesTable> {
  $$RssEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get feedUrl =>
      $composableBuilder(column: $table.feedUrl, builder: (column) => column);

  GeneratedColumn<String> get guid =>
      $composableBuilder(column: $table.guid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get audioBytes => $composableBuilder(
    column: $table.audioBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );
}

class $$RssEpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RssEpisodesTable,
          RssEpisode,
          $$RssEpisodesTableFilterComposer,
          $$RssEpisodesTableOrderingComposer,
          $$RssEpisodesTableAnnotationComposer,
          $$RssEpisodesTableCreateCompanionBuilder,
          $$RssEpisodesTableUpdateCompanionBuilder,
          (
            RssEpisode,
            BaseReferences<_$AppDatabase, $RssEpisodesTable, RssEpisode>,
          ),
          RssEpisode,
          PrefetchHooks Function()
        > {
  $$RssEpisodesTableTableManager(_$AppDatabase db, $RssEpisodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RssEpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RssEpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RssEpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> feedUrl = const Value.absent(),
                Value<String> guid = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int?> audioBytes = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RssEpisodesCompanion(
                feedUrl: feedUrl,
                guid: guid,
                title: title,
                description: description,
                image: image,
                audioUrl: audioUrl,
                audioBytes: audioBytes,
                duration: duration,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String feedUrl,
                required String guid,
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int?> audioBytes = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RssEpisodesCompanion.insert(
                feedUrl: feedUrl,
                guid: guid,
                title: title,
                description: description,
                image: image,
                audioUrl: audioUrl,
                audioBytes: audioBytes,
                duration: duration,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RssEpisodesTable, RssEpisode>(table),
                  BaseReferences<_$AppDatabase, $RssEpisodesTable, RssEpisode>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RssEpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RssEpisodesTable,
      RssEpisode,
      $$RssEpisodesTableFilterComposer,
      $$RssEpisodesTableOrderingComposer,
      $$RssEpisodesTableAnnotationComposer,
      $$RssEpisodesTableCreateCompanionBuilder,
      $$RssEpisodesTableUpdateCompanionBuilder,
      (
        RssEpisode,
        BaseReferences<_$AppDatabase, $RssEpisodesTable, RssEpisode>,
      ),
      RssEpisode,
      PrefetchHooks Function()
    >;
typedef $$EpisodeProgressTableCreateCompanionBuilder =
    EpisodeProgressCompanion Function({
      required String feedUrl,
      required String guid,
      required int position,
      Value<bool> completed,
      Value<int> rowid,
    });
typedef $$EpisodeProgressTableUpdateCompanionBuilder =
    EpisodeProgressCompanion Function({
      Value<String> feedUrl,
      Value<String> guid,
      Value<int> position,
      Value<bool> completed,
      Value<int> rowid,
    });

class $$EpisodeProgressTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodeProgressTable> {
  $$EpisodeProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EpisodeProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodeProgressTable> {
  $$EpisodeProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EpisodeProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodeProgressTable> {
  $$EpisodeProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get feedUrl =>
      $composableBuilder(column: $table.feedUrl, builder: (column) => column);

  GeneratedColumn<String> get guid =>
      $composableBuilder(column: $table.guid, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$EpisodeProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodeProgressTable,
          EpisodeProgressData,
          $$EpisodeProgressTableFilterComposer,
          $$EpisodeProgressTableOrderingComposer,
          $$EpisodeProgressTableAnnotationComposer,
          $$EpisodeProgressTableCreateCompanionBuilder,
          $$EpisodeProgressTableUpdateCompanionBuilder,
          (
            EpisodeProgressData,
            BaseReferences<
              _$AppDatabase,
              $EpisodeProgressTable,
              EpisodeProgressData
            >,
          ),
          EpisodeProgressData,
          PrefetchHooks Function()
        > {
  $$EpisodeProgressTableTableManager(
    _$AppDatabase db,
    $EpisodeProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodeProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodeProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodeProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> feedUrl = const Value.absent(),
                Value<String> guid = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodeProgressCompanion(
                feedUrl: feedUrl,
                guid: guid,
                position: position,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String feedUrl,
                required String guid,
                required int position,
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodeProgressCompanion.insert(
                feedUrl: feedUrl,
                guid: guid,
                position: position,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EpisodeProgressTable, EpisodeProgressData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $EpisodeProgressTable,
                    EpisodeProgressData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EpisodeProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodeProgressTable,
      EpisodeProgressData,
      $$EpisodeProgressTableFilterComposer,
      $$EpisodeProgressTableOrderingComposer,
      $$EpisodeProgressTableAnnotationComposer,
      $$EpisodeProgressTableCreateCompanionBuilder,
      $$EpisodeProgressTableUpdateCompanionBuilder,
      (
        EpisodeProgressData,
        BaseReferences<
          _$AppDatabase,
          $EpisodeProgressTable,
          EpisodeProgressData
        >,
      ),
      EpisodeProgressData,
      PrefetchHooks Function()
    >;
typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> channelId,
      Value<int?> appleId,
      required String feedUrl,
      Value<String?> title,
      Value<String?> author,
      Value<String?> description,
      Value<String?> image,
      Value<String?> language,
      Value<DateTime?> lastEpisodeAt,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> channelId,
      Value<int?> appleId,
      Value<String> feedUrl,
      Value<String?> title,
      Value<String?> author,
      Value<String?> description,
      Value<String?> image,
      Value<String?> language,
      Value<DateTime?> lastEpisodeAt,
    });

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appleId => $composableBuilder(
    column: $table.appleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastEpisodeAt => $composableBuilder(
    column: $table.lastEpisodeAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appleId => $composableBuilder(
    column: $table.appleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastEpisodeAt => $composableBuilder(
    column: $table.lastEpisodeAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<int> get appleId =>
      $composableBuilder(column: $table.appleId, builder: (column) => column);

  GeneratedColumn<String> get feedUrl =>
      $composableBuilder(column: $table.feedUrl, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEpisodeAt => $composableBuilder(
    column: $table.lastEpisodeAt,
    builder: (column) => column,
  );
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          Subscription,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (
            Subscription,
            BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>,
          ),
          Subscription,
          PrefetchHooks Function()
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> channelId = const Value.absent(),
                Value<int?> appleId = const Value.absent(),
                Value<String> feedUrl = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime?> lastEpisodeAt = const Value.absent(),
              }) => SubscriptionsCompanion(
                channelId: channelId,
                appleId: appleId,
                feedUrl: feedUrl,
                title: title,
                author: author,
                description: description,
                image: image,
                language: language,
                lastEpisodeAt: lastEpisodeAt,
              ),
          createCompanionCallback:
              ({
                Value<int> channelId = const Value.absent(),
                Value<int?> appleId = const Value.absent(),
                required String feedUrl,
                Value<String?> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime?> lastEpisodeAt = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                channelId: channelId,
                appleId: appleId,
                feedUrl: feedUrl,
                title: title,
                author: author,
                description: description,
                image: image,
                language: language,
                lastEpisodeAt: lastEpisodeAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionsTable, Subscription>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SubscriptionsTable,
                    Subscription
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      Subscription,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (
        Subscription,
        BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>,
      ),
      Subscription,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RssFeedsTableTableManager get rssFeeds =>
      $$RssFeedsTableTableManager(_db, _db.rssFeeds);
  $$RssEpisodesTableTableManager get rssEpisodes =>
      $$RssEpisodesTableTableManager(_db, _db.rssEpisodes);
  $$EpisodeProgressTableTableManager get episodeProgress =>
      $$EpisodeProgressTableTableManager(_db, _db.episodeProgress);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
}
