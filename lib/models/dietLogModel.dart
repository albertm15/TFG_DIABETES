import 'package:uuid/uuid.dart';

class DietLogModel {
  String id;
  String userId;
  double totalInsulinUnits;
  int totalCarbs;
  String time;
  String date;

  factory DietLogModel.newEntity(String userId, double totalInsulinUnits,
      int totalCarbs, String time, String date) {
    return DietLogModel.withId(
        Uuid().v4(), userId, totalInsulinUnits, totalCarbs, time, date);
  }

  DietLogModel.withId(this.id, this.userId, this.totalInsulinUnits,
      this.totalCarbs, this.time, this.date);

  factory DietLogModel.fromMap(Map<String, dynamic> map) {
    return DietLogModel.withId(
      map["id"],
      map["userId"],
      map["totalInsulinUnits"],
      map["totalCarbs"],
      map["time"],
      map["date"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "totalInsulinUnits": this.totalInsulinUnits,
      "totalCarbs": this.totalCarbs,
      "time": this.time,
      "date": this.date
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, totalInsulinUnits: $totalInsulinUnits, totalCarbs: $totalCarbs, time: $time, date: $date)";
  }
}
