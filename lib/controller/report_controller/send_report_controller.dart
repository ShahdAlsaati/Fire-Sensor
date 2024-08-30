import 'package:get/get.dart';
import 'package:googlemap/constants/feelings.dart';
import 'package:url_launcher/url_launcher.dart';

class SendReportController extends GetxController{

  final selectedOption = ''.obs;
  RxList<String> feeilingsList=[
    lv1_name,
    lv2_name,
    lv3_name,
    lv4_name,
  ].obs;
  updateSelectedValue(selectedValue)
  {
    if (selectedValue != null) {
      selectedOption.value = selectedValue; // Update selected option using GetX
    }
  }
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

}