import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/screens/home_screen.dart';
import 'package:anime_fusion_app/screens/character_selection_screen_impl.dart';
import 'package:anime_fusion_app/screens/fusion_result_screen_impl.dart';
import 'package:anime_fusion_app/screens/saved_fusions_screen_impl.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/services/fusion_service.dart';
import 'package:anime_fusion_app/services/sharing_service.dart';
import 'package:anime_fusion_app/providers/fusion_provider.dart';

void main() {
  runApp(const AnimeFusionApp());
}

class AnimeFusionApp extends StatelessWidget {
  const AnimeFusionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Fusion Generator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final FusionProvider _fusionProvider = FusionProvider();
  
  // Navigation state
  int _currentIndex = 0;
  
  // Selected characters for fusion
  Character? _selectedCharacter1;
  Character? _selectedCharacter2;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Initialize character service
    await CharacterService.loadCharacters();
  }
  
  void _navigateToHome() {
    setState(() {
      _currentIndex = 0;
      _selectedCharacter1 = null;
      _selectedCharacter2 = null;
    });
  }
  
  void _navigateToCharacterSelection() {
    setState(() {
      _currentIndex = 1;
    });
  }
  
  void _navigateToFusionResult(Character char1, Character char2) {
    setState(() {
      _selectedCharacter1 = char1;
      _selectedCharacter2 = char2;
      _currentIndex = 2;
    });
  }
  
  void _navigateToSavedFusions() {
    setState(() {
      _currentIndex = 3;
    });
  }
  
  void _navigateToSettings() {
    // Not implemented in this version
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings will be available in a future update'),
      ),
    );
  }
  
  Future<void> _saveFusion() async {
    if (_fusionProvider.fusionResult != null) {
      final success = await _fusionProvider.saveFusion();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fusion saved successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_fusionProvider.error ?? 'Failed to save fusion'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _shareFusion() async {
    if (_fusionProvider.fusionResult != null) {
      try {
        await SharingService.shareFusion(
          _fusionProvider.fusionResult!.name,
          _fusionProvider.fusionImage,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share fusion: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildCurrentScreen();
  }
  
  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          onCreateFusion: _navigateToCharacterSelection,
          onMyFusions: _navigateToSavedFusions,
          onSettings: _navigateToSettings,
        );
      
      case 1:
        return CharacterSelectionScreenImpl(
          onFusionGenerate: _navigateToFusionResult,
          onBack: _navigateToHome,
        );
      
      case 2:
        if (_selectedCharacter1 == null || _selectedCharacter2 == null) {
          return HomeScreen(
            onCreateFusion: _navigateToCharacterSelection,
            onMyFusions: _navigateToSavedFusions,
            onSettings: _navigateToSettings,
          );
        }
        
        return FusionResultScreenImpl(
          character1: _selectedCharacter1!,
          character2: _selectedCharacter2!,
          onSave: _saveFusion,
          onShare: _shareFusion,
          onNewFusion: _navigateToCharacterSelection,
          onBack: _navigateToCharacterSelection,
        );
      
      case 3:
        return SavedFusionsScreenImpl(
          onBack: _navigateToHome,
          onFusionTap: (fusion) {
            // View fusion details (not implemented in this version)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fusion details will be available in a future update'),
              ),
            );
          },
        );
      
      default:
        return HomeScreen(
          onCreateFusion: _navigateToCharacterSelection,
          onMyFusions: _navigateToSavedFusions,
          onSettings: _navigateToSettings,
        );
    }
  }
}
