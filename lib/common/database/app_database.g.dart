// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedFeedsTable extends CachedFeeds
    with TableInfo<$CachedFeedsTable, CachedFeed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _feedKeyMeta = const VerificationMeta(
    'feedKey',
  );
  @override
  late final GeneratedColumn<int> feedKey = GeneratedColumn<int>(
    'feed_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [feedKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_feeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFeed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feed_key')) {
      context.handle(
        _feedKeyMeta,
        feedKey.isAcceptableOrUnknown(data['feed_key']!, _feedKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedKey};
  @override
  CachedFeed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFeed(
      feedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feed_key'],
      )!,
    );
  }

  @override
  $CachedFeedsTable createAlias(String alias) {
    return $CachedFeedsTable(attachedDatabase, alias);
  }
}

class CachedFeed extends DataClass implements Insertable<CachedFeed> {
  final int feedKey;
  const CachedFeed({required this.feedKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feed_key'] = Variable<int>(feedKey);
    return map;
  }

  CachedFeedsCompanion toCompanion(bool nullToAbsent) {
    return CachedFeedsCompanion(feedKey: Value(feedKey));
  }

  factory CachedFeed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFeed(feedKey: serializer.fromJson<int>(json['feedKey']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'feedKey': serializer.toJson<int>(feedKey)};
  }

  CachedFeed copyWith({int? feedKey}) =>
      CachedFeed(feedKey: feedKey ?? this.feedKey);
  CachedFeed copyWithCompanion(CachedFeedsCompanion data) {
    return CachedFeed(
      feedKey: data.feedKey.present ? data.feedKey.value : this.feedKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFeed(')
          ..write('feedKey: $feedKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => feedKey.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFeed && other.feedKey == this.feedKey);
}

class CachedFeedsCompanion extends UpdateCompanion<CachedFeed> {
  final Value<int> feedKey;
  const CachedFeedsCompanion({this.feedKey = const Value.absent()});
  CachedFeedsCompanion.insert({this.feedKey = const Value.absent()});
  static Insertable<CachedFeed> custom({Expression<int>? feedKey}) {
    return RawValuesInsertable({if (feedKey != null) 'feed_key': feedKey});
  }

  CachedFeedsCompanion copyWith({Value<int>? feedKey}) {
    return CachedFeedsCompanion(feedKey: feedKey ?? this.feedKey);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (feedKey.present) {
      map['feed_key'] = Variable<int>(feedKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFeedsCompanion(')
          ..write('feedKey: $feedKey')
          ..write(')'))
        .toString();
  }
}

class $CachedEpisodesTable extends CachedEpisodes
    with TableInfo<$CachedEpisodesTable, CachedEpisode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedEpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [episodeId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedEpisode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {episodeId};
  @override
  CachedEpisode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedEpisode(
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $CachedEpisodesTable createAlias(String alias) {
    return $CachedEpisodesTable(attachedDatabase, alias);
  }
}

class CachedEpisode extends DataClass implements Insertable<CachedEpisode> {
  final int episodeId;
  final String data;
  const CachedEpisode({required this.episodeId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['episode_id'] = Variable<int>(episodeId);
    map['data'] = Variable<String>(data);
    return map;
  }

  CachedEpisodesCompanion toCompanion(bool nullToAbsent) {
    return CachedEpisodesCompanion(
      episodeId: Value(episodeId),
      data: Value(data),
    );
  }

  factory CachedEpisode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedEpisode(
      episodeId: serializer.fromJson<int>(json['episodeId']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'episodeId': serializer.toJson<int>(episodeId),
      'data': serializer.toJson<String>(data),
    };
  }

  CachedEpisode copyWith({int? episodeId, String? data}) => CachedEpisode(
    episodeId: episodeId ?? this.episodeId,
    data: data ?? this.data,
  );
  CachedEpisode copyWithCompanion(CachedEpisodesCompanion data) {
    return CachedEpisode(
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedEpisode(')
          ..write('episodeId: $episodeId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(episodeId, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedEpisode &&
          other.episodeId == this.episodeId &&
          other.data == this.data);
}

class CachedEpisodesCompanion extends UpdateCompanion<CachedEpisode> {
  final Value<int> episodeId;
  final Value<String> data;
  const CachedEpisodesCompanion({
    this.episodeId = const Value.absent(),
    this.data = const Value.absent(),
  });
  CachedEpisodesCompanion.insert({
    this.episodeId = const Value.absent(),
    required String data,
  }) : data = Value(data);
  static Insertable<CachedEpisode> custom({
    Expression<int>? episodeId,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (episodeId != null) 'episode_id': episodeId,
      if (data != null) 'data': data,
    });
  }

  CachedEpisodesCompanion copyWith({
    Value<int>? episodeId,
    Value<String>? data,
  }) {
    return CachedEpisodesCompanion(
      episodeId: episodeId ?? this.episodeId,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedEpisodesCompanion(')
          ..write('episodeId: $episodeId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $CachedFeedEntriesTable extends CachedFeedEntries
    with TableInfo<$CachedFeedEntriesTable, CachedFeedEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFeedEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _feedKeyMeta = const VerificationMeta(
    'feedKey',
  );
  @override
  late final GeneratedColumn<int> feedKey = GeneratedColumn<int>(
    'feed_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_feeds (feed_key)',
    ),
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_episodes (episode_id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [feedKey, episodeId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_feed_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFeedEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feed_key')) {
      context.handle(
        _feedKeyMeta,
        feedKey.isAcceptableOrUnknown(data['feed_key']!, _feedKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_feedKeyMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_episodeIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedKey, episodeId};
  @override
  CachedFeedEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFeedEntry(
      feedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feed_key'],
      )!,
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CachedFeedEntriesTable createAlias(String alias) {
    return $CachedFeedEntriesTable(attachedDatabase, alias);
  }
}

class CachedFeedEntry extends DataClass implements Insertable<CachedFeedEntry> {
  final int feedKey;
  final int episodeId;
  final int sortOrder;
  const CachedFeedEntry({
    required this.feedKey,
    required this.episodeId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feed_key'] = Variable<int>(feedKey);
    map['episode_id'] = Variable<int>(episodeId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CachedFeedEntriesCompanion toCompanion(bool nullToAbsent) {
    return CachedFeedEntriesCompanion(
      feedKey: Value(feedKey),
      episodeId: Value(episodeId),
      sortOrder: Value(sortOrder),
    );
  }

  factory CachedFeedEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFeedEntry(
      feedKey: serializer.fromJson<int>(json['feedKey']),
      episodeId: serializer.fromJson<int>(json['episodeId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'feedKey': serializer.toJson<int>(feedKey),
      'episodeId': serializer.toJson<int>(episodeId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CachedFeedEntry copyWith({int? feedKey, int? episodeId, int? sortOrder}) =>
      CachedFeedEntry(
        feedKey: feedKey ?? this.feedKey,
        episodeId: episodeId ?? this.episodeId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  CachedFeedEntry copyWithCompanion(CachedFeedEntriesCompanion data) {
    return CachedFeedEntry(
      feedKey: data.feedKey.present ? data.feedKey.value : this.feedKey,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFeedEntry(')
          ..write('feedKey: $feedKey, ')
          ..write('episodeId: $episodeId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(feedKey, episodeId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFeedEntry &&
          other.feedKey == this.feedKey &&
          other.episodeId == this.episodeId &&
          other.sortOrder == this.sortOrder);
}

class CachedFeedEntriesCompanion extends UpdateCompanion<CachedFeedEntry> {
  final Value<int> feedKey;
  final Value<int> episodeId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CachedFeedEntriesCompanion({
    this.feedKey = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedFeedEntriesCompanion.insert({
    required int feedKey,
    required int episodeId,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : feedKey = Value(feedKey),
       episodeId = Value(episodeId),
       sortOrder = Value(sortOrder);
  static Insertable<CachedFeedEntry> custom({
    Expression<int>? feedKey,
    Expression<int>? episodeId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (feedKey != null) 'feed_key': feedKey,
      if (episodeId != null) 'episode_id': episodeId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedFeedEntriesCompanion copyWith({
    Value<int>? feedKey,
    Value<int>? episodeId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CachedFeedEntriesCompanion(
      feedKey: feedKey ?? this.feedKey,
      episodeId: episodeId ?? this.episodeId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (feedKey.present) {
      map['feed_key'] = Variable<int>(feedKey.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFeedEntriesCompanion(')
          ..write('feedKey: $feedKey, ')
          ..write('episodeId: $episodeId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSubscriptionsTable extends CachedSubscriptions
    with TableInfo<$CachedSubscriptionsTable, CachedSubscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSubscriptionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [channelId, sortOrder, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSubscription> instance, {
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
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId};
  @override
  CachedSubscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSubscription(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $CachedSubscriptionsTable createAlias(String alias) {
    return $CachedSubscriptionsTable(attachedDatabase, alias);
  }
}

class CachedSubscription extends DataClass
    implements Insertable<CachedSubscription> {
  final int channelId;
  final int sortOrder;
  final String data;
  const CachedSubscription({
    required this.channelId,
    required this.sortOrder,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<int>(channelId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['data'] = Variable<String>(data);
    return map;
  }

  CachedSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return CachedSubscriptionsCompanion(
      channelId: Value(channelId),
      sortOrder: Value(sortOrder),
      data: Value(data),
    );
  }

  factory CachedSubscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSubscription(
      channelId: serializer.fromJson<int>(json['channelId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<int>(channelId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'data': serializer.toJson<String>(data),
    };
  }

  CachedSubscription copyWith({int? channelId, int? sortOrder, String? data}) =>
      CachedSubscription(
        channelId: channelId ?? this.channelId,
        sortOrder: sortOrder ?? this.sortOrder,
        data: data ?? this.data,
      );
  CachedSubscription copyWithCompanion(CachedSubscriptionsCompanion data) {
    return CachedSubscription(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSubscription(')
          ..write('channelId: $channelId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(channelId, sortOrder, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSubscription &&
          other.channelId == this.channelId &&
          other.sortOrder == this.sortOrder &&
          other.data == this.data);
}

class CachedSubscriptionsCompanion extends UpdateCompanion<CachedSubscription> {
  final Value<int> channelId;
  final Value<int> sortOrder;
  final Value<String> data;
  const CachedSubscriptionsCompanion({
    this.channelId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.data = const Value.absent(),
  });
  CachedSubscriptionsCompanion.insert({
    this.channelId = const Value.absent(),
    required int sortOrder,
    required String data,
  }) : sortOrder = Value(sortOrder),
       data = Value(data);
  static Insertable<CachedSubscription> custom({
    Expression<int>? channelId,
    Expression<int>? sortOrder,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (data != null) 'data': data,
    });
  }

  CachedSubscriptionsCompanion copyWith({
    Value<int>? channelId,
    Value<int>? sortOrder,
    Value<String>? data,
  }) {
    return CachedSubscriptionsCompanion(
      channelId: channelId ?? this.channelId,
      sortOrder: sortOrder ?? this.sortOrder,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSubscriptionsCompanion(')
          ..write('channelId: $channelId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedFeedsTable cachedFeeds = $CachedFeedsTable(this);
  late final $CachedEpisodesTable cachedEpisodes = $CachedEpisodesTable(this);
  late final $CachedFeedEntriesTable cachedFeedEntries =
      $CachedFeedEntriesTable(this);
  late final $CachedSubscriptionsTable cachedSubscriptions =
      $CachedSubscriptionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedFeeds,
    cachedEpisodes,
    cachedFeedEntries,
    cachedSubscriptions,
  ];
}

typedef $$CachedFeedsTableCreateCompanionBuilder =
    CachedFeedsCompanion Function({Value<int> feedKey});
typedef $$CachedFeedsTableUpdateCompanionBuilder =
    CachedFeedsCompanion Function({Value<int> feedKey});

final class $$CachedFeedsTableReferences
    extends BaseReferences<_$AppDatabase, $CachedFeedsTable, CachedFeed> {
  $$CachedFeedsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CachedFeedEntriesTable, List<CachedFeedEntry>>
  _cachedFeedEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cachedFeedEntries,
        aliasName: 'cached_feeds__feed_key__cached_feed_entries__feed_key',
      );

  $$CachedFeedEntriesTableProcessedTableManager get cachedFeedEntriesRefs {
    final manager =
        $$CachedFeedEntriesTableTableManager(
          $_db,
          $_db.cachedFeedEntries,
        ).filter(
          (f) => f.feedKey.feedKey.sqlEquals($_itemColumn<int>('feed_key')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _cachedFeedEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CachedFeedsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFeedsTable> {
  $$CachedFeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get feedKey => $composableBuilder(
    column: $table.feedKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cachedFeedEntriesRefs(
    Expression<bool> Function($$CachedFeedEntriesTableFilterComposer f) f,
  ) {
    final $$CachedFeedEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedKey,
      referencedTable: $db.cachedFeedEntries,
      getReferencedColumn: (t) => t.feedKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFeedEntriesTableFilterComposer(
            $db: $db,
            $table: $db.cachedFeedEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CachedFeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFeedsTable> {
  $$CachedFeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get feedKey => $composableBuilder(
    column: $table.feedKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFeedsTable> {
  $$CachedFeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get feedKey =>
      $composableBuilder(column: $table.feedKey, builder: (column) => column);

  Expression<T> cachedFeedEntriesRefs<T extends Object>(
    Expression<T> Function($$CachedFeedEntriesTableAnnotationComposer a) f,
  ) {
    final $$CachedFeedEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.feedKey,
          referencedTable: $db.cachedFeedEntries,
          getReferencedColumn: (t) => t.feedKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CachedFeedEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.cachedFeedEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CachedFeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFeedsTable,
          CachedFeed,
          $$CachedFeedsTableFilterComposer,
          $$CachedFeedsTableOrderingComposer,
          $$CachedFeedsTableAnnotationComposer,
          $$CachedFeedsTableCreateCompanionBuilder,
          $$CachedFeedsTableUpdateCompanionBuilder,
          (CachedFeed, $$CachedFeedsTableReferences),
          CachedFeed,
          PrefetchHooks Function({bool cachedFeedEntriesRefs})
        > {
  $$CachedFeedsTableTableManager(_$AppDatabase db, $CachedFeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> feedKey = const Value.absent(),
          }) => CachedFeedsCompanion(feedKey: feedKey),
          createCompanionCallback: ({
            Value<int> feedKey = const Value.absent(),
          }) => CachedFeedsCompanion.insert(feedKey: feedKey),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedFeedsTable, CachedFeed>(table),
                  $$CachedFeedsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cachedFeedEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cachedFeedEntriesRefs) db.cachedFeedEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cachedFeedEntriesRefs)
                    await $_getPrefetchedDataByColumns<
                      CachedFeed,
                      $CachedFeedsTable,
                      CachedFeedEntry,
                      $CachedFeedEntriesTable
                    >(
                      currentTable: table,
                      referencedTable: $$CachedFeedsTableReferences
                          ._cachedFeedEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CachedFeedsTableReferences(
                            db,
                            table,
                            p0,
                          ).cachedFeedEntriesRefs,
                      currentColumn: 'feed_key',
                      referencedColumn: 'feed_key',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CachedFeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFeedsTable,
      CachedFeed,
      $$CachedFeedsTableFilterComposer,
      $$CachedFeedsTableOrderingComposer,
      $$CachedFeedsTableAnnotationComposer,
      $$CachedFeedsTableCreateCompanionBuilder,
      $$CachedFeedsTableUpdateCompanionBuilder,
      (CachedFeed, $$CachedFeedsTableReferences),
      CachedFeed,
      PrefetchHooks Function({bool cachedFeedEntriesRefs})
    >;
typedef $$CachedEpisodesTableCreateCompanionBuilder =
    CachedEpisodesCompanion Function({
      Value<int> episodeId,
      required String data,
    });
typedef $$CachedEpisodesTableUpdateCompanionBuilder =
    CachedEpisodesCompanion Function({
      Value<int> episodeId,
      Value<String> data,
    });

final class $$CachedEpisodesTableReferences
    extends BaseReferences<_$AppDatabase, $CachedEpisodesTable, CachedEpisode> {
  $$CachedEpisodesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CachedFeedEntriesTable, List<CachedFeedEntry>>
  _cachedFeedEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cachedFeedEntries,
        aliasName:
            'cached_episodes__episode_id__cached_feed_entries__episode_id',
      );

  $$CachedFeedEntriesTableProcessedTableManager get cachedFeedEntriesRefs {
    final manager =
        $$CachedFeedEntriesTableTableManager(
          $_db,
          $_db.cachedFeedEntries,
        ).filter(
          (f) =>
              f.episodeId.episodeId.sqlEquals($_itemColumn<int>('episode_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _cachedFeedEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CachedEpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedEpisodesTable> {
  $$CachedEpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cachedFeedEntriesRefs(
    Expression<bool> Function($$CachedFeedEntriesTableFilterComposer f) f,
  ) {
    final $$CachedFeedEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.episodeId,
      referencedTable: $db.cachedFeedEntries,
      getReferencedColumn: (t) => t.episodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFeedEntriesTableFilterComposer(
            $db: $db,
            $table: $db.cachedFeedEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CachedEpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedEpisodesTable> {
  $$CachedEpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedEpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedEpisodesTable> {
  $$CachedEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  Expression<T> cachedFeedEntriesRefs<T extends Object>(
    Expression<T> Function($$CachedFeedEntriesTableAnnotationComposer a) f,
  ) {
    final $$CachedFeedEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.episodeId,
          referencedTable: $db.cachedFeedEntries,
          getReferencedColumn: (t) => t.episodeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CachedFeedEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.cachedFeedEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CachedEpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedEpisodesTable,
          CachedEpisode,
          $$CachedEpisodesTableFilterComposer,
          $$CachedEpisodesTableOrderingComposer,
          $$CachedEpisodesTableAnnotationComposer,
          $$CachedEpisodesTableCreateCompanionBuilder,
          $$CachedEpisodesTableUpdateCompanionBuilder,
          (CachedEpisode, $$CachedEpisodesTableReferences),
          CachedEpisode,
          PrefetchHooks Function({bool cachedFeedEntriesRefs})
        > {
  $$CachedEpisodesTableTableManager(
    _$AppDatabase db,
    $CachedEpisodesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedEpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedEpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedEpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> episodeId = const Value.absent(),
            Value<String> data = const Value.absent(),
          }) => CachedEpisodesCompanion(episodeId: episodeId, data: data),
          createCompanionCallback:
              ({
                Value<int> episodeId = const Value.absent(),
                required String data,
              }) => CachedEpisodesCompanion.insert(
                episodeId: episodeId,
                data: data,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedEpisodesTable, CachedEpisode>(table),
                  $$CachedEpisodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cachedFeedEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cachedFeedEntriesRefs) db.cachedFeedEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cachedFeedEntriesRefs)
                    await $_getPrefetchedDataByColumns<
                      CachedEpisode,
                      $CachedEpisodesTable,
                      CachedFeedEntry,
                      $CachedFeedEntriesTable
                    >(
                      currentTable: table,
                      referencedTable: $$CachedEpisodesTableReferences
                          ._cachedFeedEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CachedEpisodesTableReferences(
                            db,
                            table,
                            p0,
                          ).cachedFeedEntriesRefs,
                      currentColumn: 'episode_id',
                      referencedColumn: 'episode_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CachedEpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedEpisodesTable,
      CachedEpisode,
      $$CachedEpisodesTableFilterComposer,
      $$CachedEpisodesTableOrderingComposer,
      $$CachedEpisodesTableAnnotationComposer,
      $$CachedEpisodesTableCreateCompanionBuilder,
      $$CachedEpisodesTableUpdateCompanionBuilder,
      (CachedEpisode, $$CachedEpisodesTableReferences),
      CachedEpisode,
      PrefetchHooks Function({bool cachedFeedEntriesRefs})
    >;
typedef $$CachedFeedEntriesTableCreateCompanionBuilder =
    CachedFeedEntriesCompanion Function({
      required int feedKey,
      required int episodeId,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$CachedFeedEntriesTableUpdateCompanionBuilder =
    CachedFeedEntriesCompanion Function({
      Value<int> feedKey,
      Value<int> episodeId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$CachedFeedEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CachedFeedEntriesTable,
          CachedFeedEntry
        > {
  $$CachedFeedEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CachedFeedsTable _feedKeyTable(_$AppDatabase db) => db.cachedFeeds
      .createAlias('cached_feed_entries__feed_key__cached_feeds__feed_key');

  $$CachedFeedsTableProcessedTableManager get feedKey {
    final $_column = $_itemColumn<int>('feed_key')!;

    final manager = $$CachedFeedsTableTableManager(
      $_db,
      $_db.cachedFeeds,
    ).filter((f) => f.feedKey.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_feedKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CachedEpisodesTable _episodeIdTable(_$AppDatabase db) =>
      db.cachedEpisodes.createAlias(
        'cached_feed_entries__episode_id__cached_episodes__episode_id',
      );

  $$CachedEpisodesTableProcessedTableManager get episodeId {
    final $_column = $_itemColumn<int>('episode_id')!;

    final manager = $$CachedEpisodesTableTableManager(
      $_db,
      $_db.cachedEpisodes,
    ).filter((f) => f.episodeId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_episodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CachedFeedEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFeedEntriesTable> {
  $$CachedFeedEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CachedFeedsTableFilterComposer get feedKey {
    final $$CachedFeedsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedKey,
      referencedTable: $db.cachedFeeds,
      getReferencedColumn: (t) => t.feedKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFeedsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFeeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CachedEpisodesTableFilterComposer get episodeId {
    final $$CachedEpisodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.episodeId,
      referencedTable: $db.cachedEpisodes,
      getReferencedColumn: (t) => t.episodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedEpisodesTableFilterComposer(
            $db: $db,
            $table: $db.cachedEpisodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFeedEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFeedEntriesTable> {
  $$CachedFeedEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CachedFeedsTableOrderingComposer get feedKey {
    final $$CachedFeedsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedKey,
      referencedTable: $db.cachedFeeds,
      getReferencedColumn: (t) => t.feedKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFeedsTableOrderingComposer(
            $db: $db,
            $table: $db.cachedFeeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CachedEpisodesTableOrderingComposer get episodeId {
    final $$CachedEpisodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.episodeId,
      referencedTable: $db.cachedEpisodes,
      getReferencedColumn: (t) => t.episodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedEpisodesTableOrderingComposer(
            $db: $db,
            $table: $db.cachedEpisodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFeedEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFeedEntriesTable> {
  $$CachedFeedEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CachedFeedsTableAnnotationComposer get feedKey {
    final $$CachedFeedsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedKey,
      referencedTable: $db.cachedFeeds,
      getReferencedColumn: (t) => t.feedKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFeedsTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedFeeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CachedEpisodesTableAnnotationComposer get episodeId {
    final $$CachedEpisodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.episodeId,
      referencedTable: $db.cachedEpisodes,
      getReferencedColumn: (t) => t.episodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedEpisodesTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedEpisodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFeedEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFeedEntriesTable,
          CachedFeedEntry,
          $$CachedFeedEntriesTableFilterComposer,
          $$CachedFeedEntriesTableOrderingComposer,
          $$CachedFeedEntriesTableAnnotationComposer,
          $$CachedFeedEntriesTableCreateCompanionBuilder,
          $$CachedFeedEntriesTableUpdateCompanionBuilder,
          (CachedFeedEntry, $$CachedFeedEntriesTableReferences),
          CachedFeedEntry,
          PrefetchHooks Function({bool feedKey, bool episodeId})
        > {
  $$CachedFeedEntriesTableTableManager(
    _$AppDatabase db,
    $CachedFeedEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFeedEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFeedEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFeedEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> feedKey = const Value.absent(),
                Value<int> episodeId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFeedEntriesCompanion(
                feedKey: feedKey,
                episodeId: episodeId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int feedKey,
                required int episodeId,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CachedFeedEntriesCompanion.insert(
                feedKey: feedKey,
                episodeId: episodeId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedFeedEntriesTable, CachedFeedEntry>(table),
                  $$CachedFeedEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({feedKey = false, episodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (feedKey) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.feedKey,
                        referencedTable: $$CachedFeedEntriesTableReferences
                            ._feedKeyTable(db),
                        referencedColumn: $$CachedFeedEntriesTableReferences
                            ._feedKeyTable(db)
                            .feedKey,
                      ) as T;
                    }
                    if (episodeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.episodeId,
                        referencedTable: $$CachedFeedEntriesTableReferences
                            ._episodeIdTable(db),
                        referencedColumn: $$CachedFeedEntriesTableReferences
                            ._episodeIdTable(db)
                            .episodeId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CachedFeedEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFeedEntriesTable,
      CachedFeedEntry,
      $$CachedFeedEntriesTableFilterComposer,
      $$CachedFeedEntriesTableOrderingComposer,
      $$CachedFeedEntriesTableAnnotationComposer,
      $$CachedFeedEntriesTableCreateCompanionBuilder,
      $$CachedFeedEntriesTableUpdateCompanionBuilder,
      (CachedFeedEntry, $$CachedFeedEntriesTableReferences),
      CachedFeedEntry,
      PrefetchHooks Function({bool feedKey, bool episodeId})
    >;
typedef $$CachedSubscriptionsTableCreateCompanionBuilder =
    CachedSubscriptionsCompanion Function({
      Value<int> channelId,
      required int sortOrder,
      required String data,
    });
typedef $$CachedSubscriptionsTableUpdateCompanionBuilder =
    CachedSubscriptionsCompanion Function({
      Value<int> channelId,
      Value<int> sortOrder,
      Value<String> data,
    });

class $$CachedSubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSubscriptionsTable> {
  $$CachedSubscriptionsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSubscriptionsTable> {
  $$CachedSubscriptionsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSubscriptionsTable> {
  $$CachedSubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$CachedSubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSubscriptionsTable,
          CachedSubscription,
          $$CachedSubscriptionsTableFilterComposer,
          $$CachedSubscriptionsTableOrderingComposer,
          $$CachedSubscriptionsTableAnnotationComposer,
          $$CachedSubscriptionsTableCreateCompanionBuilder,
          $$CachedSubscriptionsTableUpdateCompanionBuilder,
          (
            CachedSubscription,
            BaseReferences<
              _$AppDatabase,
              $CachedSubscriptionsTable,
              CachedSubscription
            >,
          ),
          CachedSubscription,
          PrefetchHooks Function()
        > {
  $$CachedSubscriptionsTableTableManager(
    _$AppDatabase db,
    $CachedSubscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSubscriptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedSubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> channelId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> data = const Value.absent(),
              }) => CachedSubscriptionsCompanion(
                channelId: channelId,
                sortOrder: sortOrder,
                data: data,
              ),
          createCompanionCallback:
              ({
                Value<int> channelId = const Value.absent(),
                required int sortOrder,
                required String data,
              }) => CachedSubscriptionsCompanion.insert(
                channelId: channelId,
                sortOrder: sortOrder,
                data: data,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedSubscriptionsTable, CachedSubscription>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedSubscriptionsTable,
                    CachedSubscription
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSubscriptionsTable,
      CachedSubscription,
      $$CachedSubscriptionsTableFilterComposer,
      $$CachedSubscriptionsTableOrderingComposer,
      $$CachedSubscriptionsTableAnnotationComposer,
      $$CachedSubscriptionsTableCreateCompanionBuilder,
      $$CachedSubscriptionsTableUpdateCompanionBuilder,
      (
        CachedSubscription,
        BaseReferences<
          _$AppDatabase,
          $CachedSubscriptionsTable,
          CachedSubscription
        >,
      ),
      CachedSubscription,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedFeedsTableTableManager get cachedFeeds =>
      $$CachedFeedsTableTableManager(_db, _db.cachedFeeds);
  $$CachedEpisodesTableTableManager get cachedEpisodes =>
      $$CachedEpisodesTableTableManager(_db, _db.cachedEpisodes);
  $$CachedFeedEntriesTableTableManager get cachedFeedEntries =>
      $$CachedFeedEntriesTableTableManager(_db, _db.cachedFeedEntries);
  $$CachedSubscriptionsTableTableManager get cachedSubscriptions =>
      $$CachedSubscriptionsTableTableManager(_db, _db.cachedSubscriptions);
}
