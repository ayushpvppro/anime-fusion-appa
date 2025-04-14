import 'dart:convert';
import 'package:flutter/services.dart';

class Character {
  final String id;
  final String name;
  final String series;
  final String? imageUrl;
  final List<String> abilities;
  final String? description;

  Character({
    required this.id,
    required this.name,
    required this.series,
    this.imageUrl,
    required this.abilities,
    this.description,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      series: json['series'],
      imageUrl: json['imageUrl'],
      abilities: List<String>.from(json['abilities']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'series': series,
      'imageUrl': imageUrl,
      'abilities': abilities,
      'description': description,
    };
  }
}

class CharacterService {
  static List<Character> _characters = [];
  static List<String> _series = [];

  static Future<void> loadCharacters() async {
    try {
      // Load character data from assets
      final String response = await rootBundle.loadString('assets/data/characters.json');
      final data = await json.decode(response);
      
      _characters = List<Character>.from(
        data['characters'].map((x) => Character.fromJson(x))
      );
      
      // Extract unique series names
      final seriesSet = <String>{};
      for (var character in _characters) {
        seriesSet.add(character.series);
      }
      _series = seriesSet.toList()..sort();
      
    } catch (e) {
      // If loading from assets fails, use fallback data
      _characters = _getFallbackCharacters();
      
      // Extract unique series names from fallback data
      final seriesSet = <String>{};
      for (var character in _characters) {
        seriesSet.add(character.series);
      }
      _series = seriesSet.toList()..sort();
    }
  }

  static List<Character> getAllCharacters() {
    return _characters;
  }
  
  static List<String> getAllSeries() {
    return _series;
  }
  
  static List<Character> getCharactersBySeries(String series) {
    return _characters.where((character) => character.series == series).toList();
  }
  
