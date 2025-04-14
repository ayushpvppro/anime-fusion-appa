import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class SharingService {
  // Share fusion with image
  static Future<void> shareFusion(String fusionName, Uint8List? fusionImage) async {
    try {
      String shareText = 'Check out my anime fusion: $fusionName!';
      
      if (fusionImage != null) {
        // Save image to temporary file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/fusion_share.png');
        await file.writeAsBytes(fusionImage);
        
        // Share with image
        await Share.shareXFiles(
          [XFile(file.path)],
          text: shareText,
        );
      } else {
        // Share text only
        await Share.share(shareText);
      }
    } catch (e) {
      print('Error sharing fusion: $e');
      rethrow;
    }
  }
}
