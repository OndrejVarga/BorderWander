import 'package:flutter/material.dart';

class TerritoryTutorial extends StatelessWidget {
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
              Text(
                'Occupying a territory',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 35),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'To start your route, press the play icon button.\n' +
                    'Press again to end the route. \n' +
                    'It is important that the device has internet access at the time the route is finished',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.start,
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Image.asset('assets/images/startStop.gif')),
              Text(
                'The lines must intersect to assign a territory.\n' +
                    'You can also steal territories from other players, for which you get more points. To find out who owns a territory, just click on it.',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.start,
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Image.asset('assets/images/territory.gif')),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
