import 'package:flutter/material.dart';

class DataKtoreViem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Statistics',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30),
                  textAlign: TextAlign.start),
              const SizedBox(height: 20, width: 20),
              Text('You can also view data on your progress while playing.',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.start),
              Container(
                  //logo školy
                  margin: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/data.PNG',
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
