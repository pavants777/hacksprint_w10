import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/ToDo/leaderboard.dart';
import 'package:flutter/material.dart';

class CompletedPage extends StatelessWidget {
  ToDoModels todo;
  CompletedPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderBoard(todo: todo),
                  ),
                );
              },
              child: const Text(
                'Leaderboard',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.homePage, (route) => false);
              },
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
