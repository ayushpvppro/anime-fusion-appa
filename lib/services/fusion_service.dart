import 'dart:math';
import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';

class FusionService {
  // Generate a fusion character from two parent characters
  static Character generateFusion(Character character1, Character character2) {
    // Generate fusion name
    final fusionName = _generateFusionName(character1.name, character2.name);
    
    // Combine abilities
    final fusionAbilities = _combineAbilities(character1.abilities, character2.abilities);
    
    // Create fusion description
    final fusionDescription = _generateFusionDescription(character1, character2);
    
    // In a real app, we would generate or combine images here
    // For now, we'll use a placeholder URL
    final imageUrl = null; // In production, this would be a generated image URL
    
    // Create and return the fusion character
    return Character(
      id: 'fusion_${character1.id}_${character2.id}_${DateTime.now().millisecondsSinceEpoch}',
      name: fusionName,
      series: '${character1.series} × ${character2.series}',
      imageUrl: imageUrl,
      abilities: fusionAbilities,
      description: fusionDescription,
    );
  }
  
  // Generate a fusion name by combining parts of both character names
  static String _generateFusionName(String name1, String name2) {
    // Split names into parts
    final parts1 = name1.split(' ');
    final parts2 = name2.split(' ');
    
    // Get first names
    final firstName1 = parts1.first;
    final firstName2 = parts2.first;
    
    // Simple fusion: take first half of first name and second half of second name
    final midpoint1 = (firstName1.length / 2).ceil();
    final midpoint2 = (firstName2.length / 2).floor();
    
    final firstPart = firstName1.substring(0, midpoint1);
    final secondPart = firstName2.substring(midpoint2);
    
    final fusedFirstName = firstPart + secondPart;
    
    // If both characters have last names, use one of them
    String fusedLastName = '';
    if (parts1.length > 1 && parts2.length > 1) {
      // Randomly choose one of the last names
      fusedLastName = Random().nextBool() ? parts1.last : parts2.last;
    } else if (parts1.length > 1) {
      fusedLastName = parts1.last;
    } else if (parts2.length > 1) {
      fusedLastName = parts2.last;
    }
    
    // Combine the fused first name with the chosen last name
    return fusedLastName.isEmpty ? fusedFirstName : '$fusedFirstName $fusedLastName';
  }
  
  // Combine abilities from both characters
  static List<String> _combineAbilities(List<String> abilities1, List<String> abilities2) {
    // Create a set to avoid duplicates
    final abilitySet = <String>{};
    
    // Add core abilities from both characters (up to 2 from each)
    final coreAbilities1 = abilities1.take(min(2, abilities1.length)).toList();
    final coreAbilities2 = abilities2.take(min(2, abilities2.length)).toList();
    
    abilitySet.addAll(coreAbilities1);
    abilitySet.addAll(coreAbilities2);
    
    // Create 1-2 fusion abilities by combining existing ones
    if (abilities1.isNotEmpty && abilities2.isNotEmpty) {
      // Take a random ability from each character
      final randomAbility1 = abilities1[Random().nextInt(abilities1.length)];
      final randomAbility2 = abilities2[Random().nextInt(abilities2.length)];
      
      // Create a fusion ability name
      final fusionAbility = _createFusionAbility(randomAbility1, randomAbility2);
      abilitySet.add(fusionAbility);
      
      // 50% chance to create a second fusion ability
      if (Random().nextBool() && abilities1.length > 1 && abilities2.length > 1) {
        // Get different abilities for the second fusion
        var secondAbility1 = randomAbility1;
        var secondAbility2 = randomAbility2;
        
        while (secondAbility1 == randomAbility1 && abilities1.length > 1) {
          secondAbility1 = abilities1[Random().nextInt(abilities1.length)];
        }
        
        while (secondAbility2 == randomAbility2 && abilities2.length > 1) {
          secondAbility2 = abilities2[Random().nextInt(abilities2.length)];
        }
        
        final secondFusionAbility = _createFusionAbility(secondAbility1, secondAbility2);
        abilitySet.add(secondFusionAbility);
      }
    }
    
    // Convert set back to list and return
    return abilitySet.toList();
  }
  
  // Create a fusion ability by combining two abilities
  static String _createFusionAbility(String ability1, String ability2) {
    // Different combination strategies
    final strategy = Random().nextInt(3);
    
    switch (strategy) {
      case 0:
        // Combine words from both abilities
        final words1 = ability1.split(' ');
        final words2 = ability2.split(' ');
        
        if (words1.length > 1 && words2.length > 1) {
          return '${words1.first} ${words2.last}';
        } else {
          // If simple abilities, just join them
          return '$ability1-$ability2 Fusion';
        }
      
      case 1:
        // Use "X-infused Y" format
        return '$ability1-infused $ability2';
      
      case 2:
      default:
        // Use "Ultimate X" or "Super X" format
        final baseAbility = Random().nextBool() ? ability1 : ability2;
        final prefix = ['Ultimate', 'Super', 'Mega', 'Hyper', 'Fusion'][Random().nextInt(5)];
        return '$prefix $baseAbility';
    }
  }
  
  // Generate a description for the fusion character
  static String _generateFusionDescription(Character character1, Character character2) {
    final templates = [
      'A powerful fusion of ${character1.name} and ${character2.name}, combining the best traits of both characters.',
      'Born from the fusion of ${character1.name} and ${character2.name}, this character possesses extraordinary abilities from both worlds.',
      'The ultimate combination of ${character1.name} and ${character2.name}, with powers beyond imagination.',
      'A perfect blend of ${character1.series} and ${character2.series}, this fusion character embodies the strengths of ${character1.name} and ${character2.name}.',
      'Neither fully ${character1.name} nor ${character2.name}, but a unique entity with the powers of both.'
    ];
    
    return templates[Random().nextInt(templates.length)];
  }
  
  // Save a fusion to persistent storage
  static Future<void> saveFusion(Character fusion) async {
    // In a real app, this would save to a database or file
    // For this prototype, we'll just print to console
    print('Saved fusion: ${fusion.name}');
    
    // TODO: Implement actual storage in a later step
  }
  
  // Get all saved fusions
  static Future<List<Character>> getSavedFusions() async {
    // In a real app, this would load from a database or file
    // For this prototype, we'll return an empty list
    // TODO: Implement actual storage in a later step
    return [];
  }
}
