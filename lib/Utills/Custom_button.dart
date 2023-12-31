import 'package:flutter/material.dart';

Widget CustomButton(
    String title, IconData icon, VoidCallback onTap, double screenWidth) {
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        width: screenWidth * 0.90 - 30, // Adjusted for padding
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.red, Colors.green],
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 50),
            Icon(icon, color: Colors.yellow),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                title,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color.fromARGB(255, 249, 249, 249),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
