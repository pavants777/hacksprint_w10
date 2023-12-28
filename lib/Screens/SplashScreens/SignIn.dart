import 'package:cmc/Function/firebase_function.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/SplashScreens/UserInfoScreens.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conPassword = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _email.clear();
    _password.clear();
    _conPassword.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CompanyLogo(150, 150),
                Padding(padding: EdgeInsets.all(screenWidth * 0.02)),
                Container(
                    width: 300,
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
                Padding(padding: EdgeInsets.all(screenWidth * 0.05)),
                Container(
                    width: 300,
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        prefixIcon: Icon(Icons.key),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
                Padding(padding: EdgeInsets.all(screenWidth * 0.05)),
                Container(
                    width: 300,
                    child: TextField(
                      controller: _conPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        prefixIcon: Icon(Icons.key),
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    if (_conPassword.text == _password.text) {
                      FirebaseSplashFunction.createUser(
                          _email.text, _password.text, context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Password is not Matching'),
                        duration: Duration(seconds: 5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    _email.clear();
                    _password.clear();
                    _conPassword.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 100,
                    child: Text(
                      'SingIn',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("I Have An Account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.loginPage);
                      },
                      child: const Text(
                        ' Log In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 100,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'OR',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 1,
                      width: 100,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/01.webp',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/download.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
