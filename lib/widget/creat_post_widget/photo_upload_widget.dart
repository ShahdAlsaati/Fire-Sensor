import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/photo_upload_controller.dart';

class PhotoUploadWidget extends StatelessWidget {
  final PhotoUploadController _controller = Get.put(PhotoUploadController());

   PhotoUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
                () => _controller.image != null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    height:MediaQuery.of(context).size.width*0.5 ,

                    child: Image.file(File(_controller.image!.path),fit: BoxFit.fitWidth,))
                : Container(),
          ),

          ElevatedButton(

            onPressed: () => _controller.pickImage(),
            child: const Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: () => _controller.uploadImage(),
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
