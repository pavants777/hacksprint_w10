import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:intl/intl.dart';

class FirebaseToDo {
  static Future<void> createTodo(
      String groupId,
      String groupName,
      String title,
      hours,
      minutes,
      List<String> completed,
      List<String> tags,
      List<String> members) async {
    ToDoModels todo = ToDoModels(
      groupId: groupId,
      groupName: groupName,
      title: title,
      hours: hours,
      minutes: minutes,
      completed: completed,
      tags: tags,
      members: members,
    );

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    print('todo is created');
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(formattedDate)
        .collection('data')
        .doc(groupId)
        .set(todo.toMap());
  }

  static Future<List<ToDoModels>> gettodo() async {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('todo')
          .doc(formattedDate)
          .collection('data')
          .get();

      List<ToDoModels> todos = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        todos.add(ToDoModels.fromJson(doc.data() as Map<String, dynamic>));
      }

      return todos;
    } catch (e) {
      print("Error fetching todo data: $e");
      return [];
    }
  }
}
