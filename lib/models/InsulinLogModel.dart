import 'package:diabetes_tfg_app/auxiliarResources/InjectionLocationsEnum.dart';
import 'package:uuid/uuid.dart';

class InsulinLogModel {
  String id;
  String userId;
  double fastActingInsulinConsumed;
  String date;
  String time;
  String location;

  factory InsulinLogModel.newEntity(
      String userId,
      double fastActingInsulinConsumed,
      String date,
      String time,
      String location) {
    return InsulinLogModel.withId(
        Uuid().v4(), userId, fastActingInsulinConsumed, date, time, location);
  }

  InsulinLogModel.withId(this.id, this.userId, this.fastActingInsulinConsumed,
      this.date, this.time, this.location);

  factory InsulinLogModel.fromMap(Map<String, dynamic> map) {
    return InsulinLogModel.withId(
        map["id"],
        map["userId"],
        map["fastActingInsulinConsumed"],
        map["date"],
        map["time"],
        map["location"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "fastActingInsulinConsumed": this.fastActingInsulinConsumed,
      "date": this.date,
      "time": this.time,
      "location": this.location
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, fastActingInsulinConsumed: $fastActingInsulinConsumed, date: $date, time: $time, location: $location)";
  }
}
