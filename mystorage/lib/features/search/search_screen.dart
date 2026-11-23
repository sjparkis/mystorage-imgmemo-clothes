import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/models/cloth.dart';
import 'voice_search_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = ClothRepository();
  final _queryCtrl = TextEditingController();
  List<Cloth> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final results = await _repo.search(_queryCtrl.text);
      if (mounted) setState(() => _results = results);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _queryCtrl,
              decoration: InputDecoration(
                hintText: '옷 이름이나 태그로 검색',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _search,
                    ),
                    VoiceSearchButton(
                      onResult: (text, filters) {
                        _queryCtrl.text = text;
                        _search();
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final cloth = _results[i];
                return ListTile(
                  leading: cloth.photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cloth.photoUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.checkroom),
                  title: Text(cloth.name ?? '이름 없음'),
                  subtitle: Text(cloth.tags.map((t) => t.name).join(', ')),
                  onTap: () => context.push('/cloth/${cloth.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
