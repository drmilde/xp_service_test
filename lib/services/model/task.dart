// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskListFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskListToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.rewardCoins,
    required this.rewardTickets,
    required this.hasRewardXp,
  });

  int id;
  String title;
  String category;
  int rewardCoins;
  int rewardTickets;
  List<int> hasRewardXp;

  Task.empty({
    this.id = 0,
    this.title = "title",
    this.category = "category",
    this.rewardCoins = 0,
    this.rewardTickets = 0,
    this.hasRewardXp = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        category: json["category"],
        rewardCoins: json["rewardCoins"],
        rewardTickets: json["rewardTickets"],
        hasRewardXp: List<int>.from(json["hasRewardXP"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "rewardCoins": rewardCoins,
        "rewardTickets": rewardTickets,
        "hasRewardXP": List<dynamic>.from(hasRewardXp.map((x) => x)),
      };
}
