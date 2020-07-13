import 'package:collector/middleware/Api.dart';
import 'package:collector/models/app_settings.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'middleware/AppDb.dart';
import 'utils/strings.dart';
import 'app_state_container.dart';
import 'models/user.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var oldSession = false;

  void _showDialog(title, body, buttonText) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title, style: TextStyle(color: Colors.red)),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.red,
              child: new Text(buttonText, style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    AppDb.getAppSetting().then((oldAppSetting) => setState(() {
      AppDb.filterUsers().then((users) => setState(() {
        final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        final twentyFourHours = 24*60*60;

        if (users.length > 0 && oldAppSetting.lastLogInDate != null &&
            (currentTime - oldAppSetting.lastLogInDate) < (twentyFourHours)) {
          this.oldSession = true;
        }
      }));
    }));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final avatar = Text(
      'N4G',
      style: TextStyle(color: Colors.green, fontSize: 70.0),
      textAlign: TextAlign.center,
    );
    final appName = Text(
      'Field Officer App',
      style: TextStyle(color: Colors.brown, fontSize: 20.0),
      textAlign: TextAlign.center,
    );

    final email = TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone number',
        labelText: 'Phone number',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        labelText: 'Password',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.greenAccent[700],
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () async {

            var  phone = phoneController.text;
            var password = passwordController.text;
            inheritedWidget.setLanguage('eng');
            if (phone.length < 10 || password.length < 6) {
              print("You also do not exist");
              _showDialog('Failed', 'Incorrect login details.', 'Close');
              return;
            } else {
              if (this.oldSession == true) {
                final userFromDb = await AppDb.findUser(phone, password);
                if (userFromDb == null) {
                  _showDialog('Failed', 'Incorrect login details.', 'Close');
                  return;
                }
                inheritedWidget.saveUser(new User(
                    userFromDb.userId,
                    userFromDb.firstName,
                    userFromDb.otherNames,
                    userFromDb.phone,
                    userFromDb.status,
                    userFromDb.gender,
                    userFromDb.password,
                    userFromDb.createdAt,
                    userFromDb.updatedAt));

                Navigator.of(context).pushReplacementNamed(DashboardPage.tag);
                return;
              }
            }

            phone = phoneController.text.substring(0, 0) + "+233" + phoneController.text.substring(1);
            final userLoginResponse = await Api().login(phoneController.text.toString(), password);
            if (userLoginResponse.statusCode != 201) {
              print('You do not exist');
              _showDialog('Failed', 'Failed to login, check your details and try again', 'Close');
            } else {
              print(userLoginResponse.body);
              // labels[lang]['current_user'] = user.toMap()
              final userBody = userLoginResponse.body;
              final userFromApi = User.fromJson(json.decode(userBody));

              inheritedWidget.saveUser(new User(
                  userFromApi.userId,
                  userFromApi.firstName,
                  userFromApi.otherNames,
                  userFromApi.phone,
                  userFromApi.status,
                  userFromApi.gender,
                  userFromApi.password,
                  userFromApi.createdAt,
                  userFromApi.updatedAt));

              // print('${inheritedWidget.getUser().firstName} is about to login');
              // print(inheritedWidget.getUser());

              final AppSetting appSetting = await AppDb.getAppSetting();
              print("======================");
              print(appSetting.languageCode);
              appSetting.lastLogInDate = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
              if (appSetting.languageCode == null) {
                appSetting.languageCode = 'eng';
              }
              print(appSetting.toMap());
              await AppDb.updateAppSetting(appSetting.toMap());

              Navigator.of(context).pushReplacementNamed(DashboardPage.tag);
            }
          },
          child: Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            Form(
              key: this._formKey,
              child:
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  avatar,
                  appName,
                  SizedBox(height: 24.0),
                  email,
                  SizedBox(height: 20.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton,
                  // forgotLabel
                ],
              ),
            )

      ),
    );
  }
}
