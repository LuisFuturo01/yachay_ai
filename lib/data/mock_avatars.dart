/// Mock avatar data.
/// Replace with API data when backend is ready.

class AvatarData {
  final String id;
  final String name;
  final String emoji;
  final String description;

  const AvatarData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });
}

class MockAvatars {
  MockAvatars._();

  static const List<AvatarData> avatars = [
    AvatarData(
      id: 'quirquincho',
      name: 'Kirki',
      emoji: '🦔',
      description: 'El quirquincho valiente',
    ),
    AvatarData(
      id: 'llama',
      name: 'Llamita',
      emoji: '🦙',
      description: 'La llama sabia',
    ),
    AvatarData(
      id: 'condor',
      name: 'Kunturi',
      emoji: '🦅',
      description: 'El cóndor explorador',
    ),
    AvatarData(
      id: 'vicuna',
      name: 'Vicuñita',
      emoji: '🫎',
      description: 'La vicuña curiosa',
    ),
    AvatarData(
      id: 'puma',
      name: 'Pumita',
      emoji: '🐆',
      description: 'El puma astuto',
    ),
    AvatarData(
      id: 'colibri',
      name: 'Qenti',
      emoji: '🐦',
      description: 'El colibrí veloz',
    ),
  ];

  static AvatarData getById(String id) {
    return avatars.firstWhere(
      (a) => a.id == id,
      orElse: () => avatars.first,
    );
  }
}
