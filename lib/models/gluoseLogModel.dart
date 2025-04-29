import 'package:uuid/uuid.dart';

class GlucoseLogModel {
  String id;
  String userId;
  int glucoseValue;
  String date;
  String time;
  String category;
  bool hyperglucemia;
  bool hypoglucemia;
  String sensations;

  /*GlucoseLogModel(this.userId, this.glucoseValue, this.date, this.time,
      this.category, this.hyperglucemia, this.hypoglucemia, this.sensations);*/

  factory GlucoseLogModel.newEntity(
      String userId,
      int glucoseValue,
      String date,
      String time,
      String category,
      bool hyperglucemia,
      bool hypoglucemia,
      String sensations) {
    return GlucoseLogModel.withId(Uuid().v4(), userId, glucoseValue, date, time,
        category, hyperglucemia, hypoglucemia, sensations);
  }

  GlucoseLogModel.withId(
      this.id,
      this.userId,
      this.glucoseValue,
      this.date,
      this.time,
      this.category,
      this.hyperglucemia,
      this.hypoglucemia,
      this.sensations);

  factory GlucoseLogModel.fromMap(Map<String, dynamic> map) {
    return GlucoseLogModel.withId(
      map["id"],
      map["userId"],
      map["glucoseValue"],
      map["date"],
      map["time"],
      map["category"],
      map["hyperglucemia"] == 1,
      map["hypoglucemia"] == 1,
      map["sensations"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "glucoseValue": this.glucoseValue,
      "date": this.date,
      "time": this.time,
      "category": this.category,
      "hyperglucemia": this.hyperglucemia ? 1 : 0,
      "hypoglucemia": this.hypoglucemia ? 1 : 0,
      "sensations": this.sensations
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, glucoseValue: $glucoseValue, date: $date, time: $time, category: $category, hyperglucemia: $hyperglucemia, hypoglucemia: $hypoglucemia, sensations: $sensations)";
  }
}
