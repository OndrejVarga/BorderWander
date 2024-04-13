import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/widgets/auth_widgets/top.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Nastavenia extends StatelessWidget {
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
                        Flexible(
                          child: Text(
                            "Final tips!",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 30),
                          ),
                        ),
                        Image.asset(
                          'assets/images/Logo1.png',
                          height: 45,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Text(
                        'If you manage to occupy a new territory regularly every day for at least 30 days, you will receive a crown in front of your name.',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: 25),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Text(
                        'To leave the application, use the option in the settings',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: 25),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Text(
                        'The maximum allowed average speed is ${Provider.of<DataFetcher>(context, listen: false).settings['maxSpeed']} km/h.',
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
