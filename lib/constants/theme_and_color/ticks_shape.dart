// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
//
// class CustomTickShape extends SfTickShape {
//   final Color tickColor;
//
//   CustomTickShape({required this.tickColor});
//
//   @override
//   void paint(
//       PaintingContext context,
//       Offset center,
//       Offset? thumbCenter,
//       Offset? startThumbCenter,
//       Offset? endThumbCenter, {
//         dynamic currentValue,
//         SfRangeValues? currentValues,
//         required Animation<double> enableAnimation,
//         required RenderBox parentBox,
//         required TextDirection textDirection,
//         required SfSliderThemeData themeData, // Required parameter
//       }) {
//     final Paint paint = Paint()
//       ..color = tickColor // Set the custom tick color
//       ..strokeWidth = 2;
//
//     // Draw the tick
//     context.canvas.drawLine(
//       Offset(center.dx, center.dy - 4),
//       Offset(center.dx, center.dy + 4),
//       paint,
//     );
//   }
//
//   @override
//   Size getPreferredSize(bool isVertical, RenderBox parentBox) {
//     return const Size(1.0, 8.0); // Set the tick size
//   }
// }
