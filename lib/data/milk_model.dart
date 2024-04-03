
import 'package:baby_tracker/data/milk_fields.dart';

class MilkModel {
  late final int? id;
  final String type;
  final DateTime takenDate;
  final int? quantity;
  final DateTime? createdTime;

  MilkModel({
    this.id,
    required this.type,
    required this.takenDate,
    this.quantity,
    this.createdTime,
  });

  Map<String, Object?> toJson() => {
    MilkFields.id: id,
    MilkFields.type: type,
    MilkFields.takenDate: takenDate.toIso8601String(),
    MilkFields.quantity: quantity,
    MilkFields.createdTime: createdTime?.toIso8601String(),
  };
  
  factory MilkModel.fromJson(Map<String, Object?> json) => MilkModel(
      id: json[MilkFields.id] as int?,
      type: json[MilkFields.type] as String, 
      takenDate: DateTime.parse(json[MilkFields.takenDate] as String? ?? ''),
      quantity: json[MilkFields.quantity] as int?,
      createdTime: DateTime.tryParse(json[MilkFields.createdTime] as String? ?? ''),
  );

  MilkModel copy({
    int? id,
    String? type,
    DateTime? takenDate,
    int? quantity,
    DateTime? createdTime,
  }) => MilkModel(
      id: id ?? this.id,
      type: type ?? this.type,
      takenDate: takenDate ?? this.takenDate,
      quantity: quantity ?? this.quantity,
      createdTime: createdTime ?? this.createdTime,
  );
}