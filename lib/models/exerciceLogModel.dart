import 'package:diabetes_tfg_app/auxiliarResources/exerciceCategoryEnum.dart';
import 'package:uuid/uuid.dart';

class ExerciceLogModel {
  String id;
  String userId;
  String category;
  String duration;
  String beforeSensations;
  String afterSensations;
  String date;
  String time;

  factory ExerciceLogModel.newEntity(
      String userId,
      String category,
      String duration,
      String beforeSensations,
      String afterSensations,
      String date,
      String time) {
    return ExerciceLogModel.withId(Uuid().v4(), userId, category, duration,
        beforeSensations, afterSensations, date, time);
  }

  ExerciceLogModel.withId(this.id, this.userId, this.category, this.duration,
      this.beforeSensations, this.afterSensations, this.date, this.time);

  factory ExerciceLogModel.fromMap(Map<String, dynamic> map) {
    return ExerciceLogModel.withId(
      map["id"],
      map["userId"],
      map["category"],
      map["duration"],
      map["beforeSensations"],
      map["afterSensations"],
      map["date"],
      map["time"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "category": this.category,
      "duration": this.duration,
      "beforeSensations": this.beforeSensations,
      "afterSensations": this.afterSensations,
      "date": this.date,
      "time": this.time,
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, category: $category, duration: $duration, beforeSensations: $beforeSensations, afterSensations: $afterSensations, date: $date, time: $time)";
  }
}
