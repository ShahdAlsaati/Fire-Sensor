import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfUseContent extends StatelessWidget {
  const TermsOfUseContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms Of Use'),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },),

      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  termsOfUseText,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String termsOfUseText = '''
## Introduction
Welcome to Fire Sensor. By using our App, you agree to comply with and be bound by the following Terms of Use. Please review these terms carefully. If you do not agree to these terms, you should not use the App.

## Description of Service
Fire Sensor provides a platform for reporting fires, viewing recent fire incidents on a map, adding, editing, and deleting reports, and accessing fire safety tips. Users can also post comments and view specific locations of fires.

## User Responsibilities
1. **Account Registration**: To access certain features of the App, you may be required to create an account. You agree to provide accurate and complete information and to keep this information up to date.
2. **Report Accuracy**: When reporting a fire, you agree to provide accurate and truthful information. False reports are strictly prohibited.
3. **Use of Location Data**: The App requires access to your device's location data to provide services. By using the App, you consent to the collection and use of this data.
4. **Content Ownership and Rights**: You retain ownership of the content you post, including fire reports and comments. By posting content, you grant Fire Sensor a non-exclusive, worldwide, royalty-free license to use, reproduce, and display your content within the App.
5. **Prohibited Conduct**: You agree not to:
   - Post false or misleading information.
   - Use the App for any illegal or unauthorized purpose.
   - Interfere with or disrupt the App or servers or networks connected to the App.
   - Violate any local, state, national, or international law while using the App.

## Our Responsibilities
1. **Data Accuracy**: We strive to provide accurate and up-to-date information but do not guarantee the accuracy, completeness, or reliability of any data provided.
2. **Privacy**: We are committed to protecting your privacy. Please review our Privacy Policy to understand our practices regarding personal data.
3. **Service Availability**: We aim to keep the App available at all times but do not guarantee uninterrupted access. We may also modify or discontinue the App or any features without notice.

## Disclaimer and Limitation of Liability
1. **No Emergency Services**: The App is not a replacement for emergency services. In the event of an emergency, contact your local emergency services immediately.
2. **Use at Your Own Risk**: You use the App at your own risk. We are not liable for any direct, indirect, incidental, or consequential damages arising out of your use of the App.
3. **No Warranties**: The App is provided "as is" and "as available," without any warranties of any kind, either express or implied.

## Modifications to Terms
We reserve the right to modify these Terms of Use at any time. Any changes will be posted within the App, and your continued use of the App constitutes acceptance of the modified terms.

## Contact Information
If you have any questions about these Terms of Use, please contact us at [Contact Information].

## Termination
1. **Termination by You**: You may stop using the App at any time and may delete your account by following the instructions within the App.
2. **Termination by Us**: We reserve the right to suspend or terminate your access to the App at our sole discretion, without notice, for conduct that we believe violates these Terms of Use or is harmful to other users of the App, us, or third parties, or for any other reason.

## Governing Law
These Terms of Use and any disputes arising out of or related to them will be governed by and construed in accordance with the laws of [Your Country/State], without giving effect to its conflict of laws provisions.

## Dispute Resolution
1. **Informal Resolution**: We encourage you to contact us first to seek a resolution of any dispute by providing notice to [Contact Information].
2. **Arbitration**: If we cannot resolve the dispute informally, you agree to resolve any claim, dispute, or controversy arising out of or in connection with or relating to these Terms of Use by binding arbitration by the [Arbitration Association], rather than in court, except for matters that may be taken to small claims court.

## Severability
If any provision of these Terms of Use is found to be invalid or unenforceable, the remaining provisions will remain in full force and effect.

## Entire Agreement
These Terms of Use, together with our Privacy Policy and any other legal notices published by us on the App, constitute the entire agreement between you and [App Name] concerning your use of the App.

## No Waiver
Our failure to enforce any right or provision of these Terms of Use will not be considered a waiver of those rights.

## Assignment
We may assign or transfer our rights and obligations under these Terms of Use without restriction. You may not assign or transfer your rights or obligations under these Terms of Use without our prior written consent.

## Updates to Terms of Use
We may update these Terms of Use from time to time. When we do, we will revise the "last updated" date at the top of these Terms of Use. It is your responsibility to review these Terms of Use periodically. Your continued use of the App after any such changes constitutes your acceptance of the new Terms of Use.

## Contact Us
If you have any questions or concerns about these Terms of Use, please contact us at:

company@gmail.com
address@gmail.com
Homs/Syria  
0000000000 
''';
