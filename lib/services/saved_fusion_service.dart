import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:path_provider/path_provider.dart';

class SavedFusionService {
  static const String _savedFusionsFileName = 'saved_fusions.json';
  
  // Save a fusion to persistent storage
  static Future<bool> saveFusion(Character fusion, Uint8List? fusionImage) async {
    try {
      // Get saved fusions
      final savedFusions = await getSavedFusions();
      
      // Check if fusion already exists
      final existingIndex = savedFusions.indexWhere((f) => f.id == fusion.id);
      if (existingIndex >= 0) {
        // Replace existing fusion
        savedFusions[existingIndex] = fusion;
      } else {
        // Add new fusion
        savedFusions.add(fusion);
      }
      
      // Save fusions data
      await _saveFusionsToFile(savedFusions);
      
      // Save fusion image if available
      if (fusionImage != null) {
        await _saveFusionImage(fusion.id, fusionImage);
      }
      
      return true;
    } catch (e) {
      print('Error saving fusion: $e');
      return false;
    }
  }
  
  // Get all saved fusions
  static Future<List<Character>> getSavedFusions() async {
    try {
      final file = await _getSavedFusionsFile();
      
      if (!await file.exists()) {
        return [];
      }
      
      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List;
      
      return jsonList.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      print('Error getting saved fusions: $e');
      return [];
    }
  }
  
  // Delete a saved fusion
  static Future<bool> deleteFusion(String fusionId) async {
    try {
      // Get saved fusions
      final savedFusions = await getSavedFusions();
      
      // Remove fusion
      savedFusions.removeWhere((f) => f.id == fusionId);
      
      // Save updated list
      await _saveFusionsToFile(savedFusions);
      
      // Delete fusion image if exists
      await _deleteFusionImage(fusionId);
      
      return true;
    } catch (e) {
      print('Error deleting fusion: $e');
      return false;
    }
  }
  
  // Get fusion image
  static Future<Uint8List?> getFusionImage(String fusionId) async {
    try {
      final imageFile = await _getFusionImageFile(fusionId);
      
      if (!await imageFile.exists()) {
        return null;
      }
      
      return await imageFile.readAsBytes();
    } catch (e) {
      print('Error getting fusion image: $e');
      return null;
    }
  }
  
  // Private helper methods
  
  // Get the file for saved fusions
  static Future<File> _getSavedFusionsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_savedFusionsFileName');
  }
  
  // Save fusions to file
  static Future<void> _saveFusionsToFile(List<Character> fusions) async {
    final file = await _getSavedFusionsFile();
    final jsonList = fusions.map((f) => f.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
  
  // Get fusion image file
  static Future<File> _getFusionImageFile(String fusionId) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${directory.path}/fusion_images');
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    
    return File('${imagesDir.path}/$fusionId.png');
  }
  
  // Save fusion image
  static Future<void> _saveFusionImage(String fusionId, Uint8List imageData) async {
    final imageFile = await _getFusionImageFile(fusionId);
    await imageFile.writeAsBytes(imageData);
  }
  
  // Delete fusion image
  static Future<void> _deleteFusionImage(String fusionId) async {
    final imageFile = await _getFusionImageFile(fusionId);
    
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }
}
