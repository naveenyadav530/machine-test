import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.createdAtDate,
      required this.isCompleted});

  /// ID
  @HiveField(0)
  final String id;

  /// TITLE
  @HiveField(1)
  String title;

  /// SUBTITLE
  @HiveField(2)
  String subtitle;

  /// CREATED AT DATE
  @HiveField(3)
  DateTime createdAtDate;

  /// IS COMPLETED
  @HiveField(4)
  bool isCompleted;

  /// create new Task
  factory Task.create({
    required String? title,
    required String? subtitle,
    DateTime? createdAtDate,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title ?? "",
        subtitle: subtitle ?? "",
        isCompleted: false,
        createdAtDate: createdAtDate ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'createdAtDate': createdAtDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      createdAtDate: DateTime.parse(map['createdAtDate']),
      isCompleted: map['isCompleted'],
    );
  }
  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? createdAtDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAtDate: createdAtDate ?? this.createdAtDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
