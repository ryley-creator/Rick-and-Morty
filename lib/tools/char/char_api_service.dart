import 'package:dio/dio.dart';

class CharApiService {
  final Dio dio;
  CharApiService(this.dio);

  Future<Response> fetchChars(int page) async {
    return dio.get(
      'https://rickandmortyapi.com/api/character',
      queryParameters: {'page': page},
    );
  }
}
