import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/Groups/AI/FirebaseChatGPTmessages.dart';
import 'package:cmc/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ClassMatesCorner',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: Routes.route,
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    void navigatonChange() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthState()));
    }

    Future.delayed(const Duration(seconds: 2), navigatonChange);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: [
          Image.asset('assets/logo.png'),
        ],
      ),
    );
  }
}

class AuthState extends StatelessWidget {
  const AuthState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Provider.of<UserProvider>(context, listen: false).initialize();
            Navigator.pushReplacementNamed(context, Routes.homePage);
          });
          return Container();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 50,
            child: const LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [
                Colors.yellow,
              ],
              strokeWidth: 0.1,
            ),
          );
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, Routes.loginPage);
          });
          return Container();
        }
      },
    );
  }
}