  static List<Character> searchCharacters(String query) {
    if (query.isEmpty) {
      return _characters;
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _characters.where((character) {
      return character.name.toLowerCase().contains(lowercaseQuery) ||
             character.series.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  
  static Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Fallback data in case loading from assets fails
  static List<Character> _getFallbackCharacters() {
    return [
      Character(
        id: '1',
        name: 'Naruto Uzumaki',
        series: 'Naruto',
        imageUrl: 'https://example.com/naruto.jpg',
        abilities: ['Shadow Clone Jutsu', 'Rasengan', 'Sage Mode', 'Nine-Tails Chakra Mode'],
        description: 'The main protagonist of the Naruto series who dreams of becoming Hokage.',
      ),
      Character(
        id: '2',
        name: 'Sasuke Uchiha',
        series: 'Naruto',
        imageUrl: 'https://example.com/sasuke.jpg',
        abilities: ['Sharingan', 'Chidori', 'Amaterasu', 'Susanoo'],
        description: 'A survivor of the Uchiha clan and Naruto\'s rival.',
      ),
      Character(
        id: '3',
        name: 'Goku',
        series: 'Dragon Ball',
        imageUrl: 'https://example.com/goku.jpg',
        abilities: ['Kamehameha', 'Super Saiyan', 'Spirit Bomb', 'Instant Transmission'],
        description: 'A Saiyan warrior and the main protagonist of the Dragon Ball series.',
      ),
      Character(
        id: '4',
        name: 'Vegeta',
        series: 'Dragon Ball',
        imageUrl: 'https://example.com/vegeta.jpg',
        abilities: ['Final Flash', 'Super Saiyan', 'Galick Gun', 'Big Bang Attack'],
        description: 'The prince of the Saiyans and Goku\'s rival.',
      ),
      Character(
        id: '5',
        name: 'Luffy',
        series: 'One Piece',
        imageUrl: 'https://example.com/luffy.jpg',
        abilities: ['Gomu Gomu no Mi', 'Haki', 'Gear Fourth', 'Gear Fifth'],
        description: 'Captain of the Straw Hat Pirates who ate the Gum-Gum Fruit.',
      ),
      Character(
        id: '6',
        name: 'Zoro',
        series: 'One Piece',
        imageUrl: 'https://example.com/zoro.jpg',
        abilities: ['Three Sword Style', 'Haki', 'Asura', 'Flying Dragon Blaze'],
        description: 'The swordsman of the Straw Hat Pirates who uses three swords.',
      ),
      Character(
        id: '7',
        name: 'Ichigo Kurosaki',
        series: 'Bleach',
        imageUrl: 'https://example.com/ichigo.jpg',
        abilities: ['Zangetsu', 'Bankai', 'Hollow Form', 'Getsuga Tensho'],
        description: 'A human with Shinigami powers who protects the living world from Hollows.',
      ),
      Character(
        id: '8',
        name: 'Rukia Kuchiki',
        series: 'Bleach',
        imageUrl: 'https://example.com/rukia.jpg',
        abilities: ['Sode no Shirayuki', 'Kido', 'Bankai', 'Some no mai, Tsukishiro'],
        description: 'A Shinigami who transferred her powers to Ichigo.',
      ),
      Character(
        id: '9',
        name: 'Edward Elric',
        series: 'Fullmetal Alchemist',
        imageUrl: 'https://example.com/edward.jpg',
        abilities: ['Alchemy', 'Transmutation', 'Martial Arts', 'Automail Arm'],
        description: 'A young alchemist who lost his arm and leg in a failed human transmutation.',
      ),
      Character(
        id: '10',
        name: 'Alphonse Elric',
        series: 'Fullmetal Alchemist',
        imageUrl: 'https://example.com/alphonse.jpg',
        abilities: ['Alchemy', 'Soul Binding', 'Martial Arts', 'Armored Body'],
        description: 'Edward\'s younger brother whose soul is bound to a suit of armor.',
      ),
      Character(
        id: '11',
        name: 'Eren Yeager',
        series: 'Attack on Titan',
        imageUrl: 'https://example.com/eren.jpg',
        abilities: ['Titan Shifting', 'Hardening', 'Coordinate', 'Attack Titan'],
        description: 'A young man who can transform into a Titan and seeks to eliminate all Titans.',
      ),
      Character(
        id: '12',
        name: 'Mikasa Ackerman',
        series: 'Attack on Titan',
        imageUrl: 'https://example.com/mikasa.jpg',
        abilities: ['Ackerman Strength', 'ODM Gear Mastery', 'Combat Skills', 'Swordsmanship'],
        description: 'Eren\'s adoptive sister and one of the most skilled soldiers.',
      ),
      Character(
        id: '13',
        name: 'Saitama',
        series: 'One Punch Man',
        imageUrl: 'https://example.com/saitama.jpg',
        abilities: ['Superhuman Strength', 'Superhuman Speed', 'Invulnerability', 'Serious Punch'],
        description: 'A hero who can defeat any opponent with a single punch.',
      ),
      Character(
        id: '14',
        name: 'Genos',
        series: 'One Punch Man',
        imageUrl: 'https://example.com/genos.jpg',
        abilities: ['Cyborg Body', 'Incineration Cannons', 'Machine Gun Blows', 'Boosters'],
        description: 'A cyborg and Saitama\'s disciple who seeks revenge against the mad cyborg.',
      ),
      Character(
        id: '15',
        name: 'Izuku Midoriya',
        series: 'My Hero Academia',
        imageUrl: 'https://example.com/deku.jpg',
        abilities: ['One For All', 'Full Cowl', 'Shoot Style', 'Delaware Smash'],
        description: 'A boy born without a Quirk who inherits One For All from All Might.',
      ),
      Character(
        id: '16',
        name: 'Katsuki Bakugo',
        series: 'My Hero Academia',
        imageUrl: 'https://example.com/bakugo.jpg',
        abilities: ['Explosion', 'Howitzer Impact', 'AP Shot', 'Stun Grenade'],
        description: 'Izuku\'s childhood friend and rival with an explosive Quirk.',
      ),
      Character(
        id: '17',
        name: 'Light Yagami',
        series: 'Death Note',
        imageUrl: 'https://example.com/light.jpg',
        abilities: ['Death Note', 'Intelligence', 'Strategic Planning', 'Manipulation'],
        description: 'A high school student who discovers a supernatural notebook that kills anyone whose name is written in it.',
      ),
      Character(
        id: '18',
        name: 'L Lawliet',
        series: 'Death Note',
        imageUrl: 'https://example.com/l.jpg',
        abilities: ['Deductive Reasoning', 'Intelligence', 'Martial Arts', 'Investigation'],
        description: 'A mysterious detective who attempts to track down and capture Kira.',
      ),
      Character(
        id: '19',
        name: 'Spike Spiegel',
        series: 'Cowboy Bebop',
        imageUrl: 'https://example.com/spike.jpg',
        abilities: ['Jeet Kune Do', 'Marksmanship', 'Piloting', 'Improvisation'],
        description: 'A former hitman and bounty hunter traveling through space on the Bebop.',
      ),
      Character(
        id: '20',
        name: 'Faye Valentine',
        series: 'Cowboy Bebop',
        imageUrl: 'https://example.com/faye.jpg',
        abilities: ['Marksmanship', 'Piloting', 'Gambling', 'Deception'],
        description: 'A woman with amnesia who joins the crew of the Bebop.',
      ),
    ];
  }
}
