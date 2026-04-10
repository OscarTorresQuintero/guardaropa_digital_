class Garment {
  final String id;
  final String name;
  final String category;
  final String? photoPath;
  bool isFavorite;

  Garment({
    required this.id,
    required this.name,
    required this.category,
    this.photoPath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'photoPath': photoPath ?? '',
        'isFavorite': isFavorite ? '1' : '0',
      };

  factory Garment.fromMap(Map<String, dynamic> map) => Garment(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        photoPath: map['photoPath'].isEmpty ? null : map['photoPath'],
        isFavorite: map['isFavorite'] == '1',
      );
}