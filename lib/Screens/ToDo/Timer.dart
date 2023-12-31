import 'dart:async';

import 'package:cmc/Models/todomodels.dart';
import 'package:flutter/material.dart';

class ToDoTimer extends StatefulWidget {
  ToDoModels todo;
  ToDoTimer({super.key, required this.todo});

  @override
  State<ToDoTimer> createState() => _ToDoTimerState();
}

class _ToDoTimerState extends State<ToDoTimer> {
  int? minutes;
  int? hours;
  int seconds = 0;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hours = int.tryParse(widget.todo.hours);
    minutes = int.tryParse(widget.todo.minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.todo.title}',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Container(
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
                    value: seconds == 0 ? 0 : seconds / 60,
                    strokeWidth: 20,
                    color: Colors.green,
                  ),
                ),
                Positioned(
                    bottom: 130,
                    left: 60,
                    child: Text(
                      '${(hours != null) ? (hours! <= 9 ? '0$hours' : '$hours') : '00'} : ${(minutes != null) ? (minutes! <= 9 ? '0$minutes' : '$minutes') : '00'} : ${seconds != null ? seconds <= 9 ? '0$seconds' : '$seconds' : '00'}',
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
                    if (minutes != null && (minutes ?? 0) > 0) {
                      setState(() {
                        seconds = 59;
                        minutes = (minutes ?? 0) - 1;
                      });
                    }
                    if (hours != null &&
                        (hours ?? 0) > 0 &&
                        (minutes ?? -1) == 0) {
                      setState(() {
                        seconds = 59;
                        minutes = 59;
                        hours = (hours ?? 0) - 1;
                      });
                    }
                    timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      int secondref = seconds;
                      int minuteref = minutes ?? -1;

                      if (hours != null && minutes != null) {
                        if (hours == 0 && minutes == 0 && seconds == 0) {
                          Navigator.pop(context);
                        }
                      }

                      if (secondref == 0 && minuteref > 0) {
                        setState(() {
                          minutes = minuteref - 1;
                          seconds = 60;
                        });
                      } else if (secondref == 0 &&
                          minuteref == 0 &&
                          (hours ?? 0) > 0) {
                        setState(() {
                          minutes = 59;
                          seconds = 60;
                          hours = (hours ?? 1) - 1;
                        });
                      } else {
                        setState(() {
                          seconds = seconds - 1;
                        });
                      }
                    });
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      timer!.cancel();
                    },
                    child: Text('Stop', style: TextStyle(color: Colors.black))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    timer?.cancel();
    super.dispose();
  }
}
