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

    return Scaffold(
      appBar: 
      AppBar(
        title: const Text('Tableau de bord'),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.green[700],
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
