import 'package:borderwander/providers/data_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorAlert {
  static void showError(BuildContext context, String text,
      {String title = ''}) {
    if (context != null)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            title == '' ? 'Warning' : title,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
          ),
          content: Text(text,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
  }

  static void showBugReport(BuildContext context) {
    final myController = TextEditingController();
    String bug = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Please describe the bug in as much detail as possible',
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 20),
        ),
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).cardColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
              controller: myController,
              onChanged: (buged) {
                bug = buged;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 15),
                labelText: 'Bug',
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Send',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 20)),
            onPressed: () {
              if (bug != '' && bug.length > 0) {
                Provider.of<DataFetcher>(context, listen: false).sendBug(bug);
                // Provider.of<DataFetcher>(context, listen: false).addPoints();
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    ).then((value) {
      if (bug != '' && bug.length > 0) {
        showError(context, 'You get 500 points', title: 'Thank you');
        Provider.of<DataFetcher>(context, listen: false).addPoints();
      }
    });
  }
}
