import 'package:borderwander/pages/goodbye.dart';
import 'package:borderwander/pages/tutorial_screens/tutorial.dart';
import './pages/all_territory.dart';
import './pages/character_page.dart';
import './pages/character_shop_page.dart';
import './pages/color_shop_page.dart';
import './pages/details_data_page.dart';
import './pages/main_page.dart';
import './providers/core.dart';
import './providers/data_fetcher.dart';
import './providers/image_controller.dart';
import './utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Hiding top bar on Android devices
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Dealing wiht data and comunication with cloud
        ChangeNotifierProvider.value(value: DataFetcher()),
        //main backend functionality
        ChangeNotifierProvider.value(value: Core()),
        //character images setup
        ChangeNotifierProvider.value(value: ImageController())
      ],
      child: MaterialApp(
        title: 'BorderWander',
        debugShowCheckedModeBanner: false,
        theme: MyTheme.getTheme(context),
        home: MainPage(),
        routes: {
          ColorShop.routeName: (context) => ColorShop(),
          CharacterShop.routeName: (context) => CharacterShop(),
          CharacterPage.routeName: (context) => CharacterPage(),
          DetailData.routeName: (context) => DetailData(),
          AllTerritory.routeName: (context) => AllTerritory(),
          GoodbyePage.routeName: (context) => GoodbyePage(),
          TutorialTutorial.routeName: (context) => TutorialTutorial()
        },
      ),
    );
  }
}
