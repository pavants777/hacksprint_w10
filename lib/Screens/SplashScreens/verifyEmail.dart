import 'dart:async';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print(isEmailVerified);
    if (!isEmailVerified) {
      sendVerificationEmail();
    } else {
      Provider.of<UserProvider>(context, listen: false).emailVerfication();
      Navigator.pushReplacementNamed(context, Routes.homePage);
    }

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer!.cancel();
      Provider.of<UserProvider>(context, listen: false).emailVerfication();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Error in Sending Email'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Verify Your Email',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Email Verification Is Sent To Your Email',
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Check Your InBox',
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                sendVerificationEmail();
              },
              child: const Text(
                'Resend It',
                style: TextStyle(color: Colors.blue),
              )),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      )),
    );
  }
}
