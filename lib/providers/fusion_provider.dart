import 'dart:io';
import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/services/fusion_service.dart';
import 'package:anime_fusion_app/services/visual_fusion_service.dart';
import 'package:path_provider/path_provider.dart';

class FusionProvider extends ChangeNotifier {
  Character? _character1;
  Character? _character2;
  Character? _fusionResult;
  
  bool _isGenerating = false;
  String? _error;
  
  // Image data
  Uint8List? _fusionImage;
  
  // Getters
  Character? get character1 => _character1;
  Character? get character2 => _character2;
  Character? get fusionResult => _fusionResult;
  
  bool get isGenerating => _isGenerating;
  String? get error => _error;
  
  Uint8List? get fusionImage => _fusionImage;
  
  // Set parent characters
  void setParentCharacters(Character char1, Character char2) {
    _character1 = char1;
    _character2 = char2;
    _fusionResult = null;
    _fusionImage = null;
    _error = null;
    notifyListeners();
  }
  
  // Generate fusion
  Future<void> generateFusion() async {
    if (_character1 == null || _character2 == null) {
      _error = 'Two characters must be selected to generate a fusion';
      notifyListeners();
      return;
    }
    
    try {
      _isGenerating = true;
      _error = null;
      notifyListeners();
      
      // Generate fusion character
      final fusion = FusionService.generateFusion(_character1!, _character2!);
      
      // Generate visual fusion
      final visualFusion = await VisualFusionService.generateVisualFusion(_character1!, _character2!);
      
      // Update state
      _fusionResult = fusion;
      _fusionImage = visualFusion;
      _isGenerating = false;
      notifyListeners();
    } catch (e) {
      _isGenerating = false;
      _error = 'Failed to generate fusion: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Save fusion
  Future<bool> saveFusion() async {
    if (_fusionResult == null) {
      _error = 'No fusion to save';
      notifyListeners();
      return false;
    }
    
    try {
      // Save fusion character data
      await FusionService.saveFusion(_fusionResult!);
      
      // Save fusion image if available
      if (_fusionImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/fusions/${_fusionResult!.id}.png';
        
        // Ensure directory exists
        final imageDir = Directory('${directory.path}/fusions');
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }
        
        // Write image file
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(_fusionImage!);
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to save fusion: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Reset
  void reset() {
    _character1 = null;
    _character2 = null;
    _fusionResult = null;
    _fusionImage = null;
    _error = null;
    _isGenerating = false;
    notifyListeners();
  }
}
