import 'package:diabetes_tfg_app/models/foodModel.dart';

class Selectedfood {
  int quantity;
  FoodModel food;

  Selectedfood({required this.quantity, required this.food});

  @override
  String toString() {
    return '${food.name}: $quantity g, ${(quantity * (food.carbsPer100 / 100)) / 10} U';
  }
}
