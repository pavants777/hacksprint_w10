import 'dart:async';
import 'package:cmc/Models/todomodels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoProvider with ChangeNotifier {
  double _completionRatio = 0;

  double get completionRatio => _completionRatio;

  List<ToDoModels>? todo;
  List<ToDoModels>? completed;
  List<ToDoModels>? sortTodo;

  ToDoProvider() {}

  void calculateCompletionRatio() {
    double ratio = sortTodo == null ? 0 : completed!.length / sortTodo!.length;
    if (ratio != _completionRatio) {
      _completionRatio = ratio;
      print('${(_completionRatio * 100).toStringAsFixed(0)}%');
    }
  }

  void loadData(List<ToDoModels> data) {
    todo = data;
    sortTodo = todo
            ?.where((todo) =>
                isUserInGroup(todo, FirebaseAuth.instance.currentUser!.uid))
            .toList() ??
        [];
    completed = sortTodo
            ?.where((element) =>
                isCompleted(element, FirebaseAuth.instance.currentUser!.uid))
            .toList() ??
        [];

    calculateCompletionRatio();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool isUserInGroup(ToDoModels todo, String userId) {
    return todo.members.any((user) => user == userId);
  }

  bool isCompleted(ToDoModels todo, String userId) {
    return todo.completed.any((element) => element == userId);
  }

  @override
  void dispose() {
    // Cancel stream subscriptions here.
    super.dispose();
  }
}
