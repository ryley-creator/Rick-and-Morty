import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:task/models/char_model.dart';
import 'package:task/tools/char/char_api_service.dart';

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  Failure(this.message);
}

class CharPage {
  final List<CharModel> chars;
  final int totalPages;

  CharPage({required this.chars, required this.totalPages});

  factory CharPage.fromJson(Map<String, dynamic> json) {
    return CharPage(
      chars: (json['results'] as List)
          .map((e) => CharModel.fromJson(e))
          .toList(),
      totalPages: json['info']['pages'],
    );
  }
}

abstract class CharRepository {
  Future<Result<CharPage>> getChars(int page);
}

class CharRepositoryImpl implements CharRepository {
  final CharApiService api;
  final Box box;

  CharRepositoryImpl(this.api, this.box);

  @override
  Future<Result<CharPage>> getChars(int page) async {
    try {
      final response = await api.fetchChars(page);
      final pageData = CharPage.fromJson(response.data);

      box.put('page_$page', pageData.chars.map((e) => e.toJson()).toList());
      box.put('totalPages', pageData.totalPages);

      return Success(pageData);
    } on DioException {
      if (box.containsKey('page_$page')) {
        final cached = box.get('page_$page') as List;
        final chars = cached
            .map((e) => CharModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        return Success(
          CharPage(
            chars: chars,
            totalPages: box.get('totalPages', defaultValue: 1),
          ),
        );
      }

      return Failure('No internet');
    }
  }
}
