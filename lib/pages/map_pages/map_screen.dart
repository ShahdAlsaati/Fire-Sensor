import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/controller/map_controller/map_controller.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../controller/post_controller/create_post_controller.dart';

class MapScreen extends StatelessWidget {
  final MapController mapController = Get.put(MapController());
  final CreatePostController createPostController = Get.find();

   MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('MapScreen rebuilt');

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetBuilder<MapController>(
        init: MapController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController.onMapCreated(controller);
                        mapController.getCurrentLocation();
                      },
                      initialCameraPosition: mapController.position != null
                          ? CameraPosition(
                        target: LatLng(
                          mapController.position!.latitude,
                          mapController.position!.longitude,
                        ),
                        zoom: 15.0,
                      )
                          : const CameraPosition(
                        target: LatLng(34.7230684, 36.6985274),
                        zoom: 15.0,
                      ),
                      circles: mapController.circles,
                      onTap: mapController.onMapTap,
                      markers: mapController.markers.toSet(),
                    ),
                    Positioned(
                      bottom: 90,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              SfSlider(
                                activeColor: buttonColor,
                                // tickShape:Colors.amber,
                                min: 0.0,
                                max: 1000.0,
                                value: mapController.circleRadius.value,
                                interval: 100, // Define the interval
                                showTicks: true, // Enable ticks to visualize intervals
                                showLabels: true, // Show labels
                                minorTicksPerInterval: 0, // No minor ticks
                                enableTooltip: true,
                                labelFormatterCallback: (dynamic actualValue, String formattedText) {
                                  // Convert to int first and show labels only for 0, 100, 500, and 1000
                                  int intValue = actualValue.toInt();
                                  if (intValue == 0 || intValue == 100 || intValue == 500 || intValue == 1000) {
                                    return intValue.toString(); // Convert int to string
                                  }
                                  // Return an empty string for other values to hide them
                                  return '';
                                },

                                onChanged: (dynamic value) {
                                  // Update the circle radius value
                                  mapController.circleRadius.value = value;
                                  // Optionally, call the method to handle other logic
                                  mapController.onRadiusChanged(value); // Ensure the method is called with the updated value
                                },
                              ),

                              divider(),
                              divider(),
                              divider(),
                              divider(),

                              ButtonWidget(
                                text: 'Select',
                                onTap: () async {
                                  print('i click on select');
                                  print(mapController.circleCenter.value.longitude);
                                  print(mapController.circleCenter.value.latitude);

                                  await mapController.selectLocation();

                                  Get.back();
                                },
                                color: buttonColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }


}
