import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/pages/map_pages/fire_post_screen.dart';
import 'package:googlemap/shared/network/local/cache_helper.dart';
import '../../constants/theme_and_color/theme.dart';
import '../../model/fire_map_model.dart';

class MapFireSizeController extends GetxController{
  final _apiServer = APIServer();

  LatLng? rightUpLatLng;
  LatLng? leftDownLatLng;
  BitmapDescriptor? activeExtremeFireIcon;
  BitmapDescriptor? activeBigFireIcon;
  BitmapDescriptor? activeMidFireIcon;
  BitmapDescriptor? activeSmallFireIcon;
  BitmapDescriptor? notActiveFireIcon;


  getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location is off');

      // Ask the user to turn on location services
      bool userTurnedOnLocation = await Geolocator.openLocationSettings();

      if (!userTurnedOnLocation) {
        print('User did not turn on location');
        return;
      }
    } else {
      print('Location is on');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("رفض");
      }
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print('Location permission granted');

      try {
        position = await Geolocator.getCurrentPosition(
          // desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        print('Error getting location: $e');
        return;
      }

      print('////////////////////////////////');
      print('Latitude: ${position!.latitude}');
      print('Longitude: ${position!.longitude}');
      print('Accuracy: ${position!.accuracy}');
      print('-------------------------------------');
    }
    update();
  }

  updateRightUpLatLngLeftDownLatLng(rightUpLat,leftDown){
    rightUpLatLng=rightUpLat;
    leftDownLatLng=leftDown;
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Position? position;
  // BitmapDescriptor? customMarkerIcon;

  @override
  void onInit() {
    // TODO: implement onInit
    markers.clear();
    loadCustomMarkers();  // Load custom marker icons when the controller is initialized
    super.onInit();
  }
// Load the custom marker images
  Future<void> loadCustomMarkers() async {
    activeExtremeFireIcon = await BitmapDescriptor.asset(
      height: 20,
      width: 20,
      ImageConfiguration(size: Size(10, 10)), // Smaller size
      'assets/final_icon/activeAndBig.png',
    );
    activeBigFireIcon = await BitmapDescriptor.asset(
      height: 20,
      width: 20,
      ImageConfiguration(size: Size(10, 10)), // Smaller size
      'assets/final_icon/activeAndMid.png',
    );
    activeMidFireIcon = await BitmapDescriptor.asset(
      height: 20,
      width: 20,
      ImageConfiguration(size: Size(10, 10)), // Smaller size
      'assets/final_icon/activeAndSmall.png',
    );
    activeSmallFireIcon = await BitmapDescriptor.asset(
      height: 20,
      width: 20,
      ImageConfiguration(size: Size(10, 10)), // Smaller size
      'assets/final_icon/activeAndVerySmall.png',
    );
    notActiveFireIcon = await BitmapDescriptor.asset(
      height: 20,
      width: 20,
      ImageConfiguration(size: Size(10, 10)), // Smaller size
      'assets/final_icon/nonActive.png',
    );
    update();  // Update the UI to reflect marker loading
  }
  GoogleMapController? googleMapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    googleMapController=controller;
    googleMapController!.setMapStyle(mapStyle);
    controller.setMapStyle(mapStyle);
    update();
  }
  Timer? _debounce;  // Add this line

  @override
  Future<void> onClose() async {
    _debounce?.cancel();  // Cancel the debounce timer when the controller is closed
    super.onClose();
  }

  // Debouncing logic for fetching fire map data
  void fetchFireMapWithDebounce() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchFirMap();
    });
  }


  void addFires(List<Fires> firesList) {
    if (activeBigFireIcon == null) {
      // Marker icons are not loaded yet
      print('Custom marker icons are not loaded yet.');
      return;
    }

    markers.clear();
    // Clear existing markers
    firesList.forEach((fire) {
      BitmapDescriptor icon;{
      if(fire.active!&&fire.fire!.radius!>=0&&fire.fire!.radius!<=100) {
        icon = activeSmallFireIcon!;}
      else if(fire.active!&&fire.fire!.radius!>100&&fire.fire!.radius!<=500) {
        icon = activeMidFireIcon!;}
      else if(fire.active!&&fire.fire!.radius!>500&&fire.fire!.radius!<1000) {
        icon = activeBigFireIcon!;}
      else if(fire.active!&&fire.fire!.radius!>=1000) {
        icon = activeExtremeFireIcon!;}
      else{
        icon=notActiveFireIcon!;
      }


        markers.add(
          Marker(
            icon: icon, // Use appropriate icon
            markerId: MarkerId(fire.fireId!.toString()),
            position: LatLng(
                fire.fire!.center!.latitude!, fire.fire!.center!.longitude!),
            onTap: (){
              String token ='Bearer ${CacheHelper.getData(key:'accessToken')}';
              bool isUser= token==null?false:true;
              Get.to(FirePostScreen(fireId: fire.fireId!, isUser: isUser));
            }
          ),

        );
      }
    });
    update(); // Update the UI to reflect the changes
  }  RxBool isFetching = false.obs;

  Future<void> fetchFirMap() async {
    try {
      isFetching(true);
      final response = await _apiServer.fetchFire(
          blat: leftDownLatLng!.latitude,
          blong: leftDownLatLng!.longitude,
          tlat: rightUpLatLng!.latitude,
          tlong: rightUpLatLng!.longitude
      ).onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          '$error',
          backgroundColor: Colors.redAccent,
        );
        return null;
      });

      if (response == null) {
        return;
      }

      if (response.hasError) {
        Get.snackbar(
          'Error',
          '${response.body}',
          backgroundColor: Colors.redAccent,
        );
      }

      if (response.statusCode == 200) {
        print('await r.body');
        print(await response.body);
        if (response.body['message'] == 'success') {
          print('blong=${leftDownLatLng!.longitude}');

          var jsonResponse = json.decode(response.bodyString!);
          FireModel fireMapModel = FireModel.fromJson(jsonResponse);
          print(jsonResponse);

          print('i am in fetchFirMap');
          print(fireMapModel.fires);

          addFires(fireMapModel.fires!);

        // Get.snackbar(
        //     'success',
        //     'get fire successfully',
        //     backgroundColor: Colors.white10,
        //   );
        }
      }
    } catch (e) {
      print('errrrrrrror');
      print(e.toString());
    } finally {
      isFetching(false);
    }
  }

}
class APIServer extends GetConnect {

  /// [fetchFire]- do fetch
  Future<Response?> fetchFire({
    required double blong,
  required double blat,
  required double tlong,
  required double tlat,
}) async {
    String token ='Bearer ${CacheHelper.getData(key:'accessToken')??CacheHelper.getData(key:'guestToken')}';
    var headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      // get fire request
      final res = await get(
        '${BASE_URL}read/fires?'
        'blong=$blong'
        '&blat=$blat'
        '&tlong=$tlong'
        '&tlat=$tlat',
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

}

