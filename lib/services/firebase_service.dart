import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  Future<void> addTodo(Todo todo) async {
    await _firestore.collection(_collection).doc(todo.id).set(todo.toJson());
  }

  Future<void> updateTodo(Todo todo) async {
    await _firestore.collection(_collection).doc(todo.id).update(todo.toJson());
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
        .map((snapshot) => snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
  }
} 