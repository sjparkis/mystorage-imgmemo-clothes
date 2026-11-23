import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app_database.dart';

class SyncQueue {
  final AppDatabase _db;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  SyncQueue(this._db);

  Future<void> enqueue({
    required String operation,
    required String table,
    required Map<String, dynamic> payload,
  }) async {
    await _db.into(_db.syncQueueItems).insert(SyncQueueItemsCompanion.insert(
      operation: operation,
      table: table,
      payload: jsonEncode(payload),
    ));
  }

  void startListening() {
    _subscription?.cancel();
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      if (results.any((r) => r != ConnectivityResult.none)) {
        await _flushQueue();
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _flushQueue() async {
    final items = await (_db.select(_db.syncQueueItems)
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    for (final item in items) {
      try {
        await _db.delete(_db.syncQueueItems).delete(item);
      } catch (e) {
        debugPrint('SyncQueue flush error: $e');
        continue;
      }
    }
  }
}
