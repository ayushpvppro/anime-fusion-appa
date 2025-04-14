import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final IconData? icon;
  final bool isGradient;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = false,
    this.icon,
    this.isGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.lightTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: AppTheme.secondaryColor,
            side: const BorderSide(color: AppTheme.secondaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );

    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (isGradient) {
      return Container(
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          gradient: AppTheme.fusionGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppTheme.lightTextColor,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: buttonContent,
        ),
      );
    } else {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        child: isPrimary
            ? ElevatedButton(
                onPressed: onPressed,
                style: buttonStyle,
                child: buttonContent,
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: buttonStyle,
                child: buttonContent,
              ),
      );
    }
  }
}

class CharacterCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onTap;
  final bool isSelected;

  const CharacterCard({
    Key? key,
    required this.name,
    this.imageUrl,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppTheme.secondaryColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: AppTheme.secondaryColor, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppTheme.secondaryColor,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 120,
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.secondaryColor,
                        size: 48,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppTheme.secondaryColor
                      : AppTheme.primaryTextColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.secondaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FusionResultCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final List<String> abilities;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const FusionResultCard({
    Key? key,
    required this.name,
    this.imageUrl,
    required this.abilities,
    required this.onSave,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: 200,
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppTheme.secondaryColor,
                            size: 64,
                          ),
                        );
                      },
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
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
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
                ...abilities.map((ability) => Padding(
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
                    onPressed: onSave,
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: "Share",
                    icon: Icons.share,
                    onPressed: onShare,
                    isPrimary: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final VoidCallback? onClear;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText = "Search...",
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.secondaryColor,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.secondaryTextColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) {
                      onClear!();
                    } else {
                      onChanged('');
                    }
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class AnimatedFusionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AnimatedFusionButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  State<AnimatedFusionButton> createState() => _AnimatedFusionButtonState();
}

class _AnimatedFusionButtonState extends State<AnimatedFusionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.fusionGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.lightTextColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: AppTheme.lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
