import 'package:uuid/uuid.dart';

class DietModel {
  String id;
  String userId;
  String breakfastSchedule;
  String snackSchedule;
  String lunchSchedule;
  String afternoonSnackSchedule;
  String dinnerSchedule;

  factory DietModel.newEntity(
      String userId,
      String breakfastSchedule,
      String snackSchedule,
      String lunchSchedule,
      String afternoonSnackSchedule,
      String dinnerSchedule) {
    return DietModel.withId(Uuid().v4(), userId, breakfastSchedule,
        snackSchedule, lunchSchedule, afternoonSnackSchedule, dinnerSchedule);
  }

  DietModel.withId(
      this.id,
      this.userId,
      this.breakfastSchedule,
      this.snackSchedule,
      this.lunchSchedule,
      this.afternoonSnackSchedule,
      this.dinnerSchedule);

  factory DietModel.fromMap(Map<String, dynamic> map) {
    return DietModel.withId(
      map["id"],
      map["userId"],
      map["breakfastSchedule"],
      map["snackSchedule"],
      map["lunchSchedule"],
      map["afternoonSnackSchedule"],
      map["dinnerSchedule"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "breakfastSchedule": this.breakfastSchedule,
      "snackSchedule": this.snackSchedule,
      "lunchSchedule": this.lunchSchedule,
      "afternoonSnackSchedule": this.afternoonSnackSchedule,
      "dinnerSchedule": this.dinnerSchedule
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, breakfastSchedule: $breakfastSchedule, snackSchedule: $snackSchedule, lunchSchedule: $lunchSchedule, afternoonSnackSchedule: $afternoonSnackSchedule, dinnerSchedule: $dinnerSchedule)";
  }
}
