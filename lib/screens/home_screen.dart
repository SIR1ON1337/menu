import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/cart_view.dart';
import 'package:flutter/gestures.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: CartView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryIdProvider);
    final menuItems = ref.watch(filteredMenuProvider);
    final cartItems = ref.watch(cartProvider);
    
    final cartItemsCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final cartTotal = cartItems.fold<double>(0, (sum, item) => sum + (item.item.price * item.quantity));

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. SKY Hero Header
          SliverAppBar(
            expandedHeight: isDesktop ? 450 : 180,
            pinned: true,
            stretch: true,
            backgroundColor: SkyTheme.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: isDesktop ? 24 : 12),
              title: Text(
                'SKY BAR',
                style: TextStyle(
                  letterSpacing: isDesktop ? 12 : 6,
                  fontWeight: FontWeight.w200,
                  fontSize: isDesktop ? 42 : 20,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=2070',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          SkyTheme.backgroundDark,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Large Category Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryDelegate(
              height: isDesktop ? 95 : 70,
              child: Container(
                decoration: BoxDecoration(
                  color: SkyTheme.backgroundDark.withOpacity(0.98),
                  border: const Border(bottom: BorderSide(color: Colors.white10)),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: Scrollbar(
                    thumbVisibility: isDesktop,
                    thickness: 2,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 20 : 12,
                        vertical: isDesktop ? 12 : 8,
                      ),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selectedCategory == cat.id;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: isDesktop ? 16 : 8,
                            bottom: isDesktop ? 8 : 4,
                          ),
                          child: IntrinsicWidth(
                            child: ChoiceChip(
                              label: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 12 : 4,
                                  vertical: isDesktop ? 4 : 0,
                                ),
                                child: Text(
                                  cat.name.toUpperCase(),
                                  style: TextStyle(
                                    letterSpacing: isDesktop ? 1.5 : 1,
                                    fontSize: isDesktop ? 13 : 11,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                                    color: isSelected ? Colors.black : Colors.white70,
                                  ),
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) =>
                                  ref.read(selectedCategoryIdProvider.notifier).state = cat.id,
                              selectedColor: SkyTheme.primaryGold,
                              backgroundColor: SkyTheme.surfaceDark,
                              side: isSelected 
                                ? BorderSide.none 
                                : const BorderSide(color: Colors.white10, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              showCheckmark: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24 : 16,
                vertical: isDesktop ? 32 : 16,
              ),
              child: TextField(
                onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Поиск изысканных блюд...',
                  hintStyle: const TextStyle(color: SkyTheme.textSecondary, letterSpacing: 1, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: SkyTheme.primaryGold, size: 20),
                  filled: true,
                  fillColor: SkyTheme.surfaceDark,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                ),
              ),
            ),
          ),

          // 4. Adaptive Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                mainAxisSpacing: isDesktop ? 32 : 12,
                crossAxisSpacing: isDesktop ? 32 : 12,
                childAspectRatio: isDesktop ? 0.75 : 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ItemCard(item: menuItems[index]),
                childCount: menuItems.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 150)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cartItemsCount > 0 
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: isDesktop ? 500 : double.infinity,
            child: FloatingActionButton.extended(
              onPressed: () => _showCart(context),
              backgroundColor: SkyTheme.primaryGold,
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 28),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$cartItemsCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: SkyTheme.primaryGold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: Text(
                'ОФОРМИТЬ ЗАКАЗ (${cartTotal.toInt()} ₽)',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
            ),
          )
        : null,
    );
  }
}

class _CategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _CategoryDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _CategoryDelegate oldDelegate) => 
    height != oldDelegate.height || child != oldDelegate.child;
}
