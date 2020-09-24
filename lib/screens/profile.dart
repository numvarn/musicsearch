import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:musicsearch/utilities/authenFileProcess.dart';
import 'package:musicsearch/utilities/profileFileProcess.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Style
  TextStyle style = GoogleFonts.prompt(
    fontSize: 20,
  );

  TextStyle styleButton = GoogleFonts.prompt(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  //Read config file
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  //Progress Dialog
  ProgressDialog pr;

  String token;
  String profileDisplayName;
  String emailDisplay;
  int currentUID;
  bool loadCheck = false;
  String genderValue = "ชาย";

  initState() {
    super.initState();
  }

  Future<String> _getProfile() async {
    //Get user authentication token form auth file
    if (token == null) {
      profileFileProcess.readProfile().then((profileFile) {
        final profileJson = json.decode(profileFile);
        print(profileJson);
        setState(() {
          profileDisplayName = profileJson['results'][0]['first_name'] +
              " " +
              profileJson['results'][0]['last_name'];
          currentUID = profileJson['results'][0]['id'];
          emailDisplay = profileJson['results'][0]['email'];
        });
      });

      authenFileProcess.readToken().then((val) {
        final jsonToken = json.decode(val);
        setState(() {
          token = jsonToken['token'];
        });
      });
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติของฉัน', style: style),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: new FutureBuilder(
          future: _getProfile(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(profileDisplayName,
                          style: GoogleFonts.prompt(
                              color: hexToColor("#3371ff"), fontSize: 30.0)),
                      SizedBox(height: 25.0),
                      Text(emailDisplay,
                          style: GoogleFonts.prompt(
                              color: hexToColor("#3371ff"), fontSize: 18.0)),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
