import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/providers/image_controller.dart';
import 'package:borderwander/widgets/character_page_widgets/character_table_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableItem extends StatelessWidget {
  final int index;
  final String username;
  final String currArea;
  final String userUid;
  final List<String> character;
  final bool ok;
  TableItem(this.index, this.currArea, this.username, this.userUid,
      {this.ok = false, this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<DataFetcher>(context, listen: false)
                  .currUserInformation['UID'] ==
              userUid
          ? Theme.of(context).accentColor
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //Standings with others(Position)-----------------------------------
            width: MediaQuery.of(context).size.width * 1.2 / 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(!ok ? '#${index.toString()}' : '  ',
                  style: !ok
                      ? Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: 20)
                      : Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 20)),
            ),
          ),

          //Character miniature-------------------------------------------------
          if (character != null)
            PreviewCharacterTable(
                Provider.of<ImageController>(context, listen: false)
                    .fromNamesToTable(character)),

          //username------------------------------------------------------------
          Container(
            width: MediaQuery.of(context).size.width * 1.5 / 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(username,
                  style: !ok
                      ? Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: 20)
                      : Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 20)),
            ),
          ),
          //Current area
          Container(
            width: MediaQuery.of(context).size.width * 1.5 / 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(currArea.toString(),
                  style: !ok
                      ? Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: 20)
                      : Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
