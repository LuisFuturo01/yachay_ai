import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum TutorState { idle, happy, thinking, celebrating }

class AnimatedTutorAvatar extends StatelessWidget {
  final String emoji;
  final TutorState state;
  final double size;

  const AnimatedTutorAvatar({
    super.key,
    required this.emoji,
    this.state = TutorState.idle,
    this.size = 80,
  });

  String get _stateEmoji {
    switch (state) {
      case TutorState.happy:
        return '😊';
      case TutorState.thinking:
        return '🤔';
      case TutorState.celebrating:
        return '🎉';
      case TutorState.idle:
        return emoji;
    }
  }

  Color get _glowColor {
    switch (state) {
      case TutorState.happy:
        return const Color(0xFF10B981);
      case TutorState.thinking:
        return const Color(0xFFF59E0B);
      case TutorState.celebrating:
        return const Color(0xFFE879F9);
      case TutorState.idle:
        return const Color(0xFF6B21A8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _glowColor.withValues(alpha: 0.2),
            _glowColor.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _glowColor.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            _stateEmoji,
            key: ValueKey(_stateEmoji),
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      ),
    ).animate(
      target: state == TutorState.celebrating ? 1 : 0,
    ).shake(
      hz: 3,
      duration: 600.ms,
    );
  }
}
