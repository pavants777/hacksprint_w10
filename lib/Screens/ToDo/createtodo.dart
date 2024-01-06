import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateToDo extends StatefulWidget {
  GroupModels? group;

  CreateToDo({Key? key, required this.group}) : super(key: key);

  @override
  State<CreateToDo> createState() => _CreateToDoState();
}

class _CreateToDoState extends State<CreateToDo> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _hours = TextEditingController();
  final TextEditingController _minutes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String>? tags = widget.group?.tags;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New ToDo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CompanyLogo(150, 150),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hours,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          hintText: 'Hours',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _minutes,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          hintText: 'Minutes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tags!.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() {
                            tags.remove(tag);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    FirebaseToDo.createTodo(
                        widget.group?.groupId ?? "Unknown",
                        widget.group?.groupName ?? "Unkown",
                        _title.text,
                        _hours.text,
                        _minutes.text,
                        '',
                        [],
                        tags,
                        widget.group?.users ?? []);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      ' Create ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
