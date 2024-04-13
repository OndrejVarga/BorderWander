import 'package:borderwander/pages/all_territory.dart';

import '../providers/data_fetcher.dart';
import '../widgets/character_page_widgets/detail_part.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailData extends StatelessWidget {
  static String routeName = 'details';
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
      body: FutureBuilder(
        future: Provider.of<DataFetcher>(context, listen: false)
            .fetchAllTerritoriesData(context),
        builder: (ctx, snaphshot) {
          if (snaphshot.hasData)
            return SingleChildScrollView(
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
                    DetailPart(
                        'Area of the occupied territory',
                        Provider.of<DataFetcher>(context, listen: false)
                                .currUserInformation['currAreaOfTerritory']
                                .toInt()
                                .toString() +
                            ' m²'),
                    DetailPart(
                        'Traveled distance',
                        Provider.of<DataFetcher>(context, listen: false)
                                .currUserInformation['length']
                                .toInt()
                                .toString() +
                            ' m'),
                    DetailPart(
                        'Amount of points',
                        Provider.of<DataFetcher>(context, listen: false)
                            .currUserInformation['points']
                            .toInt()
                            .toString()),
                    DetailPart(
                        'Burned calories',
                        Provider.of<DataFetcher>(context, listen: false)
                                .currUserInformation['calories']
                                .toInt()
                                .toString() +
                            ' kcal'),
                    DetailPart(
                        'Walking without a break (in days)',
                        Provider.of<DataFetcher>(context, listen: false)
                            .streak
                            .toString()),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AllTerritory.routeName);
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'All territories',
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
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
