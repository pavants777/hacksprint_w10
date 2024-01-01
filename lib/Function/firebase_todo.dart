import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/TodoUsers.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:intl/intl.dart';

class FirebaseToDo {
  static Future<void> createTodo(
      String groupId,
      String groupName,
      String title,
      String hours,
      String minutes,
      List<String> completed,
      List<String> tags,
      List<String> members,
      {String seconds = "00"}) async {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    List<ToDoUsers> todoUsersList = members
        .map((memberId) => ToDoUsers(
              uid: memberId,
              hours: hours,
              minutes: minutes,
              seconds: seconds,
              isCompleted: false,
            ))
        .toList();

    DocumentReference ref = FirebaseFirestore.instance
        .collection('todo')
        .doc(formattedDate)
        .collection('data')
        .doc();

    String refId = ref.id;

    ToDoModels todo = ToDoModels(
      refId: refId,
      groupId: groupId,
      groupName: groupName,
      title: title,
      hours: hours.toString(),
      minutes: minutes.toString(),
      completed: completed,
      tags: tags,
      users: todoUsersList,
    );
    await ref.set(todo.toMap());
  }

  static Stream<List<ToDoModels>> getTodo() async* {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('todo')
              .doc(formattedDate)
              .collection('data')
              .get();

      List<ToDoModels> todos = [];
      for (var doc in querySnapshot.docs) {
        todos.add(ToDoModels.fromJson(doc.data()));
      }

      yield todos;
    } catch (e) {
      print("Error fetching todo data: $e");
      yield [];
    }
  }

  static Future<void> changeTime(
      int? minutes, int? hours, int? seconds, String uid, ToDoModels todo,
      {isCompleted = false}) async {
    print('function call');
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    try {
      ToDoUsers userToUpdate = todo.users.firstWhere(
        (user) => user.uid == uid,
        orElse: () => ToDoUsers(
            uid: '', hours: '', minutes: '', seconds: '', isCompleted: false),
      );

      if (userToUpdate.uid.isNotEmpty) {
        userToUpdate.hours = hours.toString();
        userToUpdate.minutes = minutes.toString();
        userToUpdate.seconds = seconds.toString();
        userToUpdate.isCompleted = isCompleted;
        List<ToDoUsers> updatedUsers = List.from(todo.users);
        int index = updatedUsers.indexWhere((user) => user.uid == uid);
        if (index != -1) {
          updatedUsers[index] = userToUpdate;
        } else {
          print('User with UID $uid not found in todo.users.');
        }

        DocumentReference docRef = FirebaseFirestore.instance
            .collection('todo')
            .doc(formattedDate)
            .collection('data')
            .doc(todo.refId);

        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await docRef.get() as DocumentSnapshot<Map<String, dynamic>>;
        if (docSnapshot.exists) {
          await docRef.update(
              {'users': updatedUsers.map((user) => user.toMap()).toList()});
          print('Time updated successfully');
        } else {
          print('Document with refId ${todo.refId} not found.');
        }
      } else {
        print('User with UID $uid not found in todo.users.');
      }
    } catch (e) {
      print('Error updating time: $e');
    }
  }
}
