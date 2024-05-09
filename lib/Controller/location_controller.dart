import 'dart:async';
import 'dart:math';
import 'package:distance_app/Model/location_model.dart';
import 'package:distance_app/utils/local_db.dart';
import 'package:distance_app/utils/timer_conversion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationDataController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isTraking = false.obs;
  DatabaseHelper databaseHelper = DatabaseHelper();
  RxList<Map<String, dynamic>> parsedData = <Map<String, dynamic>>[].obs;
  RxDouble totalDistance = 0.0.obs;
  Rx<DateTime> startTime = DateTime.now().obs;
  RxDouble startLatitude = 0.0.obs;
  RxDouble startLongitude = 0.0.obs;
  RxDouble endLatitude = 0.0.obs;
  RxDouble endtLongitude = 0.0.obs;
  RxDouble accuracy = 0.0.obs;
  Rx<Duration> trackingDuration = const Duration().obs;
  final searchController = TextEditingController().obs;
  StreamSubscription<LocationData>? locationSubscription;
  ///  getTotal disatnce
  getTotalDistance() async {
    isLoading(true);
    totalDistance.value = await databaseHelper.getTotalDistance();
    if (kDebugMode) {
      print("total distance--> ${totalDistance.value}");
    }
  }
  ///  filter on start and end date
  filterData({required String stratTime, required String endTime}) async {
    isLoading(true);
    // parsedData.clear();
    List<Map<String, dynamic>> data = await databaseHelper.filterData(
            startTime: stratTime, endTime: endTime) ??
        [];
    parsedData.value = [];
    parsedData.value = data;
    refresh();
    if (kDebugMode) {
      print("total distance--> $parsedData");
    }
    isLoading(false);
  }
  /// read data from table
  Future<void> getData(String query) async {
    isLoading(true);
    parsedData.value = await databaseHelper.getData(query) ?? [];
    if (kDebugMode) {
      print("lidatData--> ${parsedData.toString()}");
    }
    isLoading(false);
  }
  Future<void> trackingLocation() async {
    Location location = Location();
    startTime.value = DateTime.now();
    ///
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData startLocation;
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    serviceEnabled = await location.serviceEnabled();
    if (kDebugMode) {
      print("service--> $serviceEnabled");
    }
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (kDebugMode) {
        print("service enable--");
      }
      if (!serviceEnabled) {
        return;
      }
    }
    if (permissionGranted == PermissionStatus.granted) {
      isTraking(true);
      Get.snackbar("Success", "Traking Started",
          backgroundColor: Colors.green, colorText: Colors.white);
      startLocation = await location.getLocation();
      startLatitude.value = startLocation.latitude!;
      startLongitude.value = startLocation.longitude!;
      endLatitude.value = startLocation.latitude!;
      endtLongitude.value = startLocation.longitude!;
      if (kDebugMode) {
        print(
            "stat--Location${startLocation.latitude} ${startLocation.longitude}");
      }
      DateTime currentTime = DateTime.now();
      trackingDuration.value = currentTime.difference(startTime.value);
      locationSubscription = location.onLocationChanged
          .listen((LocationData currentLocation) async {
        DateTime currentTime = DateTime.now();
        if (kDebugMode) {
          print("stop location--> ");
        }
        trackingDuration.value = currentTime.difference(startTime.value);
        Timer.periodic(const Duration(seconds: 30), (timer) async {
          endLatitude.value = currentLocation.latitude!;
          endtLongitude.value = currentLocation.longitude!;
          accuracy.value = currentLocation.accuracy!;

          // }
        });
      });
    }
  }

  void stopTracking() async {
    isTraking(false);
    DateTime currentTime = DateTime.now();
    trackingDuration.value = currentTime.difference(startTime.value);
    double distanceInMeters = calculateDistance(startLatitude.value,
        startLongitude.value, endLatitude.value, endtLongitude.value);
    if (kDebugMode) {
      print("distance in meter--> $distanceInMeters");
    }
    if (kDebugMode) {
      print("insertedDate---> $currentTime");
    }
    if (distanceInMeters >= 3) {
      var data = LocationModel(
        latitude: endLatitude.value.toString(),
        longitude: endtLongitude.value.toString(),
        timestamp: convertTime(currentTime),
        accuracy: accuracy.value.toString(),
        distance: distanceInMeters,
      );
      await databaseHelper.insertIntoTable(data);
    }

    Get.snackbar("Success", "Stoped Traking",
        backgroundColor: Colors.red, colorText: Colors.white);
    trackingDuration.value = const Duration(seconds: 0);
    locationSubscription?.resume();
    locationSubscription?.cancel(); // Stop location tracking
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double currentLatitude, double currentLongitude) {
    // Use the Haversine formula to calculate distance between two coordinates
    const double earthRadius = 6371000; // in meters
    double dLat = degreesToRadians(currentLatitude - startLatitude);
    double dLon = degreesToRadians(currentLongitude - startLongitude);
    double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(currentLatitude)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
