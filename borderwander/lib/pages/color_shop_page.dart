import '../providers/core.dart';
import '../providers/data_fetcher.dart';
import '../widgets/color_shop_widgets/color_list.dart';
import '../widgets/color_shop_widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorShop extends StatefulWidget {
  static String routeName = 'colorShop';
  @override
  _ColorShopState createState() => _ColorShopState();
}

class _ColorShopState extends State<ColorShop> {
  int index = 0;
  void changeIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  icon: const Icon(Icons
                      .arrow_back_ios_rounded), // Put icon of your preference.
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
          future:
              Provider.of<DataFetcher>(context, listen: false).fetchShopData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    MapPreview(index == 0
                        ? Color(Provider.of<DataFetcher>(context)
                            .currUserInformation['color'])
                        : Provider.of<Core>(context).selectedColor),
                    ColorList(changeIndex)
                  ],
                ),
              );
            }
          }),
    );
  }
}
