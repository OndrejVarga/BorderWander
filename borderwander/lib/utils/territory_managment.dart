import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:poly/poly.dart' as pl;
import 'package:poly_collisions/poly_collisions.dart' as pl;

class TerritoryManagment {
  //check if the new territory is ok
  static List<LatLng> validateNewTerritory(List<LatLng> routePoints) {
    for (int i = 0; i < routePoints.length; i++) {
      for (int j = routePoints.length - 1; j - 1 > i + 1; j--) {
        LatLng intersection = _getIntersection(routePoints[i],
            routePoints[i + 1], routePoints[j], routePoints[j - 1]);

        if (intersection != null) {
          routePoints.insert(j, intersection);
          routePoints.insert(i + 1, intersection);

          bool deleting = true;
          for (int k = 0; k < routePoints.length; k++) {
            if (routePoints[k] == intersection) {
              deleting = !deleting;
            }
            if (deleting) {
              routePoints.removeAt(k);
              k--;
            }
          }
          return routePoints;
        }
      }
    }
    return [];
  }

//Check when two territories are on top of each other
  static List<LatLng> validateNewTerritoryOnOtherTerritory(
      List<LatLng> otherTerritory, List<LatLng> routePoints) {
    List<pl.Point> routePointsInPoints =
        routePoints.map((e) => pl.Point(e.longitude, e.latitude)).toList();
    for (int i = 0; i < otherTerritory.length; i++) {
      if (pl.PolygonCollision.isPointInPolygon(routePointsInPoints,
          pl.Point(otherTerritory[i].longitude, otherTerritory[i].latitude))) {
        otherTerritory.removeAt(i);
        i--;
      }
    }
    return otherTerritory;
  }

  static List<LatLng> validateNewTerritoryOfSameUser(
      List<LatLng> otherTerritory, List<LatLng> routePoints) {
    print('Starting validating');
    List<pl.Point> routePointsInPoints =
        routePoints.map((e) => pl.Point(e.longitude, e.latitude)).toList();
    List<pl.Point> otherTerritoryInPoints =
        otherTerritory.map((e) => pl.Point(e.longitude, e.latitude)).toList();

    //checking if the first point is outside of users location
    if (pl.PolygonCollision.isPointInPolygon(
        otherTerritoryInPoints, routePointsInPoints[0])) {
      List<Map<String, dynamic>> intersections = [];
      print('IS inside');
      // find the intersection
      for (int i = 0; i < routePoints.length; i++) {
        for (int j = 0; j < otherTerritory.length; j++) {
          LatLng intersection = _getIntersection(
              routePoints[i],
              routePoints[i + 1 == routePoints.length ? 0 : i + 1],
              otherTerritory[j],
              otherTerritory[j + 1 == otherTerritory.length ? 0 : j + 1]);
          if (intersection != null) {
            intersections.add({
              'point': intersection,
              'routePointLoc': i + 1,
              'otherTerritoryLoc': j + 1
            });
          }
        }
      }
      print('Deleting the middle part');
      print(intersections);
      //delete the middle part of existing territory
      otherTerritory.insert(
          intersections[0]['otherTerritoryLoc'], intersections[0]['point']);
      otherTerritory.insert(
          intersections[1]['otherTerritoryLoc'], intersections[1]['point']);
      routePoints.insert(
          intersections[0]['routePointLoc'], intersections[0]['point']);
      routePoints.insert(
          intersections[1]['routePointLoc'], intersections[1]['point']);

//TODO to by mohol byt probleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeem
//ak to odstranuje blbu cast

      List<pl.Point> routePointsInPoints =
          routePoints.map((e) => pl.Point(e.longitude, e.latitude)).toList();
      List<pl.Point> otherTerritoryInPoints =
          otherTerritory.map((e) => pl.Point(e.longitude, e.latitude)).toList();
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      print(otherTerritoryInPoints.length);
      print(otherTerritory.length);
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      //TODO TU je probleem teraz reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
      for (int i = 0; i < otherTerritoryInPoints.length; i++) {
        if (pl.PolygonCollision.isPointInPolygon(
            routePointsInPoints, otherTerritoryInPoints[i])) {
          if (otherTerritory[i].latitude ==
                      intersections[0]['point'].latitude &&
                  otherTerritory[i].longitude ==
                      intersections[0]['point'].longitude ||
              otherTerritory[i].latitude ==
                      intersections[1]['point'].latitude &&
                  otherTerritory[i].longitude ==
                      intersections[1]['point'].longitude) {
          } else {
            otherTerritoryInPoints.removeAt(i);
            otherTerritory.removeAt(i);
            i--;
          }
        }
      }
      //join the two territories
      print('joining');
      int startIndex = otherTerritory.indexOf(intersections[0]['point']);
      print(intersections[0]['routePointLoc']);
      print(intersections[1]['routePointLoc']);

      for (int i = 0; i < routePointsInPoints.length; i++) {
        if (pl.PolygonCollision.isPointInPolygon(
            otherTerritoryInPoints, routePointsInPoints[i])) {
          routePointsInPoints.removeAt(i);
          routePoints.removeAt(i);
          i--;
        }
      }
      List<LatLng> toAdd = routePoints.sublist(
          intersections[0]['routePointLoc'], intersections[1]['routePointLoc']);
      print('SUBLINST');
      print(routePoints.length);
      print(otherTerritory.length);
      print(startIndex);
      print('SUBLINST');
      if (mt.SphericalUtil.computeDistanceBetween(
              mt.LatLng(routePoints[0].latitude, routePoints[0].longitude),
              mt.LatLng(otherTerritory[startIndex].latitude,
                  otherTerritory[startIndex].longitude)) >
          mt.SphericalUtil.computeDistanceBetween(
              mt.LatLng(routePoints.last.latitude, routePoints.last.longitude),
              mt.LatLng(otherTerritory[startIndex].latitude,
                  otherTerritory[startIndex].longitude))) {
        print('YLEYLEYLEYLEYEYELYELY');
        print('YLEYLEYLEYLEYEYELYELY');
        print('YLEYLEYLEYLEYEYELYELY');
        print('YLEYLEYLEYLEYEYELYELY');
        for (int i = 0; i < routePoints.length; i++) {
          otherTerritory.insert(startIndex + 1, routePoints[i]);
          startIndex++;
        }
      } else {
        for (int i = routePoints.length - 1; i >= 0; i--) {
          otherTerritory.insert(startIndex + 1, routePoints[i]);
          startIndex++;
        }
      }

      print('ReTURNGLFNKGDSLNFKDLSF');
      print(otherTerritory.length);
      return otherTerritory;
    } else {
      print('not Ok');
      return null;
    }
  }

