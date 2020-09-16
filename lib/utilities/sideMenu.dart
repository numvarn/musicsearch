import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicsearch/screens/login_screen.dart';
import 'package:musicsearch/screens/profile.dart';
import 'package:musicsearch/utilities/profileFileProcess.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'authenFileProcess.dart';
import 'operations.dart';



class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthenFileProcess authenFileProcess = new AuthenFileProcess();
  ProfileFileProcess profileFileProcess = new ProfileFileProcess();

  String accountName;
  String email;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$accountName'),
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 40.0,),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ศรีสะเกษสู้โควิด 19'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OperationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('เกี่ยวกับเรา'),
            onTap: () {},
          ),
          
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('ประวัติส่วนตัว'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ออกจากระบบ'),
            onTap: () {
              _logoutProcess(context);
            },
          ),
        ],
      ),
    );
  }

  void _getProfile() async {
    var profile = profileFileProcess.readProfile();
    profile.then((value) {
      var profileJson = json.decode(value);
      setState(() {
        accountName = profileJson['results'][0]['first_name']+" "+profileJson['results'][0]['last_name'];
        email = profileJson['results'][0]['email'];
      });
    });
  }

  void _logoutProcess(context) async {
    // Progress Dialog
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
      message: '  Loging out...',
      progressWidget: CircularProgressIndicator(),
    );

    pr.show();

    authenFileProcess.writeToken("{}");
    profileFileProcess.writeProfile("{}");

    pr.hide();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}