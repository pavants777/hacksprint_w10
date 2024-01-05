import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/Groups/QuestionPager/QuestionHome.dart';
import 'package:cmc/Screens/Groups/Students/studentsHome.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerForApp extends StatefulWidget {
  @override
  State<DrawerForApp> createState() => _DrawerForAppState();
}

class _DrawerForAppState extends State<DrawerForApp> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                  padding: EdgeInsets.all(0),
                  child: Center(child: CompanyLogo(150, 150))),
              ExpansionTile(
                childrenPadding: EdgeInsets.all(20),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${user.user?.userName ?? "Unkown"}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                children: [
                  Text('Email :'),
                  Text('${user.user?.email ?? "Email@gmail.com"}'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ExpansionTile(
                childrenPadding: EdgeInsets.all(20),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.skip_previous),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Previous',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuestionPage()));
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.question_answer,
                                    color: Color.fromARGB(255, 251, 242, 161),
                                  )),
                              Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Question Paper',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 251, 242, 161),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentHome()));
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.people_alt_sharp,
                                    color: Color.fromARGB(255, 251, 242, 161),
                                  )),
                              Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Students',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 251, 242, 161),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.payment,
                                color: Color.fromARGB(255, 251, 242, 161),
                              )),
                          Container(
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                'Payment',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 251, 242, 161),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.settings,
                                color: Color.fromARGB(255, 251, 242, 161),
                              )),
                          Container(
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 251, 242, 161),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(
                            context, Routes.homePage);
                      },
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.logout,
                                color: Color.fromARGB(255, 251, 242, 161),
                              )),
                          Container(
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 251, 242, 161),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ]),
      ),
    );
  }
}
