import 'package:flutter/material.dart';
import 'components/my-drawer.dart';
import './utils/strings.dart';
import 'app_state_container.dart';
import 'dart:async';


class SyncPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return _SyncPageState();
  }
}

class _SyncPageState extends State<SyncPage> {
  double _progress = -1;
  bool done = false;

  void startTimer() {
    new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (_progress == 1) {
            // timer.cancel();
            _progress = 0;
          } else {
            _progress += 0.1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final user = inheritedWidget.getUser();
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['sync'];

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(displayName),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _progress >=0 ?
              Text('Syncing in progress. Please wait') : Text('Click the "Sync" button to sync'),
              SizedBox(height: 50),
              _progress >=0 ?
              LinearProgressIndicator(
                value: _progress,
              ) : SizedBox(),
              SizedBox(height: 50),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                color: Colors.greenAccent[700],
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text('Sync', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  onPressed: () {
                    setState(() {
                      _progress = 0;
                    });
                    startTimer();
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}