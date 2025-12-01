import 'package:hive/hive.dart';

class FavoriteRepo {
  final box = Hive.box('favorites');

  List<int> getFavorites() {
    return List<int>.from(box.get('ids', defaultValue: <int>[])!);
  }

  void addFavorite(int id) {
    final favs = getFavorites();
    if (!favs.contains(id)) {
      favs.add(id);
      box.put('ids', favs);
    }
  }

  void removeFavorite(int id) {
    final favs = getFavorites();
    favs.remove(id);
    box.put('ids', favs);
  }

  bool isFavorite(int id) {
    return getFavorites().contains(id);
  }
}
