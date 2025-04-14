import 'package:flutter/material.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final Function(Map<String, dynamic>, Map<String, dynamic>) onFusionGenerate;
  final VoidCallback onBack;

  const CharacterSelectionScreen({
    Key? key,
    required this.onFusionGenerate,
    required this.onBack,
  }) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  
  Map<String, dynamic>? _selectedCharacter1;
  Map<String, dynamic>? _selectedCharacter2;
  
  String _searchQuery1 = '';
  String _searchQuery2 = '';
  
  int _activeTab = 0;
  
  // Dummy data for demonstration
  final List<Map<String, dynamic>> _dummyCharacters = [
    {
      'id': '1',
      'name': 'Naruto Uzumaki',
      'series': 'Naruto',
      'imageUrl': 'https://example.com/naruto.jpg',
      'abilities': ['Shadow Clone Jutsu', 'Rasengan', 'Sage Mode'],
    },
    {
      'id': '2',
      'name': 'Sasuke Uchiha',
      'series': 'Naruto',
      'imageUrl': 'https://example.com/sasuke.jpg',
      'abilities': ['Sharingan', 'Chidori', 'Amaterasu'],
    },
    {
      'id': '3',
      'name': 'Goku',
      'series': 'Dragon Ball',
      'imageUrl': 'https://example.com/goku.jpg',
      'abilities': ['Kamehameha', 'Super Saiyan', 'Spirit Bomb'],
    },
    {
      'id': '4',
      'name': 'Vegeta',
      'series': 'Dragon Ball',
      'imageUrl': 'https://example.com/vegeta.jpg',
      'abilities': ['Final Flash', 'Super Saiyan', 'Galick Gun'],
    },
    {
      'id': '5',
      'name': 'Luffy',
      'series': 'One Piece',
      'imageUrl': 'https://example.com/luffy.jpg',
      'abilities': ['Gomu Gomu no Mi', 'Haki', 'Gear Fourth'],
    },
    {
      'id': '6',
      'name': 'Zoro',
      'series': 'One Piece',
      'imageUrl': 'https://example.com/zoro.jpg',
      'abilities': ['Three Sword Style', 'Haki', 'Asura'],
    },
    {
      'id': '7',
      'name': 'Ichigo Kurosaki',
      'series': 'Bleach',
      'imageUrl': 'https://example.com/ichigo.jpg',
      'abilities': ['Zangetsu', 'Bankai', 'Hollow Form'],
    },
    {
      'id': '8',
      'name': 'Rukia Kuchiki',
      'series': 'Bleach',
      'imageUrl': 'https://example.com/rukia.jpg',
      'abilities': ['Sode no Shirayuki', 'Kido', 'Bankai'],
    },
  ];
  
  List<Map<String, dynamic>> _getFilteredCharacters(String query) {
    if (query.isEmpty) {
      return _dummyCharacters;
    }
    
    return _dummyCharacters.where((character) {
      return character['name'].toLowerCase().contains(query.toLowerCase()) ||
             character['series'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  
  bool _canGenerateFusion() {
    return _selectedCharacter1 != null && _selectedCharacter2 != null;
  }
  
  @override
  void dispose() {
    _searchController1.dispose();
    _searchController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Select Characters'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.lightTextColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            color: AppTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      'Character 1',
                      0,
                      _selectedCharacter1 != null,
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      'Character 2',
                      1,
                      _selectedCharacter2 != null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Selected characters preview
          if (_selectedCharacter1 != null || _selectedCharacter2 != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.backgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: _selectedCharacter1 != null
                        ? _buildSelectedCharacterPreview(_selectedCharacter1!)
                        : const SizedBox.shrink(),
                  ),
                  if (_selectedCharacter1 != null && _selectedCharacter2 != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.add,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  Expanded(
                    child: _selectedCharacter2 != null
                        ? _buildSelectedCharacterPreview(_selectedCharacter2!)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _activeTab == 0 ? _searchController1 : _searchController2,
              onChanged: (value) {
                setState(() {
                  if (_activeTab == 0) {
                    _searchQuery1 = value;
                  } else {
                    _searchQuery2 = value;
                  }
                });
              },
              hintText: 'Search characters...',
            ),
          ),
          
          // Character grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCharacterGrid(),
            ),
          ),
          
          // Generate fusion button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedOpacity(
              opacity: _canGenerateFusion() ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: AnimatedFusionButton(
                text: "Generate Fusion",
                onPressed: _canGenerateFusion()
                    ? () {
                        widget.onFusionGenerate(
                          _selectedCharacter1!,
                          _selectedCharacter2!,
                        );
                      }
                    : () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabButton(String title, int index, bool hasSelection) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _activeTab == index
                  ? AppTheme.lightTextColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppTheme.lightTextColor,
                fontWeight: _activeTab == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            if (hasSelection)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.lightTextColor,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectedCharacterPreview(Map<String, dynamic> character) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.secondaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              color: AppTheme.secondaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              character['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCharacterGrid() {
    final filteredCharacters = _getFilteredCharacters(
      _activeTab == 0 ? _searchQuery1 : _searchQuery2,
    );
    
    if (filteredCharacters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.secondaryTextColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No characters found',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredCharacters.length,
      itemBuilder: (context, index) {
        final character = filteredCharacters[index];
        final isSelected = _activeTab == 0
            ? _selectedCharacter1 != null && _selectedCharacter1!['id'] == character['id']
            : _selectedCharacter2 != null && _selectedCharacter2!['id'] == character['id'];
            
        return CharacterCard(
          name: character['name'],
          imageUrl: character['imageUrl'],
          isSelected: isSelected,
          onTap: () {
            setState(() {
              if (_activeTab == 0) {
                _selectedCharacter1 = isSelected ? null : character;
              } else {
                _selectedCharacter2 = isSelected ? null : character;
              }
            });
          },
        );
      },
    );
  }
}
