import 'package:uuid/uuid.dart';

//food consumed
class DietLogFoodRelationModel {
  String id;
  String userId;
  String dietLogId;
  String foodId;
  double grams;

  factory DietLogFoodRelationModel.newEntity(
      String userId, String dietLogId, String foodId, double grams) {
    return DietLogFoodRelationModel.withId(
        Uuid().v4(), userId, dietLogId, foodId, grams);
  }

  DietLogFoodRelationModel.withId(
    this.id,
    this.userId,
    this.dietLogId,
    this.foodId,
    this.grams,
  );

  factory DietLogFoodRelationModel.fromMap(Map<String, dynamic> map) {
    return DietLogFoodRelationModel.withId(
      map["id"],
      map["userId"],
      map["dietLogId"],
      map["foodId"],
      map["grams"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "dietLogId": this.dietLogId,
      "foodId": this.foodId,
      "grams": this.grams,
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, dietLogId: $dietLogId, foodId: $foodId, grams: $grams)";
  }
}
