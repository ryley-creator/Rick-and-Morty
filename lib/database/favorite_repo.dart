import 'package:task/imports/imports.dart';

// class FavoriteRepo {
//   final box = Hive.box('favorites');

//   List<int> getFavorites() {
//     return List<int>.from(box.get('ids', defaultValue: <int>[])!);
//   }

//   void addFavorite(int id) {
//     final favs = getFavorites();
//     if (!favs.contains(id)) {
//       favs.add(id);
//       box.put('ids', favs);
//     }
//   }

//   void removeFavorite(int id) {
//     final favs = getFavorites();
//     favs.remove(id);
//     box.put('ids', favs);
//   }

//   bool isFavorite(int id) {
//     return getFavorites().contains(id);
//   }
// }

class FavoriteFirestoreRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> setFavorites(String uid, List<String> favIds) async {
    await firestore.collection('users').doc(uid).set({
      'favorites': favIds,
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFavorites(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return List<String>.from(data['favorites'] ?? []);
    }
    return [];
  }
}
