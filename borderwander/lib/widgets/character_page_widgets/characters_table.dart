import 'package:borderwander/providers/data_fetcher.dart';
import 'package:borderwander/widgets/character_page_widgets/table_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersTable extends StatefulWidget {
  @override
  _CharactersTableState createState() => _CharactersTableState();
}

class _CharactersTableState extends State<CharactersTable> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount:
          Provider.of<DataFetcher>(context, listen: false).tableData.length + 1,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return TableItem(
            0,
            'm²',
            'NAME',
            '',
            ok: true,
          );
        } else {
          return TableItem(
              index,
              Provider.of<DataFetcher>(context, listen: false)
                  .tableData[index - 1]['currAreaOfTerritory'],
              Provider.of<DataFetcher>(context, listen: false)
                  .tableData[index - 1]['username'],
              Provider.of<DataFetcher>(context, listen: false)
                  .tableData[index - 1]['UID'],
              ok: false,
              character: [
                ...Provider.of<DataFetcher>(context, listen: false)
                    .tableData[index - 1]['character']
                    .map((el) => el.toString())
              ]);
        }
      },
    );
  }
}
