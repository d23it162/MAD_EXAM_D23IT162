import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/firebase_service.dart';
import '../services/voice_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());
final voiceServiceProvider = Provider<VoiceService>((ref) => VoiceService());

class TodoNotifier extends StateNotifier<List<Todo>> {
  final FirebaseService _firebaseService;
  final VoiceService _voiceService;

  TodoNotifier(this._firebaseService, this._voiceService) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await _firebaseService.getTodos();
      state = todos;
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    try {
      await _firebaseService.addTodo(todo);
      state = [...state, todo];
      await _voiceService.speak('Added: $title');
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> toggleTodo(String id) async {
    final todo = state.firstWhere((t) => t.id == id);
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );

    try {
      await _firebaseService.updateTodo(updatedTodo);
      state = state.map((t) => t.id == id ? updatedTodo : t).toList();
      await _voiceService.speak(
        updatedTodo.isCompleted ? 'Completed: ${todo.title}' : 'Uncompleted: ${todo.title}',
      );
    } catch (e) {
      print('Error toggling todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _firebaseService.deleteTodo(id);
      state = state.where((t) => t.id != id).toList();
      await _voiceService.speak('Task deleted');
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier(
    ref.watch(firebaseServiceProvider),
    ref.watch(voiceServiceProvider),
  );
}); 