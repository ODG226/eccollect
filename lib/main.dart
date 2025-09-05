import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/theme/app_theme.dart';
import 'src/router/app_router.dart';
import 'src/services/local_data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialisation Firebase
//  await Firebase.initializeApp();

  await DataService.instance.loadAll();

  runApp(const EcoCollectApp());
}

class EcoCollectApp extends StatefulWidget {
  const EcoCollectApp({super.key});

  @override
  State<EcoCollectApp> createState() => _EcoCollectAppState();
}

class _EcoCollectAppState extends State<EcoCollectApp> {
  ThemeMode _mode = ThemeMode.system;
  final _router = AppRouter();

  @override
  void initState() {
    super.initState();
  _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'system';
    setState(() {
      _mode = theme == 'dark'
          ? ThemeMode.dark
          : theme == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EcoCollect',
      themeMode: _mode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerDelegate: _router,           
      routeInformationParser: _router,   
      debugShowCheckedModeBanner: false,
    );
  }
}
