import 'dart:async';
import 'package:borderwander/pages/tutorial_screens/tutorial.dart';

import '../pages/character_page.dart';
import '../pages/character_shop_page.dart';
import '../pages/color_shop_page.dart';
import '../providers/core.dart';
import '../providers/data_fetcher.dart';
import 'package:borderwander/widgets/map_widgets/map_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carp_background_location/carp_background_location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  bool _init = false;
  //drawer
  bool _showMenu = false;
  //average speed
  int _speed = 0;

  //Points of new territory of user
  List<LatLng> _points = [];
  //Location of User
  List<LatLng> _userLocation = [];
  MapController _controller = MapController();

  LocationManager locationManager = LocationManager.instance;
  Stream<LocationDto> dtoStream;
  StreamSubscription<LocationDto> dtoSubscription;
  LocationDto lastLocation;

//Every second look for changes in location
  void onData(LocationDto dto) {
    if (_speed != dto.speed.toInt()) {
      setState(() {
        print('SPEED' + _speed.toString());
        Provider.of<Core>(context, listen: false)
            .changeSpeed((dto.speed * 3.6).toInt());
        _speed = (dto.speed * 3.6).toInt();
      });
    }

    if (lastLocation != null) {
      if (lastLocation.latitude != dto.latitude ||
          lastLocation.longitude != dto.longitude) {
        if (Provider.of<Core>(context, listen: false).automatickeSledovanie) {
          print('moving');
          _controller.move(LatLng(dto.latitude, dto.longitude), 18);
        }

        _userLocation.clear();
        _userLocation.add(LatLng(dto.latitude, dto.longitude));

        if (!_points.contains(LatLng(dto.latitude, dto.longitude))) {
          _points.add(LatLng(dto.latitude, dto.longitude));
        }
        setState(() {
          lastLocation = dto;
        });
      }
    } else {
      lastLocation = dto;
    }
  }

  @override
  //Setting the location manager for listening on position
  void initState() {
    locationManager.interval = 3;
    locationManager.distanceFilter = 0;
    locationManager.notificationTitle = 'BorderWander';
    locationManager.notificationMsg =
        'The application is still running in the background, if you want to close the application, turn it off via the menu in the application';
    dtoStream = locationManager.dtoStream;
    super.initState();
  }

//To start locationManater
  Future<void> start() async {
    if (dtoSubscription != null) {
      dtoSubscription.cancel();
    }
    dtoSubscription = dtoStream.listen(onData);
    await locationManager.start();
  }

//To stop location manager when log out or killing the app
  Future<void> stop() async {
    dtoSubscription.cancel();
    await locationManager.stop();
  }

