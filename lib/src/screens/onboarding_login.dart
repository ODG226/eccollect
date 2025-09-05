import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
// import '../router/app_router.dart'; // si tu utilises ton routeur custom
import 'dashboard_screen.dart'; // crée un écran placeholder si besoin

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});
  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  final _name  = TextEditingController(); // pour l'inscription
  bool _loginMode = true;
  bool _busy = false;
  String? _error;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final _images = const [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _images.length;
        _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _email.dispose();
    _pass.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _busy = true; _error = null; });
    try {
      if (_loginMode) {
        await AuthService.instance.signIn(email: _email.text.trim(), password: _pass.text);
      } else {
        if (_name.text.trim().isEmpty) {
          throw FirebaseAuthException(code: 'empty-name', message: 'Nom requis');
        }
        await AuthService.instance.signUp(
          email: _email.text.trim(),
          password: _pass.text,
          displayName: _name.text.trim(),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
      // OU si tu utilises ton routeur custom:
      // context.routerDelegate.go(AppRoute.dashboard);
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message ?? 'Erreur de connexion'; });
    } catch (e) {
      setState(() { _error = 'Erreur: $e'; });
    } finally {
      if (mounted) setState(() { _busy = false; });
    }
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty) {
      setState(() => _error = 'Entrez votre email pour réinitialiser.');
      return;
    }
    try {
      await AuthService.instance.resetPassword(_email.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email envoyé.')));
    } catch (e) {
      setState(() => _error = 'Impossible d’envoyer l’email.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) => Image.asset(_images[i], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_images.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 8,
                    width: i == _currentPage ? 32 : 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: i == _currentPage ? Theme.of(context).colorScheme.primary
                                               : Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  )),
                ),
                const SizedBox(height: 18),
                if (!_loginMode)
                  TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nom complet')),
                const SizedBox(height: 12),
                TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_loginMode ? 'Se connecter' : "Créer un compte"),
                ),
                TextButton(
                  onPressed: () => setState(() => _loginMode = !_loginMode),
                  child: Text(_loginMode ? "Créer un compte" : "J'ai déjà un compte"),
                ),
                if (_loginMode)
                  TextButton(onPressed: _resetPassword, child: const Text("Mot de passe oublié ?")),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
                    // OU routeur custom: context.routerDelegate.go(AppRoute.dashboard);
                  },
                  child: const Text("Continuer sans compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
