import '../providers/data_fetcher.dart';
import '../utils/territory_managment.dart';
import '../utils/data_sender.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Core with ChangeNotifier {
  Color _selectedColor = Colors.blue;
  bool _isTakingLand = false;
  bool _whiteMap = false;
  DateTime _startTime;
  DateTime _endTime;
  int _initialSteps;
  bool _automatickeSledovanie = false;
  bool _lenSvojeUzemie = false;
  bool _toCurrLoc = false;
  bool _getBonus = false;
  int _speed = 0;

//Getters-------------------------------------------------------------------

  bool get isTakingLand => _isTakingLand;
  bool get automatickeSledovanie => _automatickeSledovanie;
  bool get lenSvojeUzemie => _lenSvojeUzemie;
  bool get toCurrLoc => _toCurrLoc;
  int get speed => _speed;
  Color get selectedColor => _selectedColor;
  bool get whiteMap => _whiteMap;

//Main Function--------------------------------------------------------------
  Future<void> startStopTakingLand(
      List<LatLng> points, BuildContext context) async {
    if (_isTakingLand) {
      _endTime = DateTime.now();
      List<LatLng> _routePoints = points;

      var avgSpeed = ((mt.SphericalUtil.computeLength(_routePoints
                  .map((e) => mt.LatLng(e.latitude, e.longitude))
                  .toList()) /
              _endTime.difference(_startTime).inSeconds) *
          3.6);
      print('AVG SPEED' + avgSpeed.toString());

      if (avgSpeed > 0 &&
          avgSpeed.round() >
              Provider.of<DataFetcher>(context, listen: false)
                  .settings['maxSpeed'])
        await _showSpeedDialog(context);
      else {
        List<LatLng> newTerritory =
            TerritoryManagment.validateNewTerritory(_routePoints);
        print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        print(newTerritory);
        print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        if (newTerritory != null && newTerritory.length > 0) {
          newTerritory.toSet().toList();

          List<LatLng> terr =
              await checkForOtherTerritories(newTerritory, context);

          if (terr.length > 0) newTerritory = [...terr];

          var properties = _routeProperties(
              newTerritory,
              Provider.of<DataFetcher>(context, listen: false)
                  .logInUserPolygons,
              _startTime,
              _endTime,
              0,
              _initialSteps,
              avgSpeed,
              context);

          DataSender.sendToData(properties);
          DataSender.sendToTerritory(properties);

          Provider.of<DataFetcher>(context, listen: false).updateNewUserData(
              properties['steps'],
              (properties['routeArea'] * (_getBonus ? 1.2 : 1)).round(),
              properties['calories'].toInt(),
              properties['routeArea']);
        } else {
          print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
          print('checking for extenstion');
          print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

          List<LatLng> extendedTerritory =
              await checkForSameUserTerritories(_routePoints, context);
          if (extendedTerritory != null) {
            var properties = _routeProperties(
                extendedTerritory,
                Provider.of<DataFetcher>(context, listen: false)
                    .logInUserPolygons,
                _startTime,
                _endTime,
                0,
                _initialSteps,
                avgSpeed,
                context);

            DataSender.sendToData(properties);
            DataSender.sendToTerritory(properties);
          }
        }
      }
    } else {
      _getBonus = false;
      _startTime = DateTime.now();
      _initialSteps = 0;
    }
    _isTakingLand = !_isTakingLand;
    notifyListeners();
  }