//Getting initial data
  @override
  void didChangeDependencies() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!_init) {
          await start();
          var location = await Location.instance.getLocation();
          _userLocation.add(LatLng(location.latitude, location.longitude));
          _controller.move(
            LatLng(location.latitude, location.longitude),
            18,
          );
          _init = true;
          if (!Provider.of<DataFetcher>(context, listen: false)
              .currUserInformation['tutorial']) {
            Navigator.of(context).pushNamed(TutorialTutorial.routeName);
          }
        }
        _init = true;
      },
    );

    //Location button logic
    bool pressed = Provider.of<Core>(context).toCurrLoc ?? false;
    if (pressed && _userLocation.length > 0) {
      _controller.move(
        LatLng(_userLocation[0].latitude, _userLocation[0].longitude),
        18,
      );
      Provider.of<Core>(context, listen: false).changeCurrLocToFalse();
      super.didChangeDependencies();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//The bottom sheet when user is taking territory
  void _modalBottomSheetMenu() {
    _scaffoldKey.currentState.showBottomSheet(
      (context) => GestureDetector(
        onVerticalDragStart: (_) {},
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius:
                const BorderRadius.vertical(top: const Radius.circular(30.0)),
          ),
          height: 150,
          child: Column(
            children: [
              //The decoration thingy---------------------------------------
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 10,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Info text-----------------------------------------
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Start route',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 23),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Speed ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(fontSize: 18),
                            ),
                            Text(
                              '${Provider.of<Core>(context).speed} km/h',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //Stop button---------------------------------------------
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.all(15),
                    child: IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        Navigator.pop(context);
                        if (!Provider.of<Core>(context, listen: false)
                            .isTakingLand) {
                          _points.clear();
                        }
                        Provider.of<Core>(context, listen: false)
                            .startStopTakingLand(_points, this.context);
                      },
                      iconSize: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.vertical(top: const Radius.circular(30.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MapDrawer(stop),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //Menu----------------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            if (!Provider.of<Core>(context).isTakingLand)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: _showMenu
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (_showMenu)
                          Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: 100,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                //ColorShop-------------------------------------
                                IconButton(
                                  iconSize: 25,
                                  icon: const Icon(Icons.crop_square_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _showMenu = false;
                                    });
                                    Navigator.pushNamed(
                                        context, ColorShop.routeName);
                                  },
                                  color: Colors.white,
                                ),

                                //Character-------------------------------------
                                IconButton(
                                  iconSize: 25,
                                  icon: const Icon(Icons.accessibility),
                                  onPressed: () {
                                    setState(() {
                                      _showMenu = false;
                                    });
                                    Navigator.pushNamed(
                                        context, CharacterShop.routeName);
                                  },
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                        //Location button-----------------------------------
                        Container(
                          margin: const EdgeInsets.only(right: 45),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor),
                          child: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {
                              Provider.of<Core>(context, listen: false)
                                  .changeCurrLoc(true);
                            },
                            color: Colors.white,
                            iconSize: 25,
                          ),
                        )
                      ],
                    ),
                    if (!Provider.of<Core>(context).isTakingLand)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Shop Button---------------------------------
                                  IconButton(
                                    iconSize: 30,
                                    icon: const Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      setState(() {
                                        _showMenu = !_showMenu;
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                  //Character button----------------------------
                                  IconButton(
                                      iconSize: 30,
                                      icon: const Icon(
                                          Icons.supervised_user_circle),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, CharacterPage.routeName);
                                      },
                                      color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          //Big StartStop Button
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 40),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(70),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow_rounded),
                              iconSize: 30,
                              onPressed: () {
                                if (!Provider.of<Core>(context, listen: false)
                                    .isTakingLand) {
                                  _points.clear();
                                }
                                Provider.of<Core>(context, listen: false)
                                    .startStopTakingLand(_points, this.context);
                                _modalBottomSheetMenu();
                              },
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              )
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('data').snapshots(),
          builder: (ctx, snapshot) => FlutterMap(
            //MAP---------------------------------------------------------------
            mapController: _controller,
            options: MapOptions(
              rotationThreshold: 0,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              onPositionChanged: (a, b) {
                if (_init) {
                  setState(() {
                    _showMenu = false;
                  });
                }
              },
              onTap: (loc) async {
                //Showing whoose location it is
                Map<String, dynamic> a =
                    await Provider.of<DataFetcher>(context, listen: false)
                        .getUserNameFromLoc(loc);
                if (a['username'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 0, milliseconds: 750),
                    content: Container(
                        height: 20, child: Center(child: Text(a['username']))),
                    backgroundColor: Theme.of(context).primaryColor,
                  ));
                }
                setState(() {
                  _showMenu = false;
                });
              },
              zoom: 18,
              maxZoom: 18.0,
              minZoom: 2.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: Provider.of<Core>(context).whiteMap
                    ? 'https://api.mapbox.com/styles/v1/borderwander/ckn4nihtt20a617paiahuao97/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9yZGVyd2FuZGVyIiwiYSI6ImNrbXc5bmF4dDBjd24yd216em84cGVlbjgifQ.VTqn0l5diQHc_RFU5mS0Zw'
                    : 'https://api.mapbox.com/styles/v1/borderwander/ckmwaymo91c3317mkz0zip3tv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9yZGVyd2FuZGVyIiwiYSI6ImNrbXc5bmF4dDBjd24yd216em84cGVlbjgifQ.VTqn0l5diQHc_RFU5mS0Zw',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiYm9yZGVyd2FuZGVyIiwiYSI6ImNrbXc5bmF4dDBjd24yd216em84cGVlbjgifQ.VTqn0l5diQHc_RFU5mS0Zw',
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              //Territory Rendering--------------------------------------------
              PolygonLayerOptions(
                polygons: [
                  ...Provider.of<DataFetcher>(context)
                      .getPolygonsFromSnapshot(snapshot.data),
                  ...Provider.of<DataFetcher>(context).logInUserPolygons,
                  if (!Provider.of<Core>(context, listen: false).lenSvojeUzemie)
                    ...Provider.of<DataFetcher>(context).otherUsersPolygons,
                ],
                polygonCulling: true,
              ),
              //Line Rendering--------------------------------------------
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points:
                        Provider.of<Core>(context, listen: false).isTakingLand
                            ? _points
                            : [],
                    strokeWidth: 4.0,
                    color: Color(Provider.of<DataFetcher>(context)
                        .currUserInformation['color']),
                  ),
                  Polyline(
                    points: _userLocation,
                    strokeWidth: 15.0,
                    color: Color(Provider.of<DataFetcher>(context)
                        .currUserInformation['color']),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
