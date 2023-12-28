import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:cmc/Utills/accountScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget appBar(String title, BuildContext context) {
  var _user = Provider.of<UserProvider>(context, listen: false);
  return AppBar(
    leading:
        Padding(padding: EdgeInsets.only(left: 10), child: CompanyLogo(10, 20)),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.yellow,
      ),
    ),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountScreen()));
        },
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.yellow,
          child: CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage(_user.user?.profilePhoto ?? Constant.image),
          ),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
    ],
  );
}
