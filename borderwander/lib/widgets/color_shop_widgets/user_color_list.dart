import 'package:borderwander/providers/data_fetcher.dart';
import '../color_shop_widgets/color_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserColorList extends StatelessWidget {
  //Display already bought colors
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: Provider.of<DataFetcher>(context)
            .currUserInformation['ownedColors']
            .length,
        itemBuilder: (ctx, index) {
          return ColorListTile(
              Color(Provider.of<DataFetcher>(context)
                  .currUserInformation['ownedColors'][index]),
              (Provider.of<DataFetcher>(context)
                      .currUserInformation['ownedColors'][index] ==
                  Provider.of<DataFetcher>(context)
                      .currUserInformation['color']));
        },
      ),
    );
  }
}
