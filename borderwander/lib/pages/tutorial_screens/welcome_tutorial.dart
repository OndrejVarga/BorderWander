import 'package:borderwander/widgets/auth_widgets/top.dart';
import 'package:flutter/material.dart';

class WelcomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AuthTop(),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Welcome",
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 35),
                        ),
                        Image.asset(
                          'assets/images/Logo1.png',
                          height: 45,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Text(
                        "The goal of the application is to motivate people to move in a playful and competitive way. Your task is to occupy the territory around you.",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: 25),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
