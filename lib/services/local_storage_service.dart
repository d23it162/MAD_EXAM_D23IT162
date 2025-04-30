import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class LocalStorageService {
  static const String _todoBox = 'todos';
  static const String _commandQueueBox = 'commandQueue';

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>(_todoBox);
    await Hive.openBox<Map>(_commandQueueBox);
  }

  Future<void> saveTodo(Todo todo) async {
    final box = await Hive.openBox<Todo>(_todoBox);
    await box.put(todo.id, todo);
  }

  Future<void> queueCommand(String command, Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>(_commandQueueBox);
    await box.add({
      'command': command,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map>> getQueuedCommands() async {
    final box = await Hive.openBox<Map>(_commandQueueBox);
    return box.values.toList();
  }

  Future<void> clearQueuedCommand(int index) async {
    final box = await Hive.openBox<Map>(_commandQueueBox);
    await box.deleteAt(index);
  }

  Future<List<Todo>> getAllTodos() async {
    final box = await Hive.openBox<Todo>(_todoBox);
    return box.values.toList();
  }

  Future<void> deleteTodo(String id) async {
    final box = await Hive.openBox<Todo>(_todoBox);
    await box.delete(id);
  }

  Future<void> updateTodo(Todo todo) async {
    final box = await Hive.openBox<Todo>(_todoBox);
    await box.put(todo.id, todo);
  }
} 