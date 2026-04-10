// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/wardrobe_provider.dart';
import '../widgets/garment_card.dart';
import '../widgets/outfit_mini_player.dart';
import '../widgets/shake_detector.dart';
import 'add_garment_screen.dart';
import 'favorites_screen.dart';
import 'suggestions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  Future<void> _onShuffle() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 150);
    }
    if (!mounted) return; 
    context.read<WardrobeProvider>().shuffleOutfit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.shuffle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('¡Outfit aleatorio seleccionado! 🎲'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCategoryFilter(WardrobeProvider provider) {
    final categories = provider.availableCategories;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final selected = provider.selectedCategory == cat;
          return FilterChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) => provider.setCategory(cat),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildWardrobeTab(WardrobeProvider provider) {
    final garments = provider.filteredGarments;

    return Column(
      children: [
        const SizedBox(height: 8),
        _buildCategoryFilter(provider),
        const SizedBox(height: 8),
        Expanded(
          child: garments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checkroom_outlined,
                          size: 72,
                          color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 16),
                      Text(
                        provider.garments.isEmpty
                            ? 'Tu guardarropa está vacío'
                            : 'Sin prendas en "${provider.selectedCategory}"',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (provider.garments.isEmpty)
                        const Text('Toca + para agregar tu primera prenda'),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: garments.length,
                  itemBuilder: (context, i) =>
                      GarmentCard(garment: garments[i]),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    final tabs = [
      _buildWardrobeTab(provider),
      const FavoritesScreen(),
      const SuggestionsScreen(),
    ];

    return ShakeDetector(
      onShake: _onShuffle,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StyleStack'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            IndexedStack(index: _tab, children: tabs),
            Align(
              alignment: Alignment.bottomCenter,
              child: OutfitMiniPlayer(
                outfit: provider.currentOutfit,
                onShuffled: _onShuffle,
              ),
            ),
          ],
        ),
        floatingActionButton: _tab == 0
            ? FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddGarmentScreen()),
                ),
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.checkroom_outlined),
              selectedIcon: Icon(Icons.checkroom),
              label: 'Guardarropa',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Sugerencias',
            ),
          ],
        ),
      ),
    );
  }
}