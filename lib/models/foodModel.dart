import 'package:uuid/uuid.dart';

class FoodModel {
  String id;
  String userId;
  double carbsPer100;
  String name;

  factory FoodModel.newEntity(String userId, double carbsPer100, String name) {
    return FoodModel.withId(Uuid().v4(), userId, carbsPer100, name);
  }

  FoodModel.withId(this.id, this.userId, this.carbsPer100, this.name);

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel.withId(
        map["id"], map["userId"], map["carbsPer100"], map["name"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "carbsPer100": this.carbsPer100,
      "name": this.name,
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId, carbsPer100: $carbsPer100, name: $name)";
  }
}
