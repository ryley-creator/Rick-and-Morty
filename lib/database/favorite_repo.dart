import 'package:task/imports/imports.dart';

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
