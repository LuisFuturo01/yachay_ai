import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String emoji;
  final IconData icon;
  final Color color;
  final Color colorLight;
  final String description;
  final int totalLevels;

  const Subject({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
    required this.color,
    required this.colorLight,
    required this.description,
    required this.totalLevels,
  });
}
