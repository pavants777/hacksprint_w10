import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Function/firebase_function.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

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
                CompanyLogo(200.0, 200.0),
                Padding(padding: EdgeInsets.all(screenWidth * 0.05)),
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
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseSplashFunction.login(
                        _email.text, _password.text, context);
                    _email.clear();
                    _password.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 100,
                    child: Text(
                      'LogIn',
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
                    Text("Don't hava account ?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.signIn);
                      },
                      child: const Text(
                        ' Sign In',
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
