import 'package:flutter/material.dart';
import '../../services/voice_search_service.dart';

class VoiceSearchButton extends StatefulWidget {
  final void Function(String query, Map<String, dynamic> filters) onResult;
  const VoiceSearchButton({super.key, required this.onResult});
  @override
  State<VoiceSearchButton> createState() => _VoiceSearchButtonState();
}

class _VoiceSearchButtonState extends State<VoiceSearchButton> {
  final _service = VoiceSearchService();
  bool _listening = false;

  @override
  void dispose() {
    _service.stop();
    _service.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _listening = true);
    try {
      final text = await _service.listen();
      if (text == null || text.isEmpty) return;
      final result = await _service.parseQuery(text);
      final filters = result['filters'] as Map<String, dynamic>? ?? {};
      widget.onResult(text, filters);
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _start(),
      onLongPressEnd: (_) => _service.stop(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _listening
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}
