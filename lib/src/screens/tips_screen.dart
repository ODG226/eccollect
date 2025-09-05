import 'package:flutter/material.dart';
import '../services/local_data_service.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = DataService.instance.tipsList;
    final tips = list.where((t) =>
      t.title.toLowerCase().contains(_query) ||
      t.body.toLowerCase().contains(_query) ||
      t.tags.any((tag) => tag.toLowerCase().contains(_query))
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conseils de recyclage'),
        backgroundColor: Colors.green[700],
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher un objet...'),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: tips.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final t = tips[i];
                return ListTile(
                  leading: const Icon(Icons.tips_and_updates_outlined),
                  title: Text(t.title),
                  subtitle: Text(t.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Chip(label: Text(t.category)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
