import 'package:borderwander/pages/details_data_page.dart';
import 'package:borderwander/providers/data_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Rank',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 18),
                  ),
                ),
                Text(
                  '#${Provider.of<DataFetcher>(context).currUserInformation['index'] + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, DetailData.routeName);
            },
            child: Row(
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 20),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
