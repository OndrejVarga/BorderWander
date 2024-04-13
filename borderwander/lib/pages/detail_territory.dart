import 'package:borderwander/pages/map_territory_page.dart';

import '../widgets/character_page_widgets/detail_part.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsTerritory extends StatelessWidget {
  static String routeName = 'detailsTerritory';
  final Map<String, dynamic> data;
  DetailsTerritory(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title-----------------------------------------------------------
              Container(
                child: Text(
                  'Data',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30),
                ),
              ),
              //Content---------------------------------------------------------
              DetailPart('Area of the occupied territory',
                  data['routeArea'].toInt().toString() + ' m²'),
              DetailPart('Traveled distance',
                  data['routeLength'].toInt().toString() + ' m'),
              DetailPart('Average speed',
                  data['avgSpeed'].toInt().toString() + ' km/h'),
              DetailPart(
                'Start of walk',
                DateFormat.jm()
                    .format(DateTime.parse(data['startTime'].toString())),
              ),
              DetailPart(
                  'End of walk',
                  DateFormat.jm()
                      .format(DateTime.parse(data['endTime'].toString()))),
              DetailPart('Duration', data['duration']),
              DetailPart('Burned calories',
                  data['calories'].toInt().toString() + ' kcal'),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => MapTerritory(
                          data['points'].toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show on the map',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 20),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
