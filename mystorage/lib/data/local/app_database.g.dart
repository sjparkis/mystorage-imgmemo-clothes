// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalStoragesTable extends LocalStorages
    with TableInfo<$LocalStoragesTable, LocalStorage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStoragesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    name,
    photoUrl,
    qrCode,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_storages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStorage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_qrCodeMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStorage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStorage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $LocalStoragesTable createAlias(String alias) {
    return $LocalStoragesTable(attachedDatabase, alias);
  }
}

class LocalStorage extends DataClass implements Insertable<LocalStorage> {
  final String id;
  final String orgId;
  final String name;
  final String? photoUrl;
  final String qrCode;
  final DateTime cachedAt;
  const LocalStorage({
    required this.id,
    required this.orgId,
    required this.name,
    this.photoUrl,
    required this.qrCode,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['qr_code'] = Variable<String>(qrCode);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  LocalStoragesCompanion toCompanion(bool nullToAbsent) {
    return LocalStoragesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      name: Value(name),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      qrCode: Value(qrCode),
      cachedAt: Value(cachedAt),
    );
  }

  factory LocalStorage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStorage(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      name: serializer.fromJson<String>(json['name']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      qrCode: serializer.fromJson<String>(json['qrCode']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'name': serializer.toJson<String>(name),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'qrCode': serializer.toJson<String>(qrCode),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  LocalStorage copyWith({
    String? id,
    String? orgId,
    String? name,
    Value<String?> photoUrl = const Value.absent(),
    String? qrCode,
    DateTime? cachedAt,
  }) => LocalStorage(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    name: name ?? this.name,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    qrCode: qrCode ?? this.qrCode,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  LocalStorage copyWithCompanion(LocalStoragesCompanion data) {
    return LocalStorage(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      name: data.name.present ? data.name.value : this.name,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStorage(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('qrCode: $qrCode, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orgId, name, photoUrl, qrCode, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStorage &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.name == this.name &&
          other.photoUrl == this.photoUrl &&
          other.qrCode == this.qrCode &&
          other.cachedAt == this.cachedAt);
}

class LocalStoragesCompanion extends UpdateCompanion<LocalStorage> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String> name;
  final Value<String?> photoUrl;
  final Value<String> qrCode;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const LocalStoragesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.name = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStoragesCompanion.insert({
    required String id,
    required String orgId,
    required String name,
    this.photoUrl = const Value.absent(),
    required String qrCode,
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId),
       name = Value(name),
       qrCode = Value(qrCode);
  static Insertable<LocalStorage> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? name,
    Expression<String>? photoUrl,
    Expression<String>? qrCode,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (name != null) 'name': name,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (qrCode != null) 'qr_code': qrCode,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStoragesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String>? name,
    Value<String?>? photoUrl,
    Value<String>? qrCode,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return LocalStoragesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      qrCode: qrCode ?? this.qrCode,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStoragesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('name: $name, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('qrCode: $qrCode, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalClothesTable extends LocalClothes
    with TableInfo<$LocalClothesTable, LocalClothe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalClothesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storageIdMeta = const VerificationMeta(
    'storageId',
  );
  @override
  late final GeneratedColumn<String> storageId = GeneratedColumn<String>(
    'storage_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgId,
    storageId,
    photoUrl,
    name,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_clothes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalClothe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('storage_id')) {
      context.handle(
        _storageIdMeta,
        storageId.isAcceptableOrUnknown(data['storage_id']!, _storageIdMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalClothe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalClothe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      storageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_id'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $LocalClothesTable createAlias(String alias) {
    return $LocalClothesTable(attachedDatabase, alias);
  }
}

class LocalClothe extends DataClass implements Insertable<LocalClothe> {
  final String id;
  final String orgId;
  final String? storageId;
  final String? photoUrl;
  final String? name;
  final DateTime cachedAt;
  const LocalClothe({
    required this.id,
    required this.orgId,
    this.storageId,
    this.photoUrl,
    this.name,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_id'] = Variable<String>(orgId);
    if (!nullToAbsent || storageId != null) {
      map['storage_id'] = Variable<String>(storageId);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  LocalClothesCompanion toCompanion(bool nullToAbsent) {
    return LocalClothesCompanion(
      id: Value(id),
      orgId: Value(orgId),
      storageId: storageId == null && nullToAbsent
          ? const Value.absent()
          : Value(storageId),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      cachedAt: Value(cachedAt),
    );
  }

  factory LocalClothe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalClothe(
      id: serializer.fromJson<String>(json['id']),
      orgId: serializer.fromJson<String>(json['orgId']),
      storageId: serializer.fromJson<String?>(json['storageId']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      name: serializer.fromJson<String?>(json['name']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgId': serializer.toJson<String>(orgId),
      'storageId': serializer.toJson<String?>(storageId),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'name': serializer.toJson<String?>(name),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  LocalClothe copyWith({
    String? id,
    String? orgId,
    Value<String?> storageId = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    Value<String?> name = const Value.absent(),
    DateTime? cachedAt,
  }) => LocalClothe(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    storageId: storageId.present ? storageId.value : this.storageId,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    name: name.present ? name.value : this.name,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  LocalClothe copyWithCompanion(LocalClothesCompanion data) {
    return LocalClothe(
      id: data.id.present ? data.id.value : this.id,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      storageId: data.storageId.present ? data.storageId.value : this.storageId,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      name: data.name.present ? data.name.value : this.name,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalClothe(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('storageId: $storageId, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('name: $name, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orgId, storageId, photoUrl, name, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalClothe &&
          other.id == this.id &&
          other.orgId == this.orgId &&
          other.storageId == this.storageId &&
          other.photoUrl == this.photoUrl &&
          other.name == this.name &&
          other.cachedAt == this.cachedAt);
}

class LocalClothesCompanion extends UpdateCompanion<LocalClothe> {
  final Value<String> id;
  final Value<String> orgId;
  final Value<String?> storageId;
  final Value<String?> photoUrl;
  final Value<String?> name;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const LocalClothesCompanion({
    this.id = const Value.absent(),
    this.orgId = const Value.absent(),
    this.storageId = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.name = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalClothesCompanion.insert({
    required String id,
    required String orgId,
    this.storageId = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.name = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgId = Value(orgId);
  static Insertable<LocalClothe> custom({
    Expression<String>? id,
    Expression<String>? orgId,
    Expression<String>? storageId,
    Expression<String>? photoUrl,
    Expression<String>? name,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgId != null) 'org_id': orgId,
      if (storageId != null) 'storage_id': storageId,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (name != null) 'name': name,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalClothesCompanion copyWith({
    Value<String>? id,
    Value<String>? orgId,
    Value<String?>? storageId,
    Value<String?>? photoUrl,
    Value<String?>? name,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return LocalClothesCompanion(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      storageId: storageId ?? this.storageId,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (storageId.present) {
      map['storage_id'] = Variable<String>(storageId.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalClothesCompanion(')
          ..write('id: $id, ')
          ..write('orgId: $orgId, ')
          ..write('storageId: $storageId, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('name: $name, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
    'table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    table,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('table')) {
      context.handle(
        _tableMeta,
        table.isAcceptableOrUnknown(data['table']!, _tableMeta),
      );
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      table: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final int id;
  final String operation;
  final String table;
  final String payload;
  final DateTime createdAt;
  const SyncQueueItem({
    required this.id,
    required this.operation,
    required this.table,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['table'] = Variable<String>(table);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      operation: Value(operation),
      table: Value(table),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      table: serializer.fromJson<String>(json['table']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'table': serializer.toJson<String>(table),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueItem copyWith({
    int? id,
    String? operation,
    String? table,
    String? payload,
    DateTime? createdAt,
  }) => SyncQueueItem(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    table: table ?? this.table,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      table: data.table.present ? data.table.value : this.table,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('table: $table, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operation, table, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.table == this.table &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> table;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.table = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String table,
    required String payload,
    this.createdAt = const Value.absent(),
  }) : operation = Value(operation),
       table = Value(table),
       payload = Value(payload);
  static Insertable<SyncQueueItem> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? table,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (table != null) 'table': table,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? operation,
    Value<String>? table,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      table: table ?? this.table,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (table.present) {
      map['table'] = Variable<String>(table.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('table: $table, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalStoragesTable localStorages = $LocalStoragesTable(this);
  late final $LocalClothesTable localClothes = $LocalClothesTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localStorages,
    localClothes,
    syncQueueItems,
  ];
}

typedef $$LocalStoragesTableCreateCompanionBuilder =
    LocalStoragesCompanion Function({
      required String id,
      required String orgId,
      required String name,
      Value<String?> photoUrl,
      required String qrCode,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$LocalStoragesTableUpdateCompanionBuilder =
    LocalStoragesCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<String> name,
      Value<String?> photoUrl,
      Value<String> qrCode,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$LocalStoragesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStoragesTable> {
  $$LocalStoragesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStoragesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStoragesTable> {
  $$LocalStoragesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStoragesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStoragesTable> {
  $$LocalStoragesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$LocalStoragesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStoragesTable,
          LocalStorage,
          $$LocalStoragesTableFilterComposer,
          $$LocalStoragesTableOrderingComposer,
          $$LocalStoragesTableAnnotationComposer,
          $$LocalStoragesTableCreateCompanionBuilder,
          $$LocalStoragesTableUpdateCompanionBuilder,
          (
            LocalStorage,
            BaseReferences<_$AppDatabase, $LocalStoragesTable, LocalStorage>,
          ),
          LocalStorage,
          PrefetchHooks Function()
        > {
  $$LocalStoragesTableTableManager(_$AppDatabase db, $LocalStoragesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStoragesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStoragesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStoragesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> qrCode = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStoragesCompanion(
                id: id,
                orgId: orgId,
                name: name,
                photoUrl: photoUrl,
                qrCode: qrCode,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                required String name,
                Value<String?> photoUrl = const Value.absent(),
                required String qrCode,
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStoragesCompanion.insert(
                id: id,
                orgId: orgId,
                name: name,
                photoUrl: photoUrl,
                qrCode: qrCode,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalStoragesTable, LocalStorage>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalStoragesTable,
                    LocalStorage
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStoragesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStoragesTable,
      LocalStorage,
      $$LocalStoragesTableFilterComposer,
      $$LocalStoragesTableOrderingComposer,
      $$LocalStoragesTableAnnotationComposer,
      $$LocalStoragesTableCreateCompanionBuilder,
      $$LocalStoragesTableUpdateCompanionBuilder,
      (
        LocalStorage,
        BaseReferences<_$AppDatabase, $LocalStoragesTable, LocalStorage>,
      ),
      LocalStorage,
      PrefetchHooks Function()
    >;
typedef $$LocalClothesTableCreateCompanionBuilder =
    LocalClothesCompanion Function({
      required String id,
      required String orgId,
      Value<String?> storageId,
      Value<String?> photoUrl,
      Value<String?> name,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$LocalClothesTableUpdateCompanionBuilder =
    LocalClothesCompanion Function({
      Value<String> id,
      Value<String> orgId,
      Value<String?> storageId,
      Value<String?> photoUrl,
      Value<String?> name,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$LocalClothesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalClothesTable> {
  $$LocalClothesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageId => $composableBuilder(
    column: $table.storageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalClothesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalClothesTable> {
  $$LocalClothesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageId => $composableBuilder(
    column: $table.storageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalClothesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalClothesTable> {
  $$LocalClothesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<String> get storageId =>
      $composableBuilder(column: $table.storageId, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$LocalClothesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalClothesTable,
          LocalClothe,
          $$LocalClothesTableFilterComposer,
          $$LocalClothesTableOrderingComposer,
          $$LocalClothesTableAnnotationComposer,
          $$LocalClothesTableCreateCompanionBuilder,
          $$LocalClothesTableUpdateCompanionBuilder,
          (
            LocalClothe,
            BaseReferences<_$AppDatabase, $LocalClothesTable, LocalClothe>,
          ),
          LocalClothe,
          PrefetchHooks Function()
        > {
  $$LocalClothesTableTableManager(_$AppDatabase db, $LocalClothesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalClothesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalClothesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalClothesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<String?> storageId = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalClothesCompanion(
                id: id,
                orgId: orgId,
                storageId: storageId,
                photoUrl: photoUrl,
                name: name,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgId,
                Value<String?> storageId = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalClothesCompanion.insert(
                id: id,
                orgId: orgId,
                storageId: storageId,
                photoUrl: photoUrl,
                name: name,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalClothesTable, LocalClothe>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalClothesTable,
                    LocalClothe
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalClothesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalClothesTable,
      LocalClothe,
      $$LocalClothesTableFilterComposer,
      $$LocalClothesTableOrderingComposer,
      $$LocalClothesTableAnnotationComposer,
      $$LocalClothesTableCreateCompanionBuilder,
      $$LocalClothesTableUpdateCompanionBuilder,
      (
        LocalClothe,
        BaseReferences<_$AppDatabase, $LocalClothesTable, LocalClothe>,
      ),
      LocalClothe,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      required String operation,
      required String table,
      required String payload,
      Value<DateTime> createdAt,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      Value<String> operation,
      Value<String> table,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$AppDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> table = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                operation: operation,
                table: table,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operation,
                required String table,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                operation: operation,
                table: table,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueItemsTable, SyncQueueItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncQueueItemsTable,
                    SyncQueueItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalStoragesTableTableManager get localStorages =>
      $$LocalStoragesTableTableManager(_db, _db.localStorages);
  $$LocalClothesTableTableManager get localClothes =>
      $$LocalClothesTableTableManager(_db, _db.localClothes);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
}
