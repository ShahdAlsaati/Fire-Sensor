import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/theme_and_color/color.dart';
import '../../controller/map_controller/map_fire_size_controller.dart';

class MapSizeFireScreen extends StatelessWidget {
  final MapFireSizeController mapController = Get.put(MapFireSizeController());
  final bool isUser;

  MapSizeFireScreen({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mapController.onMapCreated;
      await mapController.getCurrentLocation();
      await mapController.loadCustomMarkers();
      await getLoc(context);
      await mapController.fetchFirMap();
    });

    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<MapFireSizeController>(
            builder: (controller) => GoogleMap(
              markers: mapController.markers.toSet(),
              onMapCreated: mapController.onMapCreated,
              onCameraMove: (CameraPosition position) {
                getLoc(context);
                mapController.fetchFireMapWithDebounce();  // Use the debounced method
              },
              initialCameraPosition: mapController.position != null
                  ? CameraPosition(
                target: LatLng(
                  mapController.position!.latitude,
                  mapController.position!.longitude,
                ),
                zoom: 2.0,
              )
                  : const CameraPosition(
                target: LatLng(34.7230684, 36.6985274),
                zoom: 2.0,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 4.h,
          //   left: 18.w,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.35,
          //     height: MediaQuery.of(context).size.width * 0.18,
          //     decoration: BoxDecoration(
          //       color: newButton,
          //       borderRadius: BorderRadius.circular(11),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  getLoc(BuildContext context) async {
    Size screenSize = MediaQuery.of(context).size;

    ScreenCoordinate rightUp = ScreenCoordinate(x: screenSize.width.toInt(), y: 0);
    ScreenCoordinate leftDown = ScreenCoordinate(x: 0, y: screenSize.height.toInt());

    LatLng rightUpLatLng = await mapController.mapController.getLatLng(rightUp);
    LatLng leftDownLatLng = await mapController.mapController.getLatLng(leftDown);
    mapController.updateRightUpLatLngLeftDownLatLng(rightUpLatLng, leftDownLatLng);

  }

}

