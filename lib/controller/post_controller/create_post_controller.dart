import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/constants/constants.dart';
import '../../constants/String/error.dart';
import '../../constants/function.dart';
import '../../shared/network/local/cache_helper.dart';

class CreatePostController extends GetxController {
  var titleController = TextEditingController();
  var bodyController = TextEditingController();

  var isLoading = false.obs;
  final _apiServer = APIServer();

  RxString feelingsId = '1'.obs;

  updateFeelingsId(String feelings) {
    feelingsId.value = feelings;
    print(feelingsId.value);
  }

  RxDouble latitudeof = 0.0.obs;  // Initialize directly as RxDouble
  RxDouble longitudeof = 0.0.obs; // Initialize directly as RxDouble
  double? latitude;
  double? longitude;
  RxDouble radius = 0.0.obs; // Initialize directly as RxDouble
  final RxDouble radiusS = 0.0.obs; // Example, initialize with a default value
  Position? position;

  var selectedButtonIndex = 0.obs;

  void setSelectedButtonIndex(int index) {
    selectedButtonIndex.value = index;
  }

  getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition();
      update();
    } catch (e) {
      print('Error getting location: $e');
      return;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }


  updateRadius(double newValue) {
    radiusS.value = newValue;  // Update RxDouble with a double value
    print("iam hhhhhhhhhhhhh");
  }


  updatelanlat(LatLng latLng) {
    latitudeof.value = latLng.latitude;  // Update RxDouble with a double value
    longitudeof.value = latLng.longitude;  // Update RxDouble with a double value
    print(longitudeof.value);
    print(latitudeof.value);
    // update();
  }

  getLatLongRadius({required double latitude1, required double longitude1, required double rad}) {
    latitude = latitude1;
    longitude = longitude1;
    radius.value = rad;  // Update RxDouble with a double value

    print("I am working in getLatLongRadius");
    print(latitude);
    print(longitude);
    print(radius);
    // update();
  }

  final formKey = GlobalKey<FormState>();

  Future<void> createPost() async {
    if (formKey.currentState?.validate() == false) return;

    isLoading.value = true;

    if (longitude == null) {
      errorSnakeBar(setLocationError);
      isLoading.value = false;
      return;
    }
    if( position==null)
      {
        errorSnakeBar('please make sure that location in on');
        isLoading.value = false;
        return;
      }

    final r = await _apiServer.createPost(
      textBody: bodyController.text.toString(),
      radius: radiusS.value,
      userLatitude: position!.latitude,
      userLongitude: position!.longitude,
      longitude: longitude!,
      latitude: latitude!,
      feelingId: feelingsId.value,
    ).onError((error, stackTrace) {
      Get.snackbar('Error', '$error', backgroundColor: Colors.redAccent);
      isLoading.value = false;
      return null;
    });

    if (r == null) {
      isLoading.value = false;
      return;
    }

    if (r.hasError) {
      isLoading.value = false;

      var errorMessage = 'An unknown error occurred';
      if (r.body is Map && r.body.containsKey('codes')) {
        var errors = r.body['codes'];
        print("errors: $errors");

        // Check if the error list contains the code 1
        if (errors is List && errors.contains(19)) {
          errorMessage = 'must specify post body';
        }
      }

      errorSnakeBar(errorMessage);


      return;

    }

    if (r.statusCode == 200 && r.body['message'] == 'success') {
      Get.snackbar('Success', 'post published successfully', backgroundColor: Colors.white10);
      bodyController.text = '';
      isLoading.value = false;
    }
  }
}
class APIServer extends GetConnect {

  /// [createPost] -- do sign up
  Future<Response?> createPost({required String textBody,
    required double userLatitude,
    required double userLongitude,
    required double latitude,
    required double longitude,
    required double radius,
    required String feelingId,
  }) async {

    var headers = {
      'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "postBody":textBody,
      "feelingId": feelingId,
      "disk": {
        "center": {
          "latitude":latitude,
          "longitude": longitude
        },
        "radius": radius
      },
      "postLocation": {
        "coordinates": {
          "longitude": userLongitude,
          "latitude": userLatitude
        }
      }

    });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}create/post',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
}

