import 'package:ecocollect/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../services/local_data_service.dart';
import '../widgets/quick_tile.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final delegate = context.routerDelegate;
    final events = DataService.instance.collectionEventsList;
    final next = events.where((e) => e.date.isAfter(DateTime.now())).toList();
    final txt = next.isEmpty ? "Aucune collecte à venir" : "Prochain passage: ${next.first.wasteType} • ${next.first.date}";

    void logout() async 
    {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          TextButton(onPressed: () async 
          {
            Navigator.of(context).pop();
            await AuthService.instance.signOut();
            delegate.go(AppRoute.onboardingLogin);
          }, child: const Text('Déconnexion')),
        ],
      ));
    }

    return Scaffold(
      appBar: 
      AppBar(
        leading: Container(),
        title: const Text('Tableau de bord'),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            tooltip: 'Déconnexion',
            onPressed: () {logout();})
            ],
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SectionCard(
                title: 'Prochain passage',
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text(txt)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  QuickTile(icon: Icons.calendar_month, label: 'Calendrier', onTap: () => delegate.go(AppRoute.calendar)),
                  QuickTile(icon: Icons.tips_and_updates, label: 'Conseils', onTap: () => delegate.go(AppRoute.tips)),
                  QuickTile(icon: Icons.map_outlined, label: 'Carte', onTap: () => delegate.go(AppRoute.map)),
                  QuickTile(icon: Icons.person_outline, label: 'Profil', onTap: () => delegate.go(AppRoute.profile)),
                ],
              ),
              const SizedBox(height: 12),
              const SectionCard(
                title: 'Notifications du jour',
                child: Column(
                  children: [
                    ListTile(leading: Icon(Icons.check_circle_outline), title: Text("Pensez à sortir le plastique ce soir.")),
                    ListTile(leading: Icon(Icons.check_circle_outline), title: Text("Point de tri mobile demain au marché central.")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}