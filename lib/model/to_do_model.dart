import 'dart:convert';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import 'package:maybank_todo/model/database/data.dart';
import 'package:maybank_todo/model/database/database_controller.dart';
import 'package:maybank_todo/model/database/database_model.dart';

const ToDoModelTableName = "todo";

class ToDoModel extends Data {
  final String? id;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  ToDoStatus status;
  ToDoModel({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.status = ToDoStatus.pending,
  });

  @override
  List<DatabaseModel> setDatabase() {
    return [
      DatabaseModel("id", columnType: DbDataType.TEXT, isPrimarykey: true),
      DatabaseModel("title", columnType: DbDataType.TEXT),
      DatabaseModel("startDate", columnType: DbDataType.INTEGER),
      DatabaseModel("endDate", columnType: DbDataType.INTEGER),
      DatabaseModel("status", columnType: DbDataType.TEXT),
    ];
  }

  @override
  String get tableName => ToDoModelTableName;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'status': status.name,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      status: ToDoStatus.values
          .firstWhere((element) => element.name == map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDoModel.fromJson(String source) =>
      ToDoModel.fromMap(json.decode(source));

  ToDoModel copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    ToDoStatus? status,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}

// Model Function
extension ToDoModelFunction on ToDoModel {
  // Format to minimum 2 digits string
  String getDigits(int n) {
    return (n > 9) ? n.toString() : n.toString().padLeft(2, '0');
  }

  // Get time left string, however return "-" if status is completed, or pass end date
  String getTimeLeft() {
    DateTime initialDate = DateTime(startDate?.year ?? 0, startDate?.month ?? 0,
        startDate?.day ?? 0, 0, 0, 0);
    DateTime lastDate = DateTime(endDate?.year ?? 0, endDate?.month ?? 0,
        (endDate?.day ?? 0) + 1, 0, 0, 0);
    DateTime now = DateTime.now();

    if (lastDate.isBefore(now) || status == ToDoStatus.completed) {
      return "--";
    }

    if (initialDate.isBefore(now)) {
      initialDate = DateTime.now();
    }

    Duration diff = lastDate.difference(initialDate);
    if (diff.inSeconds < 60) {
      return getDigits(diff.inSeconds);
    } else {
      final int hours = diff.inHours;
      final int minute = diff.inMinutes.remainder(60);

      return "${hours > 0 ? "${getDigits(hours)} hrs " : ""} ${getDigits(minute)} min";
    }
  }
}

// Model Database Query
extension ToDoModelDb on ToDoModel {
  // Save New Or Replace Model To Database
  Future<bool> save() async {
    final db = DatabaseController.db.getDb();
    int result = await db.insert(ToDoModelTableName, toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return (result != 0);
  }

  // Delete Current Model from Database
  Future<bool> delete() async {
    final db = DatabaseController.db.getDb();
    final result = await db
        .rawDelete("DELETE FROM $ToDoModelTableName WHERE id = ?", [id]);

    return (result != 0);
  }

  // Get All To Do List from Database
  static Future<List<ToDoModel>> getAll() async {
    final db = DatabaseController.db.getDb();

    final result = await db.query(ToDoModelTableName);

    return List.generate(
        result.length, (index) => ToDoModel.fromMap(result[index]));
  }
}

// To Do Enum
enum ToDoStatus { pending, completed }

extension ToDoStatusExtension on ToDoStatus {
  String get desc {
    switch (this) {
      case ToDoStatus.pending:
        return "Incomplete";
      case ToDoStatus.completed:
        return "Completed";
    }
  }
}
