import 'package:uuid/uuid.dart';

class ReminderModel {
  String id;
  String userId;
  String title;
  String time;
  String date;
  bool repeat;
  String repeatConfig;

  factory ReminderModel.newEntity(String userId, String title, String time,
      String date, bool repeat, String repeatConfig) {
    return ReminderModel.withId(
        Uuid().v4(), userId, title, time, date, repeat, repeatConfig);
  }

  ReminderModel.withId(this.id, this.userId, this.title, this.time, this.date,
      this.repeat, this.repeatConfig);

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel.withId(
      map["id"],
      map["userId"],
      map["title"],
      map["time"],
      map["date"],
      map["repeat"],
      map["repeatConfig"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "title": this.title,
      "time": this.time,
      "date": this.date,
      "repeat": this.repeat,
      "repeatConfig": this.repeatConfig
    };
  }

  @override
  String toString() {
    return "Transactions(id: $id, userId: $userId,title: $title, time: $time, date: $date, repeat: $repeat, repeatConfig: $repeatConfig)";
  }
}
