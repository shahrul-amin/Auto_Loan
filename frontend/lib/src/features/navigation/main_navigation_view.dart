import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/views/home_view.dart';
import '../credit/views/credit_view.dart';
import '../loan/views/loan_view.dart';
import '../profile/views/profile_view.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_navigation_destination.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationView extends ConsumerWidget {
  const MainNavigationView({super.key});

  static const routeName = '/main';

  static final List<CustomNavigationDestination> _destinations = [
    const CustomNavigationDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    const CustomNavigationDestination(
      icon: Icons.credit_score_outlined,
      selectedIcon: Icons.credit_score,
      label: 'Credit',
    ),
    const CustomNavigationDestination(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      label: 'Loans',
    ),
    const CustomNavigationDestination(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final screens = [
      const HomeView(),
      const CreditView(),
      const LoanView(),
      const ProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.primaryBlueDark.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlueDark.withOpacity(0.2),
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      _destinations.length,
                      (index) => CustomNavigationDestinationWidget(
                        destination: _destinations[index],
                        isSelected: currentIndex == index,
                        onTap: () {
                          ref.read(navigationIndexProvider.notifier).state =
                              index;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
