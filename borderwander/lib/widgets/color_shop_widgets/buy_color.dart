import 'package:borderwander/providers/core.dart';
import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BuyColor extends StatefulWidget {
  @override
  _BuyColorState createState() => _BuyColorState();
}

class _BuyColorState extends State<BuyColor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Data about ability of buying a new color----------------------
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Amount of points',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 25),
                  ),
                ),
                Text(
                  Provider.of<DataFetcher>(context)
                      .currUserInformation['points']
                      .toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 25),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    'Price of one color',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 25),
                  ),
                ),
                Text(
                  '100 000',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 25),
                ),

                //Widget through is buying a new color executed-------------------
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: Text(
                                'Vyber si farbu',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(fontSize: 20),
                              ),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  enableAlpha: false,
                                  pickerColor:
                                      Provider.of<Core>(context).selectedColor,
                                  onColorChanged: (c) {
                                    Provider.of<Core>(context, listen: false)
                                        .changeSelectedColor(c);
                                  },
                                  showLabel: false,
                                  displayThumbColor: false,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Provider.of<Core>(context).selectedColor),
                  ),
                ),
                //Buying button--------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Theme.of(context).cardColor,
                      primary: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      if (Provider.of<DataFetcher>(context, listen: false)
                              .currUserInformation['points'] >=
                          100000) {
                        Provider.of<DataFetcher>(context, listen: false)
                            .buyColor(Provider.of<Core>(context, listen: false)
                                .selectedColor);
                      } else {
                        ErrorAlert.showError(
                            context, "You don't have enough points!");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 35),
                      child: Text('Buy',
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20,
                              color: Theme.of(context).backgroundColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
