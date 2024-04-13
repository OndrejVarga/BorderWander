import 'package:borderwander/providers/core.dart';
import 'package:borderwander/providers/image_controller.dart';
import 'package:borderwander/utils/data_sender.dart';
import 'package:borderwander/utils/error_alert.dart';
import 'package:poly/poly.dart' as pl;
import 'package:poly_collisions/poly_collisions.dart' as pl;
import '../utils/territory_managment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'dart:core';
import 'package:provider/provider.dart';

class DataFetcher with ChangeNotifier {
  List<Polygon> _logInUserPolygons = [];
  List<Polygon> _otherUsersPolygons = [];
  List<Map<String, dynamic>> _tableData = [];
  Map<String, dynamic> _currUserInformation = {};
  Map<String, int> N_userColors = {};
  Map<String, dynamic> _settings = {};
  List<Map<String, dynamic>> _allUserTerritories = [];
  int _streak = 0;

//Getters-------------------------------------------------------------------
  List<Polygon> get logInUserPolygons => _logInUserPolygons;
  List<Polygon> get otherUsersPolygons => _otherUsersPolygons;
  List<Map<String, dynamic>> get tableData => _tableData;
  Map<String, dynamic> get currUserInformation => _currUserInformation;
  Map<String, dynamic> get settings => _settings;
  List<Map<String, dynamic>> get allUserTerritories => _allUserTerritories;
  int get streak => _streak;
//Polygons from data stream---------------------------------------------------------------
  List<Polygon> getPolygonsFromSnapshot(QuerySnapshot snapshot) {
    if (snapshot != null) {
      _logInUserPolygons.clear();
      _otherUsersPolygons.clear();

      for (int i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i].data()['UID'] ==
            FirebaseAuth.instance.currentUser.uid) {
          _logInUserPolygons.add(
            Polygon(
                points: convertFromServerToLatLngPoints(
                    snapshot.docs[i].data()['taken_territory']),
                color: Color(_currUserInformation['color']).withOpacity(0.3),
                isDotted: true,
                borderStrokeWidth: 5,
                borderColor: Color(
                  _currUserInformation['color'],
                )),
          );
        } else {
          var color = Colors.white.value;
          if (_userColors[snapshot.docs[i].data()['UID']] != null) {
            color = _userColors[snapshot.docs[i].data()['UID']];
          }
          _otherUsersPolygons.add(
            Polygon(
                points: convertFromServerToLatLngPoints(
                    snapshot.docs[i].data()['taken_territory']),
                color: Color(color).withOpacity(0.3),
                borderStrokeWidth: 5,
                isDotted: true,
                borderColor: Color(color)),
          );
        }
      }
    }
    return [];
  }

  Future<bool> fetchInitData(BuildContext context) async {
    print("FETCHING INNIT DATA");
    await fetchUserInfo();
    print("FETCHING INNIT DATA");
    await fetchTableData();
    print("FETCHING INNIT DATA");
    await fetchColorOfOtherUser();
    print("FETCHING INNIT DATA");
    await fetchSettings();
    print("OK");
    Provider.of<Core>(context, listen: false)
        .setWhiteMap(_currUserInformation['whiteMap']);
    print("OKERINO");
    return true;
  }

  Future<bool> fetchShopData() async {
    await updateUserData();
    await fetchUserInfo(ok: true);
    await fetchTableData();
    return true;
  }

