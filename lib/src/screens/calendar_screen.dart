import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  List<NeatCleanCalendarEvent> _eventList = [];

  // Every two weeks on Tuesday and Thursday, but only in December.
final rrule = RecurrenceRule(
  frequency: Frequency.weekly,
  interval: 1,
  byWeekDays: [
    ByWeekDayEntry(DateTime.tuesday),
    ByWeekDayEntry(DateTime.thursday),
  ],
);

Iterable<DateTime> get instances => rrule.getInstances(
  start: DateTime.now().copyWith(isUtc: true),
);

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventList=instances.take(10).map( (date) => NeatCleanCalendarEvent(
      'Collecte de déchets',
      startTime: date,
      endTime: date.add(const Duration(hours: 1)),
      description: 'N\'oubliez pas de sortir vos poubelles !',
      color: Colors.green,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {


    _eventList.forEach((e) {
      print("Event: ${e.startTime} - ${e.endTime} : ${e.summary}");
    });
    
    // final events = DataService.instance.collectionEventsList;
    // Map<DateTime, List<CollectionEvent>> map = {};
    // for (final e in events) {
    //   final day = DateTime(e.date.year, e.date.month, e.date.day);
    //   map.putIfAbsent(day, () => []).add(e);
    // }
    // List<dynamic> getEventsForDay(DateTime day) => map[DateTime(day.year, day.month, day.day)] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier de collecte'),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.green[700],
        ),
      body: Column(
        children: [
          Expanded(
            child: Calendar(
                    startOnMonday: true,
                    weekDays: ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'],
                    eventsList: _eventList,
                    isExpandable: true,
                    eventDoneColor: Colors.green,
                    selectedColor: Colors.pink,
                    selectedTodayColor: Colors.red,
                    todayColor: Colors.blue,
                    eventColor: null,
                    locale: 'fr_FR',
                    todayButtonText: 'Aujourd\'hui',
                    allDayEventText: 'Toute la journée',
                    multiDayEndText: 'Fin',
                    isExpanded: true,
                    expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                    datePickerType: DatePickerType.date,
                    dayOfWeekStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
                  ),
          ),
          // TableCalendar(
          //   firstDay: DateTime.utc(2023,1,1),
          //   lastDay: DateTime.utc(2030,12,31),
          //   focusedDay: _focused,
          //   selectedDayPredicate: (d) => isSameDay(d, _selected),
          //   eventLoader: (day) => getEventsForDay(day),
          //   onDaySelected: (selectedDay, focusedDay) {
          //     setState(() {
          //       _selected = selectedDay;
          //       _focused = focusedDay;
          //     });
          //   },
          //   calendarStyle: const CalendarStyle(
          //     markersAutoAligned: true,
          //     markerDecoration: BoxDecoration(shape: BoxShape.circle),
          //   ),
          // ),
          // const SizedBox(height: 8),
          // Expanded(
          //   child: ListView(
          //     children: [
          //       for (final e in getEventsForDay(_selected ?? DateTime.now()))
          //         ListTile(
          //           leading: const Icon(Icons.recycling),
          //           title: Text(e.wasteType),
          //           subtitle: Text(e.notes),
          //           trailing: Text("${e.date.hour.toString().padLeft(2,'0')}:${e.date.minute.toString().padLeft(2,'0')}"),
          //           onTap: () {
          //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rappel ajouté !')));
          //           },
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
