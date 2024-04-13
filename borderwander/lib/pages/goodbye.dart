import 'dart:io';

import 'package:borderwander/widgets/auth_widgets/top.dart';
import 'package:flutter/material.dart';

class GoodbyePage extends StatefulWidget {
  static String routeName = 'goodbye';

  @override
  _GoodbyePageState createState() => _GoodbyePageState();
}

class _GoodbyePageState extends State<GoodbyePage> {
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((dur) {
      Future.delayed(Duration(milliseconds: 700)).then((value) => exit(0));
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AuthTop(),
              Center(
                  child: Text('See you later!',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: 35)))
            ],
          ),
        ),
      ),
    );
  }
}
