class CollectionEvent {
  final String id;
  final DateTime date;
  final String wasteType;
  final String quarter;  
  final String notes;

  CollectionEvent({
    required this.id,
    required this.date,
    required this.wasteType,
    required this.quarter,
    required this.notes,
  });

  factory CollectionEvent.fromMap(Map<String, dynamic> m) => CollectionEvent(
    id: m['id'] ?? '',
    date: DateTime.parse(m['date']),
    wasteType: m['wasteType'] ?? 'Plastique',
    quarter: m['quarter'] ?? '',
    notes: m['notes'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'wasteType': wasteType,
    'quarter': quarter,
    'notes': notes,
  };
}
