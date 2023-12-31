import 'dart:async';
import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Screens/ToDo/Timer.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoHome extends StatefulWidget {
  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  double _completionRatio = 0;
  List<ToDoModels>? _todo;
  List<ToDoModels>? _completed;
  List<ToDoModels>? _sortTodo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _calculateCompletionRatio() {
    double ratio = _sortTodo == null || _sortTodo!.isEmpty
        ? 0
        : _completed!.length / _sortTodo!.length;

    if (ratio != _completionRatio) {
      setState(() {
        _completionRatio = ratio;
        print('${(_completionRatio * 100).toStringAsFixed(0)}%');
      });
    }
  }

  void _loadData() async {
    List<ToDoModels> data = await FirebaseToDo.gettodo();
    setState(() {
      _todo = data;
    });
    _sortTodo = _todo
            ?.where((todo) =>
                _isUserInGroup(todo, FirebaseAuth.instance.currentUser!.uid))
            .toList() ??
        [];
    _completed = _sortTodo
            ?.where((element) =>
                _isCompleted(element, FirebaseAuth.instance.currentUser!.uid))
            .toList() ??
        [];

    _calculateCompletionRatio();
  }

  bool _isUserInGroup(ToDoModels todo, String userId) {
    return todo.members.any((user) => user == userId);
  }

  bool _isCompleted(ToDoModels todo, String userId) {
    return todo.completed.any((element) => element == userId);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(today);
    return Scaffold(
      appBar: appBar("ToDo's", context) as PreferredSizeWidget?,
      bottomSheet: _buildBottomSheet(),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '${formattedDate}',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: _buildToDoList()),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('ToDo'),
    );
  }

  Widget _buildBottomSheet() {
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: LinearProgressIndicator(
            value: _completionRatio,
            color: Colors.green,
          ),
        ),
        Positioned(
          bottom: -5,
          left: _completionRatio != 0 ? screenWidth * 0.40 : screenWidth * 0.45,
          child: Text(
            '${(_completionRatio * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToDoList() {
    if (_sortTodo == null || _sortTodo!.isEmpty) {
      return Center(
        child: Text(
          'No To-Do available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: _sortTodo!.length,
      itemBuilder: (context, index) {
        return _buildtodoItem(_sortTodo![index]);
      },
    );
  }

  Widget _buildtodoItem(ToDoModels toDo) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          int? hours = int.tryParse(toDo.hours);
          int? minutes = int.tryParse(toDo.minutes);

          if (hours != null && minutes != null && hours != 0 && minutes != 0) {
            print("Both hours and minutes are zero!");
          } else {
            print('your are completed');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToDoTimer(todo: toDo),
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(width: 0.5, color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                '${toDo.title}  : ${toDo.groupName}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${toDo.hours} : ${toDo.minutes}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 4,
                runSpacing: 5,
                children: toDo.tags
                    .take(3)
                    .map((tag) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 12, 52, 85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
