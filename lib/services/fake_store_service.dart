import 'dart:io';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: outfit?.photoPath != null
                      ? Image.file(
                          File(outfit!.photoPath!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: colorScheme.surface,
                          child: const Icon(Icons.checkroom),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Outfit sugerido',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      outfit?.name ?? 'Agrega prendas para ver sugerencias',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (outfit != null)
                      Text(
                        outfit!.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.shuffle_rounded),
                color: colorScheme.primary,
                tooltip: 'Shuffle outfit',
                onPressed: onShuffled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
