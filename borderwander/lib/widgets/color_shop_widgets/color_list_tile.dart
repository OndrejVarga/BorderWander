import 'package:borderwander/providers/data_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorListTile extends StatelessWidget {
  final Color colorC;
  final bool current;
  ColorListTile(this.colorC, this.current);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<DataFetcher>(context, listen: false)
            .changeUserColor(colorC.value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: colorC),
            ),
            if (current)
              const Icon(
                Icons.check,
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}
