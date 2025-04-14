import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onCreateFusion;
  final VoidCallback onMyFusions;
  final VoidCallback onSettings;

  const HomeScreen({
    Key? key,
    required this.onCreateFusion,
    required this.onMyFusions,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Main content
            Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: onSettings,
                        color: AppTheme.secondaryColor,
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // App logo
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: AppTheme.fusionGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // App title
                            const Text(
                              "Anime Fusion",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryTextColor,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // App subtitle
                            Text(
                              "Create unique character fusions",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                            
                            const SizedBox(height: 64),
                            
                            // Create fusion button
                            CustomButton(
                              text: "Create Fusion",
                              onPressed: onCreateFusion,
                              isPrimary: true,
                              isFullWidth: true,
                              isGradient: true,
                              icon: Icons.auto_awesome,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // My fusions button
                            CustomButton(
                              text: "My Fusions",
                              onPressed: onMyFusions,
                              isPrimary: false,
                              isFullWidth: true,
                              icon: Icons.collections_bookmark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
