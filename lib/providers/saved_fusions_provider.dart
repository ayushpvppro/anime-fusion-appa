import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/services/saved_fusion_service.dart';

class SavedFusionsProvider extends ChangeNotifier {
  List<Character> _savedFusions = [];
  Map<String, Uint8List?> _fusionImages = {};
  
  bool _isLoading = true;
  String? _error;
  
  // Getters
  List<Character> get savedFusions => _savedFusions;
  Map<String, Uint8List?> get fusionImages => _fusionImages;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Initialize and load saved fusions
  Future<void> initialize() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Load saved fusions
      _savedFusions = await SavedFusionService.getSavedFusions();
      
      // Load fusion images
      _fusionImages = {};
      for (final fusion in _savedFusions) {
        final image = await SavedFusionService.getFusionImage(fusion.id);
        _fusionImages[fusion.id] = image;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load saved fusions: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Save a fusion
  Future<bool> saveFusion(Character fusion, Uint8List? fusionImage) async {
    try {
      final success = await SavedFusionService.saveFusion(fusion, fusionImage);
      
      if (success) {
        // Update local state
        final existingIndex = _savedFusions.indexWhere((f) => f.id == fusion.id);
        if (existingIndex >= 0) {
          _savedFusions[existingIndex] = fusion;
        } else {
          _savedFusions.add(fusion);
        }
        
        _fusionImages[fusion.id] = fusionImage;
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to save fusion: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Delete a fusion
  Future<bool> deleteFusion(String fusionId) async {
    try {
      final success = await SavedFusionService.deleteFusion(fusionId);
      
      if (success) {
        // Update local state
        _savedFusions.removeWhere((f) => f.id == fusionId);
        _fusionImages.remove(fusionId);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to delete fusion: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Get fusion image
  Uint8List? getFusionImage(String fusionId) {
    return _fusionImages[fusionId];
  }
  
  // Check if fusion exists
  bool hasFusion(String fusionId) {
    return _savedFusions.any((f) => f.id == fusionId);
  }
}
