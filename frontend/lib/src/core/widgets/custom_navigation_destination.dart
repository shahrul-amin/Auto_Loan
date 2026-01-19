import 'package:flutter/material.dart';

class CustomNavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const CustomNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class CustomNavigationDestinationWidget extends StatelessWidget {
  final CustomNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavigationDestinationWidget({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  Color get _iconColor =>
      isSelected ? Colors.white : Colors.white.withOpacity(0.5);
  Color get _labelColor =>
      isSelected ? Colors.white : Colors.white.withOpacity(0.5);
  IconData get _displayIcon =>
      isSelected ? destination.selectedIcon : destination.icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _displayIcon,
              color: _iconColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              destination.label,
              style: TextStyle(
                color: _labelColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
