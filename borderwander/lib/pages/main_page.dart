import 'dart:async';

import 'package:borderwander/providers/core.dart';
import 'package:borderwander/utils/error_alert.dart';

import '../pages/auth_page.dart';
import '../pages/map_page.dart';
import '../providers/data_fetcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _start = 5;
  Timer _timer;

  void startTimer() {
    FirebaseAuth auth = FirebaseAuth.instance;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            print('ok');
            timer.cancel();
            auth.signOut();
            ErrorAlert.showError(context,
                "An error has occurred. If this error persist create a new account");
          });
        } else {
          setState(() {
            print(_start);
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder(
        future: Provider.of<DataFetcher>(context, listen: false)
            .fetchInitData(context),
        builder: (ctx, data) {
          if (_timer != null) _timer.cancel();
          if (data.hasData) {
            return MapPage();
          } else {
            startTimer();
            return Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: Center(child: CircularProgressIndicator()));
          }
        },
      );
    }
    return AuthPage();
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (ctx, userShapshot) {
  //         if (userShapshot.hasData) {
  //           print(userShapshot.data);
  //           return FutureBuilder(
  //             future: Provider.of<DataFetcher>(context, listen: false)
  //                 .fetchInitData(context),
  //             builder: (ctx, data) {
  //               if (_timer != null) _timer.cancel();
  //               if (data.hasData) {
  //                 return MapPage();
  //               } else {
  //                 startTimer();
  //                 return Scaffold(
  //                     backgroundColor: Theme.of(context).backgroundColor,
  //                     body: Center(child: CircularProgressIndicator()));
  //               }
  //             },
  //           );
  //         } else {
  //           return AuthPage();
  //         }
  //       },
  //     ),
  //   );
  // }
}
