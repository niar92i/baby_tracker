
class MilkFields {
  static const String tableName = 'dates';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER';
  static const String id = '_id';
  static const String type = 'type';
  static const String takenDate = 'takenDate';
  static const String quantity = 'quantity';
  static const String createdTime = 'created_time';
  static const List<String> values = [
    id,
    type,
    takenDate,
    quantity,
    createdTime,
  ];
}