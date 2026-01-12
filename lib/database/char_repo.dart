import 'package:task/imports/imports.dart';

class CharDatabase {
  final box = Hive.box('chars');

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
