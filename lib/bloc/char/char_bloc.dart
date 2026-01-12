import 'package:dio/dio.dart';
import 'package:task/imports/imports.dart';
import 'package:task/tools/char_repository.dart';
part 'char_event.dart';
part 'char_state.dart';

class CharBloc extends Bloc<CharEvent, CharState> {
  CharBloc(this.repository) : super(CharState()) {
    on<CharFetched>(onFetchChars);
    on<CharLoadMore>(onLoadMore);
  }

  final CharRepository repository;

  Future<Map<String, dynamic>> fetchChars({int page = 1}) async {
    try {
      final url = "https://rickandmortyapi.com/api/character?page=$page";
      final dio = Dio();
      final response = await dio.get(url);

      final data = response.data;
      final List results = data['results'];
      final totalPages = data['info']['pages'];

      final chars = results.map((e) => CharModel.fromJson(e)).toList();
      return {'chars': chars, 'totalPages': totalPages};
    } on DioException catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> onFetchChars(CharFetched event, Emitter<CharState> emit) async {
    emit(state.copyWith(status: CharStatus.loading));

    final result = await repository.getChars(1);

    switch (result) {
      case Success(data: final page):
        emit(
          state.copyWith(
            chars: page.chars,
            page: 1,
            totalPages: page.totalPages,
            status: CharStatus.fetched,
          ),
        );
      case Failure():
        emit(state.copyWith(status: CharStatus.error));
    }
  }

  Future<void> onLoadMore(CharLoadMore event, Emitter<CharState> emit) async {
    if (state.page >= state.totalPages ||
        state.status == CharStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: CharStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await repository.getChars(nextPage);

    switch (result) {
      case Success(data: final page):
        emit(
          state.copyWith(
            chars: [...state.chars, ...page.chars],
            page: nextPage,
            status: CharStatus.fetched,
          ),
        );
      case Failure():
        emit(state.copyWith(status: CharStatus.error));
    }
  }
}
