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
      id: map['id'],
      date: map['date'],
      steps: map['steps'],
      calories: map['calories'],
      water: map['water'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'steps': steps,
      'calories': calories,
      'water': water,
    };
  }
}
