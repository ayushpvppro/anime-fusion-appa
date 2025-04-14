import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AppIconGenerator {
  static Future<Uint8List> generateAppIcon() async {
    // Create a canvas to draw on
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Define canvas size (512x512 for app icon)
    const size = Size(512, 512);
    
    // Draw background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF5252),
          const Color(0xFF6C63FF),
        ],
        center: Alignment.topLeft,
        radius: 1.5,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    
    // Draw fusion symbol
    final symbolPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24;
    
    // Draw star shape
    final center = Offset(size.width / 2, size.height / 2);
    const points = 8;
    const innerRadius = 80.0;
    const outerRadius = 180.0;
    
    final path = Path();
    
    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = i * 3.14159 / points;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, symbolPaint);
    
    // Draw center circle
    canvas.drawCircle(
      center,
      60,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    
    // Convert canvas to image
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    
    return Uint8List.view(pngBytes!.buffer);
  }
}
