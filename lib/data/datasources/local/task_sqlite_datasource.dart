import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class TaskSqliteDatasource {
  static final TaskSqliteDatasource _instance =
      TaskSqliteDatasource._internal();
  factory TaskSqliteDatasource() => _instance;
  TaskSqliteDatasource._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = join(dbDir.path, dbName);

    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        start_date TEXT,
        deadline_hour INTEGER,
        deadline_minute INTEGER,
        priority TEXT,
        is_completed INTEGER
      )
''');
  }

  Map<String, dynamic> _toMap(TaskEntity task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate?.toIso8601String(),
      'start_date': task.startDate?.toIso8601String(),
      'deadline_hour': task.deadline?.hour,
      'deadline_minute': task.deadline?.minute,
      'priority': task.priorityType?.name,
      'is_completed': task.isCompleted ? 1 : 0,
    };
  }

  TaskEntity _fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'])
          : null,
      deadline: map['dealine_hour'] != null && map['deadline_minute'] != null
          ? TimeOfDay(
              hour: map['deadline_hour'] as int,
              minute: map['deadline_minute'] as int,
            )
          : null,
      priorityType: map['priority'] != null
          ? PriorityType.values.firstWhere(
              (e) => e.name == map['priority'],
              orElse: () => PriorityType.low,
            )
          : null,
    );
  }

  Future<int> addTask(TaskEntity task) async {
    final db = await database;
    return await db.insert('tasks', _toMap(task));
  }

  Future<List<TaskEntity>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map(_fromMap).toList();
  }

  Future<TaskEntity> getTaskById(int id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    return _fromMap(maps.first);
  }

  Future<List<TaskEntity>> searchTasks(String query) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map(_fromMap).toList();
  }
}
