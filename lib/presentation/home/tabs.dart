import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '../../core/theme/app_theme.dart';
import 'home_page.dart';
import '../auth/profile/profile_page.dart';

// Create alias for backward compatibility
typedef TabsScreen = TabsPage;

@RoutePage()
class TabsPage extends ConsumerStatefulWidget {
  const TabsPage({super.key});

  @override
  ConsumerState<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends ConsumerState<TabsPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.primaryYellow,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLg),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  index: 0,
                  isSelected: _currentIndex == 0,
                ),
                _buildAddButton(),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  index: 1,
                  isSelected: _currentIndex == 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: Icon(
          icon,
          color: AppTheme.primaryBlack,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to add wishlist/item page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add functionality coming soon!'),
            backgroundColor: AppTheme.primaryBlack,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        child: const Icon(
          Icons.add,
          color: AppTheme.primaryBlack,
          size: 28,
        ),
      ),
    );
  }
}
