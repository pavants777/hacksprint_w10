import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/SplashScreens/verifyEmail.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:cmc/Utills/Custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  UserModels? user;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    UserModels? userref = await FirebaseFunction.getCurrentUser(uid);
    setState(() {
      user = userref;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 200,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
              letterSpacing: 5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Provider.of<UserProvider>(context, listen: false).signOut();
                Navigator.pushReplacementNamed(context, Routes.loginPage);
              },
              icon: Icon(
                FontAwesomeIcons.signOut,
                color: Colors.yellow,
              )),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.yellow,
                  child: CircleAvatar(
                    radius: 95,
                    backgroundImage: NetworkImage(
                        _user.user?.profilePhoto ?? Constant.image),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 35,
                    child: emailWidget(
                        Provider.of<UserProvider>(context, listen: false)
                                .user
                                ?.isEmail ??
                            false,
                        context)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              _user.user?.userName ?? 'Unknow',
              style: TextStyle(color: Colors.yellow, fontSize: 30),
            ),
            Text(
              _user.user?.collegeName ?? 'Unknow',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20),
            ),
            Text(_user.user?.branch ?? 'Unknow',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20)),
            Text(_user.user?.email ?? 'unkown@gmail.com',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20)),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              "Edit Profile",
              FontAwesomeIcons.userPen,
              () {},
            ),
            CustomButton(
              "Contribute to the project",
              FontAwesomeIcons.github,
              () {},
            ),
            CustomButton(
              "Terms and Conditions",
              FontAwesomeIcons.fileInvoice,
              () {},
            ),
            CustomButton(
              "Privacy Policy",
              FontAwesomeIcons.shieldHalved,
              () {
                //TODO: Launch URL in webView
              },
            ),
          ],
        )),
      ),
    );
  }
}

Widget emailWidget(bool isEmail, BuildContext context) {
  if (isEmail) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Colors.white),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.verified,
            color: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Email Verified",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmailVerification()));
    },
    child: Container(
      padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Colors.white),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Verify Email",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
