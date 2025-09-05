import 'package:ecocollect/src/router/app_router.dart';
import 'package:flutter/material.dart';
// import 'onboarding_login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  // void _goToLogin() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // PAGE 1 : Logo animé
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.gif", height: 200),
          const SizedBox(height: 20),
          const Text(
            "Bienvenue sur EcoCollect",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Une solution innovante pour la collecte et le tri."),
        ],
      ),

      // PAGE 2 
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/recycling.png", height: 200),
            const SizedBox(height: 20),
            const Text(
              "Qu’est-ce que EcoCollect ?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "EcoCollect est une plateforme qui facilite la collecte, "
              "le tri et la valorisation des déchets.\n\n"
              "Un pas de plus vers un environnement durable 🌍",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      // PAGE 3 
      const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco, size: 150, color: Colors.green),
          SizedBox(height: 20),
          Text(
            "Prêt à commencer ?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text("Cliquez ci-dessous pour démarrer votre aventure."),
          SizedBox(height: 30),
          FilledButton(
            onPressed: null, 
            child: Text("Commencer"),
          )
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        actions: [
          if (_pageIndex != pages.length - 1)
            TextButton(
              onPressed: (){
               context.routerDelegate.go(AppRoute.onboardingLogin);
              },
              child: const Text(
                "Passer",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) =>
                  setState(() => _pageIndex = index),
              itemBuilder: (context, index) {
                if (index == 2) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco, size: 150, color: Colors.green),
                      const SizedBox(height: 20),
                      const Text(
                        "Prêt à commencer ?",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                          "Cliquez ci-dessous pour démarrer votre aventure."),
                      const SizedBox(height: 30),
                      FilledButton(
                        onPressed: (){
                            context.routerDelegate.go(AppRoute.onboardingLogin);
                          },
                        child: const Text("Commencer"),
                      )
                    ],
                  );
                }
                return pages[index];
              },
            ),
          ),

          // Indicateurs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(6),
                height: 10,
                width: _pageIndex == i ? 28 : 12,
                decoration: BoxDecoration(
                  color: _pageIndex == i ? Colors.green : Colors.grey[400],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