//Utlis------------------------------------------------------------------------

  void changeSpeed(int speed) {
    _speed = speed;
    notifyListeners();
  }

  void setWhiteMap(bool whiteMap) {
    _whiteMap = whiteMap;
    notifyListeners();
  }

  void changeWhiteMap(BuildContext context) {
    _whiteMap = !_whiteMap;

    FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<DataFetcher>(context, listen: false)
            .currUserInformation['UID'])
        .update({
      'whiteMap': _whiteMap,
    });
    notifyListeners();
  }

  void changeSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void changeCurrLoc(bool change) {
    _toCurrLoc = change;
    notifyListeners();
  }

  void changeCurrLocToFalse() {
    _toCurrLoc = false;
  }

  Map<String, dynamic> _routeProperties(
      List<LatLng> routePoints,
      List<Polygon> userPolygons,
      DateTime startTime,
      DateTime endTime,
      int steps,
      int initialSteps,
      double avgSpeed,
      BuildContext context) {
    var areaProperties =
        TerritoryManagment.getNewTotalAreaLength(userPolygons, routePoints);
    DateTime a = endTime.subtract(Duration(
        hours: startTime.hour,
        minutes: startTime.minute,
        seconds: startTime.second));
    return {
      'UID': Provider.of<DataFetcher>(context, listen: false)
          .currUserInformation['UID'],
      'timeOfEntryCreation': DateTime.now().toIso8601String(),
      'length': mt.SphericalUtil.computeLength(
          routePoints.map((e) => mt.LatLng(e.latitude, e.longitude)).toList()),
      'avgSpeed': avgSpeed.toInt(),
      'routeArea': areaProperties['routeArea'],
      'routeLength': areaProperties['routeLength'],
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': '${a.hour}:${a.minute}:${a.second}',
      'steps': steps - initialSteps,
      'taken_territory': _convertRouteToList(routePoints),
      'calories':
          calculateCalories(context, endTime.difference(startTime).inSeconds)
    };
  }

  Future<List<LatLng>> checkForSameUserTerritories(
      List<LatLng> routePoints, BuildContext context) async {
    List<Polygon> userPolygons =
        Provider.of<DataFetcher>(context, listen: false).logInUserPolygons;
    List<LatLng> l = [];
    List<List<LatLng>> allIntersectionWithOthersPolygons =
        TerritoryManagment.isIntersectingWithOtherPolygon(
            routePoints, userPolygons);
    if (allIntersectionWithOthersPolygons.length == 0 ||
        allIntersectionWithOthersPolygons.length > 1) {
      print('Not intersecting');
      print(allIntersectionWithOthersPolygons.length);
      return null;
    } else {
      print('is intersecting with simething');
      l = TerritoryManagment.validateNewTerritoryOfSameUser(
          allIntersectionWithOthersPolygons[0], routePoints);
      if (l == null) {
        print('-------------------------------');
        print('Doesnt started inside');
        print('-------------------------------');
      } else {
        print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        print(l);
        print('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
        print(allIntersectionWithOthersPolygons[0]);
        print('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC');
        // Map<String, dynamic> doc =
        //     await Provider.of<DataFetcher>(context, listen: false)
        //         .findUIDFromPoints(allIntersectionWithOthersPolygons[0]);
        // await Provider.of<DataFetcher>(context, listen: false)
        //     .deleteFrom(doc['reference']);
      }
    }
    return l;
  }

  Future<List<LatLng>> checkForOtherTerritories(
      List<LatLng> routePoints, BuildContext context) async {
    List<Polygon> otherUsersPolygons =
        Provider.of<DataFetcher>(context, listen: false).otherUsersPolygons;

    List<List<LatLng>> allIntersectionWithOthersPolygons =
        TerritoryManagment.isIntersectingWithOtherPolygon(
            routePoints, otherUsersPolygons);

    //getting more points if the user takes area of someone else
    if (allIntersectionWithOthersPolygons.length > 0) {
      _getBonus = true;
    }

    for (int i = 0; i < allIntersectionWithOthersPolygons.length; i++) {
      List<LatLng> fixedIntersectionWith =
          TerritoryManagment.validateNewTerritoryOnOtherTerritory(
              [...allIntersectionWithOthersPolygons[i]], routePoints);

      Map<String, dynamic> doc =
          await Provider.of<DataFetcher>(context, listen: false)
              .findUIDFromPoints(allIntersectionWithOthersPolygons[i]);
      await Provider.of<DataFetcher>(context, listen: false)
          .deleteFrom(doc['reference']);
      if (fixedIntersectionWith.length > 0) {
        await DataSender.sendToData({
          'timeOfEntryCreation': DateTime.now().toIso8601String(),
          'UID': doc['UID'],
          'taken_territory': _convertRouteToList(fixedIntersectionWith)
        });
      }
    }
    return routePoints;
  }

//--------------------------------------------------------------------

//--------------------------------------------------------------------
  Future<void> _showSpeedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Warning"),
        content: Text(
            "You have exceeded the maximum permitted speed(${Provider.of<DataFetcher>(context, listen: false).settings['maxSpeed']})!"),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              return true;
            },
          )
        ],
      ),
    );
  }

  List<double> _convertRouteToList(List<LatLng> routePoints) {
    List<double> doubleRoutePoints = [];
    for (int i = 0; i < routePoints.length; i++) {
      doubleRoutePoints.add(routePoints[i].latitude);
      doubleRoutePoints.add(routePoints[i].longitude);
    }
    return doubleRoutePoints;
  }

  int calculateCalories(BuildContext context, int time) {
    return ((((Provider.of<DataFetcher>(context, listen: false)
                            .settings['met'] *
                        Provider.of<DataFetcher>(context, listen: false)
                            .currUserInformation['weight']) /
                    200) *
                time) /
            60)
        .toInt();
  }

  void changeAutomatickeSledovanie() {
    _automatickeSledovanie = !_automatickeSledovanie;
    notifyListeners();
  }

  void changeLenSvojeUzemie() {
    _lenSvojeUzemie = !_lenSvojeUzemie;
    notifyListeners();
  }
}
