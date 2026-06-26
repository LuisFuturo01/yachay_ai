import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../data/mock_avatars.dart';

class AvatarSelector extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const AvatarSelector({
    super.key,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: MockAvatars.avatars.length,
      itemBuilder: (context, index) {
        final avatar = MockAvatars.avatars[index];
        final isSelected = avatar.id == selectedId;
        return _AvatarCard(
          avatar: avatar,
          isSelected: isSelected,
          onTap: () => onSelected(avatar.id),
        ).animate(delay: (index * 100).ms).fadeIn().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
      },
    );
  }
}

class _AvatarCard extends StatelessWidget {
  final AvatarData avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarCard({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? YachayTheme.surfacePurple : Colors.white,
          borderRadius: YachayTheme.radiusMedium,
          border: Border.all(
            color: isSelected ? YachayTheme.primaryPurple : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: YachayTheme.primaryPurple.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : YachayTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Text(
                avatar.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              avatar.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? YachayTheme.primaryPurple
                    : YachayTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
