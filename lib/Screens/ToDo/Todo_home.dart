import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Screens/ToDo/Timer.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  List<ToDoModels>? _toDos;
  List<ToDoModels>? _userToDos;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(today);
    return Scaffold(
      appBar: appBar("ToDo's", context) as PreferredSizeWidget?,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            formattedDate,
            style: const TextStyle(
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

  Widget _buildToDoList() {
    return StreamBuilder<List<ToDoModels>>(
        stream: FirebaseToDo.getTodo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error Genrating'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Indicator();
          } else {
            _toDos = snapshot.data;
            _userToDos = _toDos!
                    .where((todo) => _isUserInGroup(
                        todo, FirebaseAuth.instance.currentUser!.uid))
                    .toList() ??
                [];
            if (_userToDos == null || _userToDos!.isEmpty) {
              return const Center(
                child: Text('No To-Do available for You'),
              );
            }
            return ListView.builder(
                itemCount: _userToDos?.length,
                itemBuilder: (context, index) {
                  return _buildtodoItem(_userToDos![index]);
                });
          }
        });
  }

  Widget _buildtodoItem(ToDoModels toDo) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ToDoTimer(todo: toDo)));
        },
        child: Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.all(10),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 12, 52, 85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
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

  bool _isUserInGroup(ToDoModels todo, String userId) {
    return todo.users.any((user) => user.uid == userId) ?? false;
  }
}
