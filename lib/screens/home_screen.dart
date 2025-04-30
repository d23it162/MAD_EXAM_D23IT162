import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../services/voice_service.dart';
import '../models/todo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final VoiceService _voiceService = VoiceService();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    await _voiceService.initialize();
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      await _voiceService.startListening((text) {
        _processVoiceCommand(text);
        setState(() => _isListening = false);
      });
    }
  }

  void _processVoiceCommand(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains('add') || lowerText.contains('create') || lowerText.contains('new')) {
      _addTask(text);
    } else if (lowerText.contains('delete') || lowerText.contains('remove')) {
      _deleteTask(text);
    } else if (lowerText.contains('complete') || lowerText.contains('done')) {
      _completeTask(text);
    } else if (lowerText.contains('uncomplete') || lowerText.contains('undo')) {
      _uncompleteTask(text);
    }
  }

  void _addTask(String text) {
    final title = text.replaceAll(RegExp(r'^(add|create|new)\s+'), '').trim();
    if (title.isNotEmpty) {
      ref.read(todoProvider.notifier).addTodo(title);
      _textController.clear();
    }
  }

  void _deleteTask(String text) {
    final title = text.replaceAll(RegExp(r'^(delete|remove)\s+'), '').trim();
    if (title.isNotEmpty) {
      final todos = ref.read(todoProvider);
      final todo = todos.firstWhere(
        (t) => t.title.toLowerCase().contains(title.toLowerCase()),
        orElse: () => Todo(id: '', title: '', isCompleted: false, createdAt: DateTime.now()),
      );
      if (todo.id.isNotEmpty) {
        ref.read(todoProvider.notifier).deleteTodo(todo.id);
      }
    }
  }

  void _completeTask(String text) {
    final title = text.replaceAll(RegExp(r'^(complete|done)\s+'), '').trim();
    if (title.isNotEmpty) {
      final todos = ref.read(todoProvider);
      final todo = todos.firstWhere(
        (t) => t.title.toLowerCase().contains(title.toLowerCase()),
        orElse: () => Todo(id: '', title: '', isCompleted: false, createdAt: DateTime.now()),
      );
      if (todo.id.isNotEmpty && !todo.isCompleted) {
        ref.read(todoProvider.notifier).toggleTodo(todo.id);
      }
    }
  }

  void _uncompleteTask(String text) {
    final title = text.replaceAll(RegExp(r'^(uncomplete|undo)\s+'), '').trim();
    if (title.isNotEmpty) {
      final todos = ref.read(todoProvider);
      final todo = todos.firstWhere(
        (t) => t.title.toLowerCase().contains(title.toLowerCase()),
        orElse: () => Todo(id: '', title: '', isCompleted: false, createdAt: DateTime.now()),
      );
      if (todo.id.isNotEmpty && todo.isCompleted) {
        ref.read(todoProvider.notifier).toggleTodo(todo.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Todo App'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _startListening,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task or use voice command',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      ref.read(todoProvider.notifier).addTodo(_textController.text);
                      _textController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      ref.read(todoProvider.notifier).toggleTodo(todo.id);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(todoProvider.notifier).deleteTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
} 