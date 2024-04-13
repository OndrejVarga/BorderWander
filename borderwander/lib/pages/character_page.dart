import 'package:borderwander/pages/character_shop_page.dart';

import '../providers/data_fetcher.dart';
import '../providers/image_controller.dart';
import '../widgets/character_page_widgets/basic_data.dart';
import '../widgets/character_page_widgets/characters_table.dart';
import '../widgets/character_shop_widgets/preview_character.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatefulWidget {
  static String routeName = 'characterPage';
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  Future<void> fetchingData() async {
    await Provider.of<ImageController>(context, listen: false).init(context);
    List<String> imagesFromDatabase = [];

    Provider.of<DataFetcher>(context, listen: false)
        .currUserInformation['characterImageNames']
        .forEach((element) {
      imagesFromDatabase.add(element.toString());
    });

    Provider.of<ImageController>(context, listen: false)
        .fromNames(imagesFromDatabase);
    await Provider.of<DataFetcher>(context, listen: false).fetchShopData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
      body: FutureBuilder(
        future: fetchingData(),
        builder: (ctx, fut) {
          if (fut.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Center(
                      //Character-----------------------------------------------
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CharacterShop.routeName);
                          },
                          child: PreviewCharacter()),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),

                      //Name---------------------------------------------------
                      child: Text(
                        Provider.of<DataFetcher>(context)
                            .currUserInformation['username'],
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontSize: 20),
                      ),
                    ),

                    //Data and Others-------------------------------------------
                    BasicData(),
                    CharactersTable()
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
