import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';

class FusionResultScreen extends StatelessWidget {
  final Map<String, dynamic> character1;
  final Map<String, dynamic> character2;
  final Map<String, dynamic> fusionResult;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onNewFusion;
  final VoidCallback onBack;

  const FusionResultScreen({
    Key? key,
    required this.character1,
    required this.character2,
    required this.fusionResult,
    required this.onSave,
    required this.onShare,
    required this.onNewFusion,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Fusion Result'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.lightTextColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Parent characters
              Row(
                children: [
                  Expanded(
                    child: _buildParentCharacter(character1),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppTheme.lightTextColor,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildParentCharacter(character2),
                  ),
                ],
              ),
              
              // Fusion arrow
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppTheme.fusionGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: AppTheme.lightTextColor,
                  size: 32,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Fusion result card
              FusionResultCard(
                name: fusionResult['name'],
                imageUrl: fusionResult['imageUrl'],
                abilities: List<String>.from(fusionResult['abilities']),
                onSave: onSave,
                onShare: onShare,
              ),
              
              const SizedBox(height: 24),
              
              // Create new fusion button
              CustomButton(
                text: "Create New Fusion",
                onPressed: onNewFusion,
                isPrimary: true,
                isFullWidth: true,
                icon: Icons.refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildParentCharacter(Map<String, dynamic> character) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: AppTheme.secondaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                color: AppTheme.secondaryColor,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            character['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            character['series'],
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
