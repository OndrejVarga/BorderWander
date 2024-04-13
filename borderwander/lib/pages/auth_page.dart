import 'package:borderwander/pages/map_page.dart';
import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/utils/error_alert.dart';

import '../providers/image_controller.dart';
import '../widgets/auth_widgets/auth_form.dart';
import '../widgets/auth_widgets/top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  //To show loading animation on button in widget
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Create or login user
  void _submitAuthForm(
    String email,
    String password,
    String antherPassword,
    String username,
    Color color,
    bool isLogIn,
    BuildContext context,
    int weight,
  ) async {
    UserCredential authResult;

    setState(() {
      _isLoading = true;
    });
    await Provider.of<ImageController>(context, listen: false).init(context);
    try {
      //Login in
      if (isLogIn) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      //Register
      else {
        //Loading images to save a new character
        //Creating User profile in cloud
        print('registering');
        print(email +
            password +
            username +
            color.value.toString() +
            weight.toString());
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (weight == null) {
          weight = 80;
        }
        print('registering');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'color': color.value,
          'currAreaOfTerritory': 0,
          'length': 0,
          'tutorial': false,
          'ownedColors': [color.value],
          'points': 0,
          'totalSteps': 0,
          'weight': weight,
          'calories': 0,
          'whiteMap': false,
          'character': [
            ...Provider.of<ImageController>(context, listen: false).toDatabase
          ]
        });
        print('registering');
      }
    } catch (err) {
      print('-----------------------------------------------------------');
      print(err);
      print('-----------------------------------------------------------');
      if (mounted) {
        var message = 'An error occurred, check your details';
        if (err.message != null) {
          message = err.message;
        }
        print(message);
        ErrorAlert.showError(_scaffoldKey.currentContext, message);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(FirebaseAuth.instance.currentUser);
    print(FirebaseAuth.instance.currentUser != null);
    if (FirebaseAuth.instance.currentUser != null) {
      await Provider.of<DataFetcher>(context, listen: false)
          .fetchInitData(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => MapPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [AuthTop(), AuthForm(_submitAuthForm, _isLoading, _auth)],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
