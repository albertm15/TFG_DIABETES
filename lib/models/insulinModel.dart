import 'package:uuid/uuid.dart';

class InsulinModel {
  String id;
  String userId;
  String firstInjectionSchedule;
  String secondInjectionSchedule;
  double totalSlowActingInsulin;
  double totalFastActingInsulin;

  factory InsulinModel.newEntity(
      String userId,
      String firstInjectionSchedule,
      String secondInjectionSchedule,
      double totalSlowActingInsulin,
      double totalFastActingInsulin) {
    return InsulinModel.withId(
        Uuid().v4(),
        userId,
        firstInjectionSchedule,
        secondInjectionSchedule,
        totalSlowActingInsulin,
        totalFastActingInsulin);
  }

  InsulinModel.withId(
      this.id,
      this.userId,
      this.firstInjectionSchedule,
      this.secondInjectionSchedule,
      this.totalSlowActingInsulin,
      this.totalFastActingInsulin);

  factory InsulinModel.fromMap(Map<String, dynamic> map) {
    return InsulinModel.withId(
        map["id"],
        map["userId"],
        map["firstInjectionSchedule"],
        map["secondInjectionSchedule"],
        map["totalSlowActingInsulin"],
        map["totalFastActingInsulin"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "firstInjectionSchedule": this.firstInjectionSchedule,
      "secondInjectionSchedule": this.secondInjectionSchedule,
      "totalSlowActingInsulin": this.totalSlowActingInsulin,
      "totalFastActingInsulin": this.totalFastActingInsulin
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, firstInjectionSchedule: $firstInjectionSchedule, totalSlowActingInsulin: $totalSlowActingInsulin, totalFastActingInsulin: $totalFastActingInsulin)";
  }
}
