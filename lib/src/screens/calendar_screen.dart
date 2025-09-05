import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/local_data_service.dart';
import '../models/collection_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final events = DataService.instance.collectionEventsList;
    Map<DateTime, List<CollectionEvent>> map = {};
    for (final e in events) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(day, () => []).add(e);
    }
    List<dynamic> getEventsForDay(DateTime day) => map[DateTime(day.year, day.month, day.day)] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier de collecte'),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.green[700],
        ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023,1,1),
            lastDay: DateTime.utc(2030,12,31),
            focusedDay: _focused,
            selectedDayPredicate: (d) => isSameDay(d, _selected),
            eventLoader: (day) => getEventsForDay(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selected = selectedDay;
                _focused = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              markersAutoAligned: true,
              markerDecoration: BoxDecoration(shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                for (final e in getEventsForDay(_selected ?? DateTime.now()))
                  ListTile(
                    leading: const Icon(Icons.recycling),
                    title: Text(e.wasteType),
                    subtitle: Text(e.notes),
                    trailing: Text("${e.date.hour.toString().padLeft(2,'0')}:${e.date.minute.toString().padLeft(2,'0')}"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rappel ajouté !')));
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