//Fteching information----------------------------------------------------------------------
  Future<void> fetchUserInfo({ok: false}) async {
    print('starting getting user info');

    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    print('adding');
    print(userData.id);
    print(userData['color']);
    print(userData['currAreaOfTerritory']);
    print(userData['length']);
    print(userData['ownedColors']);
    print(userData['points']);
    print(userData['totalSteps']);
    print(userData['username']);
    print(userData['weight']);
    print(userData['tutorial']);
    print(userData['calories']);
    print(userData['character'].toList());

    if (!ok) {
      _currUserInformation.clear();
      _currUserInformation.addAll({
        'UID': userData.id,
        'whiteMap': userData['whiteMap'],
        'color': userData['color'],
        'currAreaOfTerritory': userData['currAreaOfTerritory'],
        'length': userData['length'],
        'ownedColors': userData['ownedColors'].toList(),
        'points': userData['points'],
        'totalSteps': userData['totalSteps'],
        'username': userData['username'],
        'weight': userData['weight'],
        'tutorial': userData['tutorial'],
        'calories': userData['calories'],
        'characterImageNames': userData['character'].toList(),
        'index': 0
      });
    } else {
      print('just this');
      _currUserInformation['currAreaOfTerritory'] =
          userData['currAreaOfTerritory'];
      _currUserInformation['length'] = userData['length'];
      _currUserInformation['points'] = userData['points'];
      _currUserInformation['calories'] = userData['calories'];
    }
    notifyListeners();
    return true;
  }

  Future<void> fetchSettings() async {
    _settings.clear();
    var settingsData = await FirebaseFirestore.instance
        .collection('core')
        .doc('settings')
        .get();
    _settings.addAll({
      'maxSpeed': settingsData['maxSpeed'],
      'met': settingsData['met'],
    });
    notifyListeners();
  }

  Future<void> fetchColorOfOtherUser() async {
    _userColors.clear();
    var data = await FirebaseFirestore.instance.collection('users').get();
    data.docs.forEach((element) {
      _userColors.addAll({
        element.id: element.get('color'),
      });
    });
  }

  Future<void> fetchTableData() async {
    _tableData.clear();

    QuerySnapshot allData = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('currAreaOfTerritory', descending: true)
        .get();
    print(allData.docs.length);
    for (int i = 0; i < allData.docs.length; i++) {
      print({
        'UID': allData.docs[i].id,
        'username': allData.docs[i].get('username'),
        'currAreaOfTerritory':
            allData.docs[i].get('currAreaOfTerritory').toInt().toString(),
        'character': allData.docs[i].get('character').toList()
      });
      _tableData.add({
        'UID': allData.docs[i].id,
        'username': allData.docs[i].get('username'),
        'currAreaOfTerritory':
            allData.docs[i].get('currAreaOfTerritory').toInt().toString(),
        'character': allData.docs[i].get('character').toList()
      });
      if (allData.docs[i].id == _currUserInformation['UID']) {
        _currUserInformation['index'] = i;
      }
    }
    notifyListeners();
    return true;
  }

  Future<void> fetchAllTerritoriesData(BuildContext context) async {
    if (_allUserTerritories.length > 0) {
      _allUserTerritories.clear();
    }

    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    var data = await FirebaseFirestore.instance
        .collection('territory')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('polygons')
        .get();

    for (int i = 0; i < data.docs.length; i++) {
      _allUserTerritories.add({
        'calories': data.docs[i]['calories'],
        'avgSpeed': data.docs[i]['avgSpeed'],
        'duration': data.docs[i]['duration'],
        'startTime': data.docs[i]['startTime'],
        'endTime': data.docs[i]['endTime'],
        'routeArea': data.docs[i]['routeArea'],
        'routeLength': data.docs[i]['routeLength'],
        'points': data.docs[i]['taken_territory'].toList()
      });
    }

    _streak = calculateStreak();
    print(_streak);
    // _streak = 30;
    if (_streak >= 30 &&
        _currUserInformation['username'][0].codeUnitAt(0) != 55357) {
      setCrown(true);
      ErrorAlert.showError(
          context, 'We received a crown for a month of continuous movement',
          title: 'Congratulations');
    }
    print(_allUserTerritories);
    return true;
  }

  int calculateStreak() {
    if (_allUserTerritories == null || _allUserTerritories.length == 0) {
      return 0;
    }
    List<DateTime> datesOfTerritories = [];
    for (int i = 0; i < _allUserTerritories.length; i++) {
      datesOfTerritories
          .add(DateTime.parse(_allUserTerritories[i]['startTime']));
    }

    List<int> subs = [];

    DateTime now = DateTime.now();
    for (int i = 0; i < datesOfTerritories.length; i++) {
      subs.add(now.difference(datesOfTerritories[i]).inDays);
    }

    subs.sort();
    subs = subs.toSet().toList();

    if (subs[0] > 1) {
      return 0;
    } else {
      for (int i = 0; i < subs.length - 1; i++) {
        if (subs[i] - subs[i + 1] != -1) {
          return subs[i];
        }
      }
    }

    return subs.last;
  }

