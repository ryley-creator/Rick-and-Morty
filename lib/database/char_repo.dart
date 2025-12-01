import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/models/char_model.dart';

class CharRepo {
  final box = Hive.box('chars');

  void savePage() {}

  loadPage() {}

  List<CharModel> loadAllPages() {
    final result = <CharModel>[];
    for (var key in box.keys) {
      if (key.toString().startsWith('page_')) {
        final list = box.get(key) as List;
        result.addAll(
          list.map((e) => CharModel.fromJson(Map<String, dynamic>.from(e))),
        );
      }
    }
    return result;
  }
}
