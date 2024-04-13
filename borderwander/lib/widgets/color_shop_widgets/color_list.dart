import '../color_shop_widgets/buy_color.dart';
import '../color_shop_widgets/user_color_list.dart';
import 'package:flutter/material.dart';

class ColorList extends StatefulWidget {
  final Function changeIndex;
  ColorList(this.changeIndex);
  @override
  _ColorListState createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> bodys = [UserColorList(), BuyColor()];
    return Expanded(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Navigation------------------------------------------------
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.changeIndex(0);
                          index = 0;
                        });
                      },
                      //Display of lready bought colors-------------------------
                      child: Text(
                        'Owned',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: index == 0 ? 25 : 20,
                            color: index == 0
                                ? Theme.of(context).accentColor
                                : Colors.white),
                      ),
                    ),
                    //Trying to buy a new color---------------------------------
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.changeIndex(1);
                          index = 1;
                        });
                      },
                      child: Text(
                        'Buy colors',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: index == 0 ? 20 : 25,
                            color: index == 0
                                ? Colors.white
                                : Theme.of(context).accentColor),
                      ),
                    )
                  ],
                ),
              ),
              bodys[index]
            ],
          ),
        ),
      ),
    );
  }
}
