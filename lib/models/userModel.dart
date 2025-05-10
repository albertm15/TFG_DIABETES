import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  String id;
  String email;
  String? passwordHash;
  int? height;
  double? weight;
  int? typeOfDiabetes;
  String? fullName;
  String? sex;
  String? country;
  String? imagePathUrl;

  UserModel(this.id, this.email);

  UserModel.withId(
      this.id,
      this.email,
      this.passwordHash,
      this.height,
      this.weight,
      this.typeOfDiabetes,
      this.fullName,
      this.sex,
      this.country,
      this.imagePathUrl);

  factory UserModel.rawPassword(
      String email,
      String rawPassword,
      int height,
      double weight,
      int typeOfDiabetes,
      String fullName,
      String sex,
      String country,
      String imagePathUrl) {
    return UserModel.withId(Uuid().v4(), email, encodePassword(rawPassword),
        height, weight, typeOfDiabetes, fullName, sex, country, imagePathUrl);
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel.withId(
        map["id"],
        map["email"],
        map["passwordHash"],
        map["height"],
        map["weight"],
        map["typeOfDiabetes"],
        map["fullName"],
        map["sex"],
        map["country"],
        map["imagePathUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "email": this.email,
      "passwordHash": this.passwordHash,
      "height": this.height,
      "weight": this.weight,
      "typeOfDiabetes": this.typeOfDiabetes,
      "fullName": this.fullName,
      "sex": this.sex,
      "country": this.country,
      "imagePathUrl": this.imagePathUrl
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, email: $email, passwordHash: $passwordHash,height: $height, weight: $weight, typeOfDiabetes: $typeOfDiabetes, fullName: $fullName, sex: $sex, country: $country, imagePathUrl: $imagePathUrl)";
  }

  static String encodePassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
