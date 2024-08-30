import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FairSafetyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> safetyTips = [
    {
      'title': 'General Safety Tips',
      'tips': [
        'Stay Hydrated',
        'Wear Comfortable Clothing',
        'Use Sunscreen',
        'Stay Together',
        'Keep Personal Belongings Secure',
      ],
    },
    {
      'title': 'Fire Safety Tips',
      'tips': [
        'Know the Layout',
        'Plan Meeting Points',
        'Stay Aware of Exits',
        'Avoid Overcrowded Areas',
        'Follow Instructions',
      ],
    },
    {
      'title': 'Fire Prevention Tips',
      'tips': [
        'No Smoking Areas',
        'Report Hazards',
        'Be Careful with Flammable Materials',
      ],
    },
    {
      'title': 'In Case of Fire',
      'tips': [
        'Stay Calm',
        'Evacuate Immediately',
        'Cover Your Nose and Mouth',
        'Stay Low',
        'Use Exits',
        'Follow Emergency Personnel',
      ],
    },
    {
      'title': 'After Evacuating',
      'tips': [
        'Go to the Meeting Point',
        'Seek Medical Attention',
        'Stay Informed',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fair Safety Tips'),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },),

      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: safetyTips.length,
        itemBuilder: (context, index) {
          return SafetyCard(
            title: safetyTips[index]['title'],
            tips: safetyTips[index]['tips'],
          );
        },
      ),
    );
  }
}

class SafetyCard extends StatelessWidget {
  final String title;
  final List<String> tips;

  SafetyCard({required this.title, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}