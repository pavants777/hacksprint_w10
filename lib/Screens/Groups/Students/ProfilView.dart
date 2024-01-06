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

class ProfileView extends StatefulWidget {
  UserModels? user;
  ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
                        widget.user?.profilePhoto ?? Constant.image),
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
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.user?.userName ?? 'Unknow',
              style: const TextStyle(color: Colors.yellow, fontSize: 30),
            ),
            Text(
              widget.user?.collegeName ?? 'Unknow',
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
            ),
            Text(widget.user?.branch ?? 'Unknow',
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
            Text(widget.user?.email ?? 'unkown@gmail.com',
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              "Portfolio",
              FontAwesomeIcons.userCheck,
              () {},
              screenWidth,
            ),
            CustomButton(
              "Github Link",
              FontAwesomeIcons.github,
              () {},
              screenWidth,
            ),
            CustomButton(
              "LinkedIn",
              FontAwesomeIcons.linkedin,
              () {},
              screenWidth,
            ),
            CustomButton(
              "Discord",
              FontAwesomeIcons.discord,
              () {},
              screenWidth,
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
      padding: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
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
      padding: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
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
