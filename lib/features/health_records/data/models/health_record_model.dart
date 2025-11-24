import '../../domain/entities/health_record.dart';

class HealthRecordModel extends HealthRecord {
  HealthRecordModel({
    super.id,
    required super.date,
    required super.steps,
    required super.calories,
    required super.water,
  });

  factory HealthRecordModel.fromMap(Map<String, dynamic> map) {
    return HealthRecordModel(
      id: map['id'] as int?,
      date: map['date'] as String,
      steps: map['steps'] as int,
      calories: map['calories'] as int,
      water: map['water'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'date': date,
      'steps': steps,
      'calories': calories,
      'water': water,
    };

    // Only include id when updating (DB auto-generates id on insert)
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}



