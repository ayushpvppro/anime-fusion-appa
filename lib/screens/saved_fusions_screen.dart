import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';

class SavedFusionsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onFusionTap;

  const SavedFusionsScreen({
    Key? key,
    required this.onBack,
    required this.onFusionTap,
  }) : super(key: key);

  @override
  State<SavedFusionsScreen> createState() => _SavedFusionsScreenState();
}

class _SavedFusionsScreenState extends State<SavedFusionsScreen> {
  // Dummy data for demonstration
  final List<Map<String, dynamic>> _savedFusions = [
    {
      'id': '1',
      'name': 'Naruto Uchiha',
      'imageUrl': 'https://example.com/naruto_sasuke.jpg',
      'parentCharacters': ['Naruto Uzumaki', 'Sasuke Uchiha'],
      'abilities': ['Shadow Clone Jutsu', 'Sharingan', 'Rasengan', 'Chidori'],
      'date': '2025-04-10',
    },
    {
      'id': '2',
      'name': 'Gokugeta',
      'imageUrl': 'https://example.com/goku_vegeta.jpg',
      'parentCharacters': ['Goku', 'Vegeta'],
      'abilities': ['Kamehameha', 'Final Flash', 'Super Saiyan', 'Spirit Bomb'],
      'date': '2025-04-11',
    },
    {
      'id': '3',
      'name': 'Lufforo',
      'imageUrl': 'https://example.com/luffy_zoro.jpg',
      'parentCharacters': ['Luffy', 'Zoro'],
      'abilities': ['Gomu Gomu no Mi', 'Three Sword Style', 'Haki'],
      'date': '2025-04-12',
    },
  ];

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
      body: _savedFusions.isEmpty
          ? _buildEmptyState()
          : _buildFusionsList(),
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
              itemCount: _savedFusions.length,
              itemBuilder: (context, index) {
                final fusion = _savedFusions[index];
                return _buildFusionCard(fusion);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFusionCard(Map<String, dynamic> fusion) {
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
              child: Container(
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
                fusion['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Parent characters
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                fusion['parentCharacters'].join(' + '),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Date
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppTheme.secondaryTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fusion['date'],
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.secondaryTextColor,
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
}
