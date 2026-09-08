import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../core/theme.dart';
import '../providers/cart_provider.dart';

class ItemCard extends ConsumerWidget {
  final MenuItem item;
  const ItemCard({super.key, required this.item});

  ImageProvider _getImageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return const NetworkImage('https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=1000');
    }
    if (url.startsWith('http') || url.startsWith('https')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isMobile = size.width <= 600;

    return Container(
      decoration: BoxDecoration(
        color: SkyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    image: DecorationImage(
                      image: _getImageProvider(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            letterSpacing: 1,
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.price.toInt()} ₽',
                      style: TextStyle(
                        color: SkyTheme.primaryGold,
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: SkyTheme.textSecondary,
                              height: 1.4,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SkyTheme.primaryGold,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ref.read(cartProvider.notifier).addItem(item);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${item.name.toUpperCase()} ДОБАВЛЕН',
                                style: const TextStyle(
                                  color: SkyTheme.primaryGold,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              duration: const Duration(milliseconds: 800),
                              backgroundColor: SkyTheme.surfaceDark.withOpacity(0.98),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                bottom: size.height * 0.12,
                                left: size.width * 0.1,
                                right: size.width * 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white10),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'ДОБАВИТЬ',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: isMobile ? 1 : 2,
                            fontSize: isMobile ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.tags.isNotEmpty)
            Positioned(
              top: 8,
              left: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: SkyTheme.primaryGold.withOpacity(0.9),
                    child: Text(
                      item.tags.first.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
