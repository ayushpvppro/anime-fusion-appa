import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/providers/saved_fusions_provider.dart';

class SavedFusionsScreenImpl extends StatefulWidget {
  final VoidCallback onBack;
  final Function(Character) onFusionTap;

  const SavedFusionsScreenImpl({
    Key? key,
    required this.onBack,
    required this.onFusionTap,
  }) : super(key: key);

  @override
  State<SavedFusionsScreenImpl> createState() => _SavedFusionsScreenImplState();
}

class _SavedFusionsScreenImplState extends State<SavedFusionsScreenImpl> {
  final SavedFusionsProvider _provider = SavedFusionsProvider();
  
  @override
  void initState() {
    super.initState();
    _loadSavedFusions();
  }
  
  Future<void> _loadSavedFusions() async {
    await _provider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Fusions'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.lightTextColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: AnimatedBuilder(
        animation: _provider,
        builder: (context, _) {
          if (_provider.isLoading) {
            return _buildLoadingState();
          } else if (_provider.error != null) {
            return _buildErrorState();
          } else if (_provider.savedFusions.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildFusionsList();
          }
        },
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.secondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'Loading saved fusions...',
            style: TextStyle(
              color: AppTheme.secondaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            _provider.error ?? 'An unknown error occurred',
            style: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Retry',
            onPressed: _loadSavedFusions,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.collections_bookmark,
            size: 80,
            color: AppTheme.secondaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Saved Fusions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first fusion to see it here',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Create Fusion',
            onPressed: widget.onBack,
            isPrimary: true,
            icon: Icons.auto_awesome,
          ),
        ],
      ),
    );
  }
  
  Widget _buildFusionsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Saved Fusions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _provider.savedFusions.length,
              itemBuilder: (context, index) {
                final fusion = _provider.savedFusions[index];
                final fusionImage = _provider.getFusionImage(fusion.id);
                return _buildFusionCard(fusion, fusionImage);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFusionCard(Character fusion, Uint8List? fusionImage) {
    return GestureDetector(
      onTap: () => widget.onFusionTap(fusion),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fusion image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: fusionImage != null
                  ? Image.memory(
                      fusionImage,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 120,
                      width: double.infinity,
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.secondaryColor,
                        size: 48,
                      ),
                    ),
            ),
            
            // Fusion name
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                fusion.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Fusion series
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                fusion.series,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Delete button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Abilities count
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppTheme.accentColor1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${fusion.abilities.length} abilities',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  
                  // Delete button
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(fusion),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteConfirmation(Character fusion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fusion'),
        content: Text('Are you sure you want to delete "${fusion.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _provider.deleteFusion(fusion.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
