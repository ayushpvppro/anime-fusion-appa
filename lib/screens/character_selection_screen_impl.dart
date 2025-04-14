import 'package:flutter/material.dart';
import 'package:anime_fusion_app/services/character_service.dart';
import 'package:anime_fusion_app/providers/character_selection_provider.dart';
import 'package:anime_fusion_app/theme/app_theme.dart';
import 'package:anime_fusion_app/widgets/ui_components.dart';

class CharacterSelectionScreenImpl extends StatefulWidget {
  final Function(Character, Character) onFusionGenerate;
  final VoidCallback onBack;

  const CharacterSelectionScreenImpl({
    Key? key,
    required this.onFusionGenerate,
    required this.onBack,
  }) : super(key: key);

  @override
  State<CharacterSelectionScreenImpl> createState() => _CharacterSelectionScreenImplState();
}

class _CharacterSelectionScreenImplState extends State<CharacterSelectionScreenImpl> {
  final CharacterSelectionProvider _provider = CharacterSelectionProvider();
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  
  int _activeTab = 0;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      await _provider.initialize();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load characters: ${e.toString()}';
      });
    }
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
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildContent(),
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
            'Loading characters...',
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
            _error ?? 'An unknown error occurred',
            style: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Retry',
            onPressed: _initializeData,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent() {
    return Column(
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
                    _provider.selectedCharacter1 != null,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    'Character 2',
                    1,
                    _provider.selectedCharacter2 != null,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Selected characters preview
        if (_provider.selectedCharacter1 != null || _provider.selectedCharacter2 != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: _provider.selectedCharacter1 != null
                      ? _buildSelectedCharacterPreview(_provider.selectedCharacter1!)
                      : const SizedBox.shrink(),
                ),
                if (_provider.selectedCharacter1 != null && _provider.selectedCharacter2 != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.add,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                Expanded(
                  child: _provider.selectedCharacter2 != null
                      ? _buildSelectedCharacterPreview(_provider.selectedCharacter2!)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        
        // Search and filter
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              SearchBar(
                controller: _activeTab == 0 ? _searchController1 : _searchController2,
                onChanged: (value) {
                  if (_activeTab == 0) {
                    _provider.setSearchQuery1(value);
                  } else {
                    _provider.setSearchQuery2(value);
                  }
                },
                hintText: 'Search characters...',
              ),
              
              // Series filter
              const SizedBox(height: 8),
              _buildSeriesFilter(),
            ],
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
            opacity: _provider.canGenerateFusion ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: AnimatedFusionButton(
              text: "Generate Fusion",
              onPressed: _provider.canGenerateFusion
                  ? () {
                      widget.onFusionGenerate(
                        _provider.selectedCharacter1!,
                        _provider.selectedCharacter2!,
                      );
                    }
                  : () {},
            ),
          ),
        ),
      ],
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
  
  Widget _buildSeriesFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _activeTab == 0 ? _provider.selectedSeries1 : _provider.selectedSeries2,
          hint: const Text('Filter by series'),
          icon: const Icon(Icons.filter_list, color: AppTheme.secondaryColor),
          isExpanded: true,
          onChanged: (String? newValue) {
            if (_activeTab == 0) {
              _provider.setSelectedSeries1(newValue);
            } else {
              _provider.setSelectedSeries2(newValue);
            }
            setState(() {});
          },
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('All Series'),
            ),
            ..._provider.allSeries.map((series) {
              return DropdownMenuItem<String?>(
                value: series,
                child: Text(series),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectedCharacterPreview(Character character) {
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
              character.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 16,
              color: AppTheme.secondaryTextColor,
            ),
            onPressed: () {
              if (_activeTab == 0) {
                _provider.clearSelection1();
              } else {
                _provider.clearSelection2();
              }
              setState(() {});
            },
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCharacterGrid() {
    final filteredCharacters = _activeTab == 0
        ? _provider.getFilteredCharacters1()
        : _provider.getFilteredCharacters2();
    
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
            const SizedBox(height: 24),
            CustomButton(
              text: 'Clear Filters',
              onPressed: () {
                if (_activeTab == 0) {
                  _provider.setSearchQuery1('');
                  _provider.setSelectedSeries1(null);
                  _searchController1.clear();
                } else {
                  _provider.setSearchQuery2('');
                  _provider.setSelectedSeries2(null);
                  _searchController2.clear();
                }
                setState(() {});
              },
              isPrimary: false,
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
            ? _provider.selectedCharacter1?.id == character.id
            : _provider.selectedCharacter2?.id == character.id;
            
        return CharacterCard(
          name: character.name,
          imageUrl: character.imageUrl,
          isSelected: isSelected,
          onTap: () {
            if (_activeTab == 0) {
              _provider.selectCharacter1(isSelected ? null : character);
            } else {
              _provider.selectCharacter2(isSelected ? null : character);
            }
            setState(() {});
          },
        );
      },
    );
  }
}
