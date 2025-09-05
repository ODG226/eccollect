import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _quarter = TextEditingController();
  bool _notif = true;
  String _theme = 'system';
  String? _email;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name.text = prefs.getString('name') ?? '';
      _address.text = prefs.getString('address') ?? '';
      _quarter.text = prefs.getString('quarter') ?? '';
      _notif = prefs.getBool('notif') ?? true;
      _theme = prefs.getString('theme') ?? 'system';
      _email = prefs.getString('email');
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name.text);
    await prefs.setString('address', _address.text);
    await prefs.setString('quarter', _quarter.text);
    await prefs.setBool('notif', _notif);
    await prefs.setString('theme', _theme);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Préférences enregistrées')));
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    setState(() => _email = null);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compte supprimé')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const 
        Text('Profil & Préférences'),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.green[700],
        ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(_email ?? 'Utilisateur'),
            subtitle: Text(_email != null ? 'Connecté' : 'Mode sans compte'),
          ),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nom')),
          const SizedBox(height: 8),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'Adresse')),
          const SizedBox(height: 8),
          TextField(controller: _quarter, decoration: const InputDecoration(labelText: 'Quartier')),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _notif,
            onChanged: (v) => setState(() => _notif = v),
            title: const Text('Notifications'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _theme,
            items: const [
              DropdownMenuItem(value: 'system', child: Text('Thème système')),
              DropdownMenuItem(value: 'light', child: Text('Clair')),
              DropdownMenuItem(value: 'dark', child: Text('Sombre')),
            ],
            onChanged: (v) => setState(() => _theme = v ?? 'system'),
            decoration: const InputDecoration(labelText: 'Thème'),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Enregistrer')),
          const SizedBox(height: 8),
          if (_email != Null) OutlinedButton(onPressed: _logout, child: const Text('Supprimer compte')),
        ],
      ),
    );
  }
}
