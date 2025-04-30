import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  Future<void> addTodo(Todo todo) async {
    final docRef = _firestore.collection(_collection).doc(todo.id);
    final snapshot = await docRef.get();
    
    if (!snapshot.exists) {
      await docRef.set(todo.toJson());
    } else {
      // Handle conflict by appending timestamp to id
      final newId = '${todo.id}_${DateTime.now().millisecondsSinceEpoch}';
      await _firestore.collection(_collection).doc(newId).set(
        todo.copyWith(id: newId).toJson()
      );
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final docRef = _firestore.collection(_collection).doc(todo.id);
    final snapshot = await docRef.get();
    
    if (snapshot.exists) {
      final currentData = snapshot.data() as Map<String, dynamic>;
      final currentTodo = Todo.fromJson(currentData);
      
      // Only update if the local version is newer
      if (todo.completedAt == null || 
          (currentTodo.completedAt != null && 
           todo.completedAt!.isAfter(currentTodo.completedAt!))) {
        await docRef.update(todo.toJson());
      }
    }
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Future<List<Todo>> getTodos() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
  }

  Stream<List<Todo>> getTodosStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
  }

  Future<void> syncOfflineChanges(List<Map> queuedCommands) async {
    for (final command in queuedCommands) {
      switch (command['command']) {
        case 'add':
          await addTodo(Todo.fromJson(command['data']));
          break;
        case 'update':
          await updateTodo(Todo.fromJson(command['data']));
          break;
        case 'delete':
          await deleteTodo(command['data']['id']);
          break;
      }
    }
  }
} 