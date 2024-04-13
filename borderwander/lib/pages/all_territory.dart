import 'package:borderwander/pages/detail_territory.dart';
import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/widgets/character_page_widgets/table_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTerritory extends StatefulWidget {
  static String routeName = 'allTerritory';
  @override
  _AllTerritoryState createState() => _AllTerritoryState();
}

class _AllTerritoryState extends State<AllTerritory> {
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
            child: Provider.of<DataFetcher>(context, listen: false)
                        .allUserTerritories
                        .length <=
                    0
                ? Center(
                    child: Text(
                      "You don't have territories",
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontSize: 20),
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount:
                            Provider.of<DataFetcher>(context, listen: false)
                                .allUserTerritories
                                .length,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsTerritory(
                                        Provider.of<DataFetcher>(context,
                                                listen: false)
                                            .allUserTerritories[index])),
                              );
                            },
                            child: Row(
                              children: [
                                TableItem(
                                  index,
                                  '',
                                  DateFormat.MMMd().format(DateTime.parse(
                                      Provider.of<DataFetcher>(context,
                                                  listen: false)
                                              .allUserTerritories[index]
                                          ['startTime'])),
                                  '',
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ));
  }
}
