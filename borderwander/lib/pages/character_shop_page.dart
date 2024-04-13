import '../providers/data_fetcher.dart';
import '../providers/image_controller.dart';
import '../widgets/character_shop_widgets/preview_character.dart';
import '../widgets/character_shop_widgets/character_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterShop extends StatefulWidget {
  static String routeName = 'CharacterShop';

  @override
  _CharacterShopState createState() => _CharacterShopState();
}

class _CharacterShopState extends State<CharacterShop> {
  Future<void> fetchingData() async {
    await Provider.of<ImageController>(context, listen: false).init(context);

    List<String> imagesToDatabase = [];

    Provider.of<DataFetcher>(context, listen: false)
        .currUserInformation['characterImageNames']
        .forEach((element) {
      imagesToDatabase.add(element.toString());
    });

    Provider.of<ImageController>(context, listen: false)
        .fromNames(imagesToDatabase);

    return true;
  }

  @override
  Widget build(BuildContext context) {
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
        builder: (ctx, future) {
          return !future.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Preview-----------------------------------------------
                        PreviewCharacter(),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: CharacterChangeWidget()),
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
                            onPressed: () async {
                              await Provider.of<DataFetcher>(context,
                                      listen: false)
                                  .updateCharacter(context);
                            },
                            //Updating character--------------------------------
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 35),
                              child: Text(
                                'Save',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: 20,
                                        color:
                                            Theme.of(context).backgroundColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
