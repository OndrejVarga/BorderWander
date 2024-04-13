import 'package:flutter/material.dart';

class Body extends StatelessWidget {
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
                'Points ',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 30),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  'For every territory you own, you earn points which you use to can buy new colors of your territories. The number of points obtained for the territory is equal to the the area of the occupied territory.',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.start),
              Container(
                  //logo školy
                  margin: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/shop.gif',
                  )),
              Text("Your points are compared to other users' points.",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.start),
              Container(
                  //logo školy
                  margin: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/table.PNG',
                    fit: BoxFit.cover,
                  )),
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
