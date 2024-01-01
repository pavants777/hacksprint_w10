import 'dart:async';

import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/TodoUsers.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/SplashScreens/HomePage.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToDoTimer extends StatefulWidget {
  ToDoModels todo;
  ToDoTimer({super.key, required this.todo});

  @override
  State<ToDoTimer> createState() => _ToDoTimerState();
}

class _ToDoTimerState extends State<ToDoTimer> {
  ToDoUsers? user;
  int? minutes;
  int? hours;
  int? seconds;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    hours = int.tryParse(user?.hours ?? '0');
    minutes = int.tryParse(user?.minutes ?? '0');
    seconds = int.tryParse(user?.seconds ?? '0');
    if (hours != null && minutes != null && seconds != null) {
      if (hours == 0 && minutes == 0 && seconds == 0) {
        FirebaseToDo.changeTime(
            minutes, hours, seconds, user?.uid ?? "", widget.todo,
            isCompleted: true);
      }
    }
  }

  void getUser() {
    ToDoUsers currentUser = widget.todo.users.firstWhere(
      (user) => user.uid == FirebaseAuth.instance.currentUser!.uid,
      orElse: () => ToDoUsers(
          uid: '', hours: '', minutes: '', seconds: '', isCompleted: false),
    );
    setState(() {
      user = currentUser;
    });
    print('Current user: ${currentUser.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            FirebaseToDo.changeTime(
                minutes, hours, seconds, user?.uid ?? "", widget.todo);
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${widget.todo.title}',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: user!.isCompleted
          ? _buildCompletedWidget()
          : Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          value: (seconds != null && seconds != 0)
                              ? seconds! / 60.0
                              : 0.0,
                          strokeWidth: 20,
                          color: Colors.green,
                        ),
                      ),
                      Positioned(
                          bottom: 130,
                          left: 60,
                          child: Text(
                            '${(hours != null) ? (hours! <= 9 ? '0$hours' : '$hours') : '00'} : ${(minutes != null) ? (minutes! <= 9 ? '0$minutes' : '$minutes') : '00'} : ${seconds != null ? seconds! <= 9 ? '0$seconds' : '$seconds' : '00'}',
                            style: TextStyle(fontSize: 40),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          timerLogic();
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            Get.snackbar("${widget.todo.groupName}",
                                "Your Stoping Your timer");
                            FirebaseToDo.changeTime(minutes, hours, seconds,
                                user?.uid ?? "", widget.todo);
                            timer!.cancel();
                          },
                          child: Text('Stop',
                              style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void timerLogic() {
    Get.snackbar(
        "${widget.todo.groupName}", "Your Starting ${widget.todo.title} work");

    if (minutes != null && (minutes ?? 0) > 0) {
      setState(() {
        seconds = 59;
        minutes = (minutes ?? 0) - 1;
      });
    }
    if (hours != null && (hours ?? 0) > 0 && (minutes ?? -1) == 0) {
      setState(() {
        seconds = 59;
        minutes = 59;
        hours = (hours ?? 0) - 1;
      });
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int secondref = seconds ?? 0;
      int minuteref = minutes ?? -1;

      if (hours != null && minutes != null) {
        if (hours == 0 && minutes == 0 && seconds == 0) {
          FirebaseToDo.changeTime(
              minutes, hours, seconds, user?.uid ?? "", widget.todo,
              isCompleted: true);
          setState(() {
            Get.snackbar("${widget.todo.groupName}",
                "Your Are Completed Your Task Congrats");
            user?.isCompleted = true;
          });
        }
      }

      if (secondref == 0 && minuteref > 0) {
        setState(() {
          minutes = minuteref - 1;
          seconds = 60;
          FirebaseToDo.changeTime(
              minutes, hours, seconds, user?.uid ?? "", widget.todo);
        });
      } else if (secondref == 0 && minuteref == 0 && (hours ?? 0) > 0) {
        setState(() {
          minutes = 59;
          seconds = 60;
          hours = (hours ?? 1) - 1;
          FirebaseToDo.changeTime(
              minutes, hours, seconds, user?.uid ?? "", widget.todo);
        });
      } else {
        setState(() {
          seconds = seconds! - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _buildCompletedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Stack(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 20,
                  color: Colors.green,
                ),
              ),
              Positioned(
                bottom: 50,
                left: 60,
                child: Icon(
                  Icons.check,
                  size: 200,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Completed',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
