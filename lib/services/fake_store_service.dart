import 'package:flutter/material.dart';
import '../models/garment.dart';

class OutfitMiniPlayer extends StatelessWidget {
  final Garment? outfit;
  final VoidCallback onShuffled;

  const OutfitMiniPlayer({
    super.key,
    required this.outfit,
    required this.onShuffled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 8,
      color: colorScheme.secondaryContainer,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Container(),
      ),
    );
  }
}
