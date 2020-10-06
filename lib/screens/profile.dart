import 'dart:convert';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:http/http.dart' as Http;
import 'package:musicsearch/screens/home.dart';
=======
>>>>>>> 2050603aa8150891f1d96878e9e42ea639f09fac
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
<<<<<<< HEAD

  void submitProfile() {
    pr = new ProgressDialog(context);
    pr.style(
      message: '  Sending Data...',
      progressWidget: CircularProgressIndicator(),
    );

    Map<String, String> data = {
      'account': profile.uid.toString(),
      'gender': profile.gender,
      'age': profile.age.toString(),
      'nationality': profile.nationality,
      'occupation': profile.occupation,
      'office_address': profile.officeAddress,
      'office_subdistrict': profile.officeSubDistrict,
      'office_district': profile.officeDistrict,
      'office_province': profile.officeProvince,
      'office_phone': profile.officePhone,
      'home_address': profile.homeAddress,
      'home_subdistrict': profile.homeSubDistrict,
      'home_district': profile.homeDistrict,
      'home_province': profile.homeProvince,
      'mobile_phone': profile.mobilePhone,
    };

    final test = json.encode(data);
    print(test);

    //Sending Location to API
    pr.show();

    Http.post(
      "https://ssk-covid19.herokuapp.com/post/profile",
      body: data,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    ).then((response) {
      final body = utf8.decode(response.bodyBytes);
      final resJson = json.decode(body);
      print(resJson);
      pr.hide();

      if (resJson['status'] == 'success') {
        _showAlertUpdateSuccessed(context);
      } else {
        _showAlertUpdateFail(context);
      }
    });
  }

  void _showAlertUpdateSuccessed(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("แก้ไขข้อมูลแล้ว"),
              content: Text(
                  "ประวัติสามาชิกของท่านได้ถูกปรับปรุงให้เป็นปัจจุบันแล้ว"),
              actions: <Widget>[
                FlatButton(
                  child: Text('รับทราบ'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpeechScreen()),
                    );
                  },
                )
              ],
            ));
  }

  void _showAlertUpdateFail(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("เกิดความผิดพลาด"),
              content: Text("ข้อมูลของคุณถูกยังไม่ถูกบันทึกเข้าระบบ !!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('ลองอีกครั้ง'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}

class Profile {
  final int uid;
  String gender;
  int age;
  String nationality;
  String occupation;
  String officeAddress;
  String officeSubDistrict;
  String officeDistrict;
  String officeProvince;
  String officePhone;
  String homeAddress;
  String homeSubDistrict;
  String homeDistrict;
  String homeProvince;
  String mobilePhone;

  Profile(
      this.uid,
      this.gender,
      this.age,
      this.nationality,
      this.occupation,
      this.officeAddress,
      this.officeSubDistrict,
      this.officeDistrict,
      this.officeProvince,
      this.officePhone,
      this.homeAddress,
      this.homeSubDistrict,
      this.homeDistrict,
      this.homeProvince,
      this.mobilePhone);
=======
>>>>>>> 2050603aa8150891f1d96878e9e42ea639f09fac
}