//Database manipulation-------------------------------------------------------------------------
  Future<void> updateUserData() async {
    var forUpdate =
        TerritoryManagment.getUserTotalAreaLength(_logInUserPolygons);
    print(forUpdate['totalArea']);

    print('UPDATING');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currUserInformation['UID'])
        .update({
      'currAreaOfTerritory': forUpdate['totalArea'],
      'length': forUpdate['totalLength'],
    });
  }

  Future<void> setCrown(bool add) async {
    print('UDPATING');
    if (add) {
      _currUserInformation['username'] =
          '👑' + _currUserInformation['username'];
    }
    // } else {
    //   _currUserInformation['username'] =
    //       _currUserInformation['username'].substring(2);
    // }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currUserInformation['UID'])
        .update({
      'username': _currUserInformation['username'],
    });
  }

  void updateNewUserData(
      int steps, int points, int calories, double area) async {
    await updateUserData();

    print('UPDATING');

    _currUserInformation['totalSteps'] += steps;
    _currUserInformation['points'] += points;
    _currUserInformation['calories'] += calories;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_currUserInformation['UID'])
        .update({
      'totalSteps': _currUserInformation['totalSteps'],
      'points': _currUserInformation['points'],
      'calories': _currUserInformation['calories'],
    });
  }

  Future<void> updateCharacter(BuildContext context) async {
    print('UDPATING');
    print(Provider.of<ImageController>(context, listen: false).toDatabase);
    _currUserInformation['characterImageNames'] =
        Provider.of<ImageController>(context, listen: false).toDatabase;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_currUserInformation['UID'])
        .update({
      'character':
          Provider.of<ImageController>(context, listen: false).toDatabase,
    });
  }

  Future<Map<String, dynamic>> getUserNameFromLoc(LatLng loc) async {
    for (int i = 0; i < _logInUserPolygons.length; i++) {
      List<pl.Point> curr = [];
      _logInUserPolygons[i].points.forEach((element) {
        curr.add(pl.Point(element.latitude, element.longitude));
      });
      if (pl.PolygonCollision.isPointInPolygon(
          curr, pl.Point(loc.latitude, loc.longitude))) {
        return _currUserInformation;
      }
    }

    for (int i = 0; i < _otherUsersPolygons.length; i++) {
      List<pl.Point> curr = [];
      _otherUsersPolygons[i].points.forEach((element) {
        curr.add(pl.Point(element.latitude, element.longitude));
      });
      if (pl.PolygonCollision.isPointInPolygon(
          curr, pl.Point(loc.latitude, loc.longitude))) {
        var userID = await findUIDFromPoints(_otherUsersPolygons[i].points);
        var userData =
            _tableData.indexWhere((element) => element['UID'] == userID['UID']);
        return _tableData[userData];
      }
    }
    return {};
  }

//Shop data---------------------------------------------------------------------------

  void buyColor(Color color) {
    if (!_currUserInformation['ownedColors'].contains(color.value)) {
      currUserInformation['points'] = currUserInformation['points'] - 100000;
      currUserInformation['ownedColors'].add(color.value);

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(
        {
          'points': currUserInformation['points'],
          'ownedColors': currUserInformation['ownedColors']
        },
      );
    }

    notifyListeners();
  }

  void changeUserColor(int color) {
    print('UDPATING');
    _currUserInformation['color'] = color;
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'color': color});
    notifyListeners();
  }

  bool checkValiability(String name) {
    for (int i = 0; i < _tableData.length; i++) {
      if (_tableData[i]['username'] == name) {
        return false;
      }
    }
    return true;
  }

//Utils function----------------------------------------------------------------------

  List<LatLng> convertFromServerToLatLngPoints(List<dynamic> points) {
    List<LatLng> polygonPoints = [];
    for (int i = 0; i + 1 < points.length; i += 2) {
      polygonPoints.add(LatLng(points[i], points[i + 1]));
    }
    return polygonPoints;
  }

  void sendBug(String bugText) {
    DataSender.sendToBug({'UID': _currUserInformation['UID'], 'bug': bugText});
  }

  void addPoints() {
    currUserInformation['points'] += 500;
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(
      {
        'points': currUserInformation['points'],
      },
    );
  }

//Find functions----------------------------------------------------------------------
  Future<Map<String, dynamic>> findUIDFromPoints(
      List<LatLng> polygonPoints) async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection('data').get();
    for (int i = 0; i < data.docs.length; i++) {
      var currPolyPoints = data.docs[i].get('taken_territory');
      if (TerritoryManagment.isSameTerritory(
          convertFromServerToLatLngPoints(currPolyPoints), polygonPoints)) {
        return {
          'UID': data.docs[i]['UID'],
          'reference': data.docs[i].reference
        };
      }
    }
    return null;
  }

  Future<void> deleteFrom(DocumentReference reference) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(reference);
    });
  }
}