  // static List<LatLng> validateNewTerritoryOnOtherTerritoryWhenParemetes(
  //     List<LatLng> otherTerritory,
  //     List<LatLng> routePoints,
  //     List<LatLng> intersections) {
  //   List<pl.Point> routePointsInPoints =
  //       routePoints.map((e) => pl.Point(e.longitude, e.latitude)).toList();
  //   for (int i = 0; i < otherTerritory.length; i++) {
  //     if (intersections.contains(otherTerritory[i])) {}
  //     if (pl.PolygonCollision.isPointInPolygon(routePointsInPoints,
  //         pl.Point(otherTerritory[i].longitude, otherTerritory[i].latitude))) {
  //       if (!intersections.contains(otherTerritory[i])) {
  //         otherTerritory.removeAt(i);
  //         i--;
  //       }
  //     }
  //   }
  //   return otherTerritory;
  // }

  static List<List<LatLng>> isIntersectingWithOtherPolygon(
      List<LatLng> routePoints, List<Polygon> otherUserPolygons) {
    List<List<LatLng>> allIntersectingWith = [];
    List<pl.Point> routePointsInPoints =
        routePoints.map((e) => pl.Point(e.longitude, e.latitude)).toList();
    for (int i = 0; i < otherUserPolygons.length; i++) {
      if (pl.PolygonCollision.doesOverlap(
          routePointsInPoints,
          otherUserPolygons[i]
              .points
              .map((e) => pl.Point(e.longitude, e.latitude))
              .toList())) {
        allIntersectingWith.add(otherUserPolygons[i].points);
      }
    }
    return allIntersectingWith;
  }

  static LatLng _getIntersection(LatLng p0, LatLng p1, LatLng p2, LatLng p3) {
    var a1 = p1.latitude - p0.latitude;
    var b1 = p0.longitude - p1.longitude;
    var c1 = a1 * p0.longitude + b1 * p0.latitude;

    var a2 = p3.latitude - p2.latitude;
    var b2 = p2.longitude - p3.longitude;
    var c2 = a2 * p2.longitude + b2 * p2.latitude;

    var denominator = a1 * b2 - a2 * b1;

    if (a1 == 0 || b1 == 0 || c1 == 0) {
      return null;
    }

    if (denominator == 0) {
      return null;
    } else {
      var x = (b2 * c1 - b1 * c2) / denominator;
      var y = (a1 * c2 - a2 * c1) / denominator;

      var rx0 = (x - p0.longitude) / (p1.longitude - p0.longitude);
      var ry0 = (y - p0.latitude) / (p1.latitude - p0.latitude);

      var rx1 = (x - p2.longitude) / (p3.longitude - p2.longitude);
      var ry1 = (y - p2.latitude) / (p3.latitude - p2.latitude);

      if (((rx0 >= 0 && rx0 <= 1) || (ry0 >= 0 && ry0 <= 1)) &&
          ((rx1 >= 0 && rx1 <= 1) || (ry1 >= 0 && ry1 <= 1))) {
        return LatLng(y, x);
      }
    }
    return null;
  }

//Utils-----------------------------------------------
  static Map<String, double> getNewTotalAreaLength(
      List<Polygon> userPolygons, List<LatLng> routePoints) {
    var properties = getUserTotalAreaLength(userPolygons);
    double routePointsArea = mt.SphericalUtil.computeArea(
            routePoints.map((e) => mt.LatLng(e.latitude, e.longitude)).toList())
        .toDouble();
    double routePointsLength = mt.SphericalUtil.computeLength(
            routePoints.map((e) => mt.LatLng(e.latitude, e.longitude)).toList())
        .toDouble();
    return {
      'totalArea': properties['totalArea'] + routePointsArea,
      'totalLength': properties['totalLength'] + routePointsLength,
      'routeArea': routePointsArea,
      'routeLength': routePointsLength
    };
  }

  static Map<String, double> getUserTotalAreaLength(
      List<Polygon> userPolygons) {
    double totalArea = 0;
    double totalLength = 0;
    for (int i = 0; i < userPolygons.length; i++) {
      var currentPol = userPolygons[i]
          .points
          .map((e) => mt.LatLng(e.latitude, e.longitude))
          .toList();
      totalArea += mt.SphericalUtil.computeArea(currentPol);
      totalLength += mt.SphericalUtil.computeLength(currentPol);
    }
    return {
      'totalArea': totalArea,
      'totalLength': totalLength,
    };
  }

  static bool isSameTerritory(List<LatLng> route1, List<LatLng> route2) {
    if (route1.length != route2.length) {
      return false;
    } else {
      for (int i = 0; i < route1.length; i++) {
        if (route1[i] != route2[i]) {
          return false;
        }
      }
      return true;
    }
  }
}
