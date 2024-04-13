import 'package:borderwander/pages/tutorial_screens/body_tutorial.dart';
import 'package:borderwander/pages/tutorial_screens/data_tutorial.dart';
import 'package:borderwander/pages/tutorial_screens/settings_tutorial.dart';
import 'package:borderwander/pages/tutorial_screens/territory_tutorial.dart';
import 'package:borderwander/pages/tutorial_screens/welcome_tutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TutorialTutorial extends StatefulWidget {
  static const routeName = 'tut';
  @override
  _TutorialTutorialState createState() => _TutorialTutorialState();
}

List<Widget> tutorial = [
  WelcomScreen(),
  TerritoryTutorial(),
  Body(),
  DataKtoreViem(),
  // ButtonMapa(),
  // ButtonObchod(),
  Nastavenia()
];

class _TutorialTutorialState extends State<TutorialTutorial> {
  int currIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tutorial[currIndex],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (currIndex + 1 == tutorial.length) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .update({'tutorial': true});

                            Navigator.of(context).pop();
                          } else {
                            currIndex++;
                          }
                        });
                      },
                      child: Text(
                        'Continue',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
