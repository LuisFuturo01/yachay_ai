import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
        childAspectRatio: 0.72, // Made taller to prevent vertical overflows
      ),
      itemCount: MockAvatars.avatars.length,
      itemBuilder: (context, index) {
        final avatar = MockAvatars.avatars[index];
        final isSelected = avatar.id == selectedId;
        return _AvatarCard(
          avatar: avatar,
          isSelected: isSelected,
          onTap: () => onSelected(avatar.id),
        ).animate(delay: (index * 120).ms).fadeIn().scale(
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
    Widget cardChild = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Compact padding
      decoration: BoxDecoration(
        gradient: isSelected
            ? YachayTheme.mathGradient
            : const LinearGradient(colors: [Colors.white, Color(0xFFFAF9F6)]),
        borderRadius: YachayTheme.radiusMedium,
        border: Border.all(
          color: isSelected ? YachayTheme.secondaryGold : YachayTheme.primaryPurple.withValues(alpha: 0.15),
          width: 3,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: YachayTheme.primaryPurple.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : YachayTheme.cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji with separate animation (slightly reduced for mobile safety)
          Text(
            avatar.emoji,
            style: const TextStyle(fontSize: 38),
          ),
          const SizedBox(height: 8),
          // Wrapped in FittedBox to scale down text on small screens instead of overflowing
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              avatar.name,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : YachayTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    // Apply continuous wiggle/bounce animation if selected
    if (isSelected) {
      cardChild = cardChild
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1.05, 1.05), end: const Offset(1.12, 1.12), duration: 600.ms, curve: Curves.easeInOut)
          .then()
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .rotate(begin: -0.04, end: 0.04, duration: 800.ms, curve: Curves.easeInOut);
    }

    return GestureDetector(
      onTap: onTap,
      child: cardChild,
    );
  }
}
