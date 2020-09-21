import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as Http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicsearch/utilities/authenFileProcess.dart';
import 'package:musicsearch/screens/operations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'Register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  // TextField Controller
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle styleButton = GoogleFonts.prompt(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('หยุดการทำงานโปรแกรม'),
            content: new Text('คุณต้องการหยุดการทำงานโปรแกรม ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('ไม่ใช่'),
              ),
              new FlatButton(
                onPressed: () => exit(0), //Navigator.of(context).pop(true),
                child: new Text('ใช่'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.redAccent,
          ),
          hintText: "ชื่อผู้ใช้ระบบ/อีเมล",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.yellowAccent,
          ),
          hintText: "รหัสผ่าน",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = RoundedLoadingButton(
      child: Text(
        "เข้าสู่ระบบ",
        textAlign: TextAlign.center,
        style: styleButton,
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
      onPressed: () {
        _signIn();
      },
    );

    final registerButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightBlue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          );
        },
        child: Text("ลงทะเบียนผู้ใช้งานใหม่",
            textAlign: TextAlign.center, style: styleButton),
      ),
    );

    Widget _buildSocialBtn(Function onTap, AssetImage logo) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 10.0,
              ),
            ],
            image: DecorationImage(
              image: logo,
            ),
          ),
        ),
      );
    }

    Widget _buildSocialBtnRow() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildSocialBtn(
              () => print('Login with Facebook'),
              AssetImage(
                'assets/logos/facebook.jpg',
              ),
            ),
            _buildSocialBtn(
              () => print('Login with Google'),
              AssetImage(
                'assets/logos/google.jpg',
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(31.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 180.0,
                  child: Image.asset(
                    "assets/logos/music.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 35.0),
                loginButton,
                SizedBox(height: 15.0),
                registerButton,
                SizedBox(height: 15.0),
                _buildSocialBtnRow(),
                SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    var url = "https://lyric-sskru.herokuapp.com/api/login";

    Map<String, String> data = {
      "username": emailController.text.trim(),
      "password": passwordController.text.trim()
    };

    if (emailController.text.trim() != "" &&
        passwordController.text.trim() != "") {
      var response = await Http.post(url, body: data);
      final responseJson = json.decode(response.body);

      if (responseJson['token'] != null) {
        String data = '{"token": "${responseJson['token']}"}';

        AuthenFileProcess authenFileProcess = new AuthenFileProcess();
        authenFileProcess.writeToken(data);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OperationPage()));
      } else {
        _showAlertLoginFail(context);
        _btnController.stop();
      }
    } else {
      _showAlertLoginFail(context);
      _btnController.stop();
    }
  }

  void _showAlertLoginFail(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Invalid Username/Password"),
              content: Text("Please, check your username or password"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ));
  }
}
