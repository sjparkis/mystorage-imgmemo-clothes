import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoiceSearchService {
  final _stt = SpeechToText();
  bool _initialized = false;

  Future<bool> init() async {
    if (kIsWeb) return false;
    _initialized = await _stt.initialize(onError: (_) {});
    return _initialized;
  }

  Future<String?> listen() async {
    if (!_initialized) {
      if (!await init()) return null;
    }
    final completer = Completer<String?>();
    await _stt.listen(
      onResult: (r) {
        if (r.finalResult && !completer.isCompleted) {
          completer.complete(r.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 10),
      localeId: 'ko_KR',
    );
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => null,
    );
  }

  void stop() => _stt.stop();

  void dispose() {
    _stt.cancel();
  }

  Future<Map<String, dynamic>> parseQuery(String text) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'parse-voice-query',
        body: {'query': text},
      );
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return {'filters': {}};
    }
  }
}
