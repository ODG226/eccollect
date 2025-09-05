import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/waste_point.dart';
import '../models/collection_event.dart';
import '../models/tip.dart';

class DataService {
  DataService._();
  static final instance = DataService._();

  List<WastePoint> wastePointsList = [];
  List<CollectionEvent> collectionEventsList = [];
  List<Tip> tipsList = [];

  Future<void> loadAll() async {
    final wpJson = await rootBundle.loadString('assets/data/waste_points.json');
    final ceJson = await rootBundle.loadString('assets/data/collection_events.json');
    final tipsJson = await rootBundle.loadString('assets/data/tips.json');

    final wpList = (json.decode(wpJson) as List).cast<Map<String, dynamic>>();
    final ceList = (json.decode(ceJson) as List).cast<Map<String, dynamic>>();
    final tList = (json.decode(tipsJson) as List).cast<Map<String, dynamic>>();

    wastePointsList = wpList.map((m) => WastePoint.fromMap(m)).toList();
    collectionEventsList = ceList.map((m) => CollectionEvent.fromMap(m)).toList()..sort((a,b)=>a.date.compareTo(b.date));
    tipsList = tList.map((m) => Tip.fromMap(m)).toList();
  }
}
