import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';

class CharacterSelectionProvider extends ChangeNotifier {
  List<Character> _allCharacters = [];
  List<String> _allSeries = [];
  
  Character? _selectedCharacter1;
  Character? _selectedCharacter2;
  
  String _searchQuery1 = '';
  String _searchQuery2 = '';
  
  String? _selectedSeries1;
  String? _selectedSeries2;
  
  bool _isLoading = true;
  String? _error;

  // Getters
  List<Character> get allCharacters => _allCharacters;
  List<String> get allSeries => _allSeries;
  
  Character? get selectedCharacter1 => _selectedCharacter1;
  Character? get selectedCharacter2 => _selectedCharacter2;
  
  String get searchQuery1 => _searchQuery1;
  String get searchQuery2 => _searchQuery2;
  
  String? get selectedSeries1 => _selectedSeries1;
  String? get selectedSeries2 => _selectedSeries2;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  bool get canGenerateFusion => _selectedCharacter1 != null && _selectedCharacter2 != null;
  
  // Filtered characters based on search and series filters
  List<Character> getFilteredCharacters1() {
    return _getFilteredCharacters(_searchQuery1, _selectedSeries1);
  }
  
  List<Character> getFilteredCharacters2() {
    return _getFilteredCharacters(_searchQuery2, _selectedSeries2);
  }
  
  List<Character> _getFilteredCharacters(String query, String? series) {
    var filteredList = _allCharacters;
    
    // Apply series filter if selected
    if (series != null) {
      filteredList = filteredList.where((character) => character.series == series).toList();
    }
    
    // Apply search filter if query is not empty
    if (query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      filteredList = filteredList.where((character) {
        return character.name.toLowerCase().contains(lowercaseQuery) ||
               character.series.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    
    return filteredList;
  }
  
  // Initialize and load characters
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await CharacterService.loadCharacters();
      _allCharacters = CharacterService.getAllCharacters();
      _allSeries = CharacterService.getAllSeries();
      
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load characters: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Methods to update state
  void setSearchQuery1(String query) {
    _searchQuery1 = query;
    notifyListeners();
  }
  
  void setSearchQuery2(String query) {
    _searchQuery2 = query;
    notifyListeners();
  }
  
  void setSelectedSeries1(String? series) {
    _selectedSeries1 = series;
    notifyListeners();
  }
  
  void setSelectedSeries2(String? series) {
    _selectedSeries2 = series;
    notifyListeners();
  }
  
  void selectCharacter1(Character? character) {
    _selectedCharacter1 = character;
    notifyListeners();
  }
  
  void selectCharacter2(Character? character) {
    _selectedCharacter2 = character;
    notifyListeners();
  }
  
  void clearSelection1() {
    _selectedCharacter1 = null;
    notifyListeners();
  }
  
  void clearSelection2() {
    _selectedCharacter2 = null;
    notifyListeners();
  }
  
  void clearAllFilters() {
    _searchQuery1 = '';
    _searchQuery2 = '';
    _selectedSeries1 = null;
    _selectedSeries2 = null;
    notifyListeners();
  }
  
  // Reset all selections and filters
  void reset() {
    _selectedCharacter1 = null;
    _selectedCharacter2 = null;
    _searchQuery1 = '';
    _searchQuery2 = '';
    _selectedSeries1 = null;
    _selectedSeries2 = null;
    notifyListeners();
  }
}
