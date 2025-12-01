class CharModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final bool isFavorite;

  CharModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    this.isFavorite = false,
  });

  factory CharModel.fromJson(Map<String, dynamic> data) => CharModel(
    id: data['id'],
    name: data['name'],
    status: data['status'],
    species: data['species'],
    gender: data['gender'],
    image: data['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'gender': gender,
    'image': image,
  };

  CharModel copyWith({
    int? id,
    String? name,
    String? gender,
    String? status,
    String? species,
    String? image,
    bool? isFavorite,
  }) {
    return CharModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
