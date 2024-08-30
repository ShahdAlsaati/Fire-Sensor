import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadController extends GetxController {
  final _image = Rx<XFile?>(null);

  XFile? get image => _image.value;

  Future<void> pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image.value = pickedImage;
    }
  }

  void uploadImage() {
    // Ensure that an image is picked before attempting to upload
    if (_image.value != null) {
      // Implement your image upload logic here
      // This could involve using a backend API or cloud storage service
      // For simplicity, we'll just print the image file path
      print('Uploading image: ${_image.value!.path}');
    } else {
      print('No image selected');
    }
  }
}
