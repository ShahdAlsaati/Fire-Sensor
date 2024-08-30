import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import '../../constants/theme_and_color/theme.dart';
import '../../pages/map_pages/map_screen.dart';
import '../post_controller/create_post_controller.dart';

class MapController extends GetxController {
  GoogleMapController? _mapController;
  RxDouble circleRadius = 525.0.obs; // Initial radius in meters
  Set<Circle> circles = {};
  List<Marker> markers = [];
  Position? position;
  Rx<LatLng> circleCenter = Rx<LatLng>(LatLng(0, 0));
  final CreatePostController createPostController = Get.put(CreatePostController());

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permission denied');
        return;
      }
    }

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location is off');
      await Geolocator.openLocationSettings(); // Ask user to enable location services
      return;
    }

    // Fetch current position if permissions are granted
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print('Location permission granted');
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (position != null) {
          circleCenter.value = LatLng(position!.latitude, position!.longitude);
          update();
          print('Latitude: ${position!.latitude}, Longitude: ${position!.longitude}');

          // Center the map on the user's current location
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(circleCenter.value, 15), // Adjust the zoom level as needed
          );

          // Add a marker at the user's location
          markers.add(
            Marker(
              markerId: MarkerId("1"),
              position: circleCenter.value,
            ),
          );

          // Update the circle on the map
          updateCircle();
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.setMapStyle(mapStyle);
    print('GoogleMapController has been created');

    // Get the current location and center the map on it
    getCurrentLocation();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    markers.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mapController != null) {
        print('GoogleMapController is ready');
      } else {
        print('GoogleMapController is not ready');
      }
    });
    getCurrentLocation();
  }

  @override
  void onClose() {
    _mapController?.dispose();
    print("gggggggg");
    super.onClose();
  }

  /// Updates the center of the circle on the map
  void updateCircleCenter(LatLng latLng) {
    circleCenter.value = latLng;
    update(); // Notify listeners to rebuild UI
  }

  /// Handles map tap events to update markers and circle center
  void onMapTap(LatLng point) {
    try {
      markers.clear();  // Clear existing markers
      updateCircleCenter(point);  // Update the circle center to the tapped point
      markers.add(Marker(markerId: MarkerId("1"), position: point));  // Add a marker at the tapped point
      updateCircle();  // Update the circle on the map
      update();  // Notify listeners to rebuild UI
      print('Map tapped at: ${point.latitude}, ${point.longitude}');
    } catch (e) {
      print('Error in onMapTap: $e');
    }
  }

  /// Updates the radius of the circle based on user input
  void onRadiusChanged(double value) {
    try {
      circleRadius.value = value;  // Update the radius
      updateCircle();  // Update the circle on the map
      update();  // Notify listeners to rebuild UI
      print('Radius changed to: $value meters');
    } catch (e) {
      print('Error in onRadiusChanged: $e');
    }
  }

  /// Updates the circle on the map based on the current center and radius
  void updateCircle() {
    circles.clear();  // Clear existing circles
    circles.add(
      Circle(
        circleId: CircleId(circleCenter.toString()),  // Use the circle center as an identifier
        center: circleCenter.value,  // Center of the circle
        radius: circleRadius.value,  // Radius of the circle
        fillColor: buttonColor.withOpacity(0.3),  // Circle fill color
        strokeWidth: 2,  // Circle border width
        strokeColor: buttonColor,  // Circle border color
      ),
    );
  }

  Future<void> selectLocation() async {
    try {
      print('Select button pressed');
      print('Selected location: ${circleCenter.value.latitude}, ${circleCenter.value.longitude}');
      print('Selected radius: ${circleRadius.value} meters');

      await createPostController.updatelanlat(circleCenter.value);
      await createPostController.updateRadius(circleRadius.value);
      await createPostController.getLatLongRadius(
        latitude1: circleCenter.value.latitude,
        longitude1: circleCenter.value.longitude,
        rad: circleRadius.value,
      );

      Get.back();
    } catch (e) {
      print('Error in selectLocation: $e');
    }
  }

  /// Navigates to the map screen
  void navigateToMapScreen() {
    Get.to(() => MapScreen());
  }
}
