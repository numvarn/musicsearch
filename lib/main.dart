import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicsearch/screens/login_screen.dart';
import 'package:musicsearch/utilities/authenFileProcess.dart';
import 'package:musicsearch/screens/operations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: SplashPage(), //LoginScreen(),
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthenFileProcess authenticationFile = new AuthenFileProcess();

  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // Prevent Screen Rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 180.0,
              child: Image.asset(
                "assets/logos/music.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 35.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, _checkAuthentication);
  }

  void _checkAuthentication() {
    authenticationFile.readToken().then((val) {
      if (val == "fail" || val == "{}") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OperationPage()),
        );
      }
    });
  }
}
