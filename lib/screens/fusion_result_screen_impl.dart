import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/providers/fusion_provider.dart';

class FusionResultScreenImpl extends StatefulWidget {
  final Character character1;
  final Character character2;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onNewFusion;
  final VoidCallback onBack;

  const FusionResultScreenImpl({
    Key? key,
    required this.character1,
    required this.character2,
    required this.onSave,
    required this.onShare,
    required this.onNewFusion,
    required this.onBack,
  }) : super(key: key);

  @override
  State<FusionResultScreenImpl> createState() => _FusionResultScreenImplState();
}

class _FusionResultScreenImplState extends State<FusionResultScreenImpl> with SingleTickerProviderStateMixin {
  final FusionProvider _fusionProvider = FusionProvider();
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // Set up animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start fusion generation
    _generateFusion();
  }
  
  Future<void> _generateFusion() async {
    // Set parent characters
    _fusionProvider.setParentCharacters(widget.character1, widget.character2);
    
    // Start animation
    _animationController.forward();
    
    // Generate fusion after a short delay for animation effect
    Future.delayed(const Duration(milliseconds: 1000), () {
      _fusionProvider.generateFusion();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          onPressed: widget.onBack,
        ),
      ),
      body: AnimatedBuilder(
        animation: _fusionProvider,
        builder: (context, _) {
          if (_fusionProvider.isGenerating) {
            return _buildFusionAnimation();
          } else if (_fusionProvider.error != null) {
            return _buildErrorState();
          } else if (_fusionProvider.fusionResult != null) {
            return _buildFusionResult();
          } else {
            return _buildFusionAnimation();
          }
        },
      ),
    );
  }
  
  Widget _buildFusionAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Parent characters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildParentCharacter(widget.character1),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                AppTheme.primaryColor,
                                AppTheme.secondaryColor,
                                _animation.value,
                              ),
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
                            color: Color.lerp(
                              AppTheme.primaryColor,
                              AppTheme.secondaryColor,
                              _animation.value,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: _buildParentCharacter(widget.character2),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Fusion animation
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.secondaryColor.withOpacity(0.8),
                        _animation.value,
                      )!,
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 64 * _animation.value,
                    color: AppTheme.lightTextColor,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Loading text
          const Text(
            'Generating Fusion...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Loading indicator
          const CircularProgressIndicator(
            color: AppTheme.secondaryColor,
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
            _fusionProvider.error ?? 'An unknown error occurred',
            style: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Try Again',
            onPressed: _generateFusion,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildFusionResult() {
    final fusion = _fusionProvider.fusionResult!;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Parent characters
            Row(
              children: [
                Expanded(
                  child: _buildParentCharacter(widget.character1),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.fusionGradient,
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
                        color: AppTheme.secondaryColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildParentCharacter(widget.character2),
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
            
            // Fusion result
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fusion result header with gradient
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppTheme.fusionGradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: AppTheme.lightTextColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "FUSION COMPLETE",
                          style: TextStyle(
                            color: AppTheme.lightTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Character image
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _fusionProvider.fusionImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(
                              _fusionProvider.fusionImage!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppTheme.secondaryColor,
                              size: 64,
                            ),
                          ),
                  ),
                  
                  // Character name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      fusion.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Character series
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      fusion.series,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Character description
                  if (fusion.description != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        fusion.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryTextColor,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Abilities section
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.secondaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Abilities",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...fusion.abilities.map((ability) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppTheme.accentColor1,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ability,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Save",
                            icon: Icons.save,
                            onPressed: widget.onSave,
                            isPrimary: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: "Share",
                            icon: Icons.share,
                            onPressed: widget.onShare,
                            isPrimary: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Create new fusion button
            CustomButton(
              text: "Create New Fusion",
              onPressed: widget.onNewFusion,
              isPrimary: true,
              isFullWidth: true,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildParentCharacter(Character character) {
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
            character.name,
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
            character.series,
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
