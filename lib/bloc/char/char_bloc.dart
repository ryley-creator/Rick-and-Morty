import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/models/char_model.dart';
part 'char_event.dart';
part 'char_state.dart';

class CharBloc extends Bloc<CharEvent, CharState> {
  CharBloc() : super(CharState()) {
    on<CharFetched>(onFetchChars);
    on<CharLoadMore>(onLoadMore);
  }

  Future<Map<String, dynamic>> fetchChars({int page = 1}) async {
    final url = "https://rickandmortyapi.com/api/character?page=$page";
    final dio = Dio();
    final response = await dio.get(url);

    final data = response.data;
    final List results = data['results'];
    final totalPages = data['info']['pages'];

    final chars = results.map((e) => CharModel.fromJson(e)).toList();
    return {'chars': chars, 'totalPages': totalPages};
  }

  Future<void> onFetchChars(CharFetched event, Emitter<CharState> emit) async {
    emit(state.copyWith(status: CharStatus.loading));

    final box = Hive.box('chars');
    List<CharModel> chars = [];
    int totalPages = 1;

    if (box.containsKey('page_1')) {
      final cachedList = box.get('page_1') as List;
      chars = cachedList
          .map((e) => CharModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      totalPages = box.get('totalPages', defaultValue: 1);
    } else {
      final data = await fetchChars(page: 1);
      chars = data['chars'];
      totalPages = data['totalPages'];

      box.put('page_1', chars.map((e) => e.toJson()).toList());
      box.put('totalPages', totalPages);
    }

    emit(
      state.copyWith(
        status: CharStatus.fetched,
        chars: chars,
        page: 1,
        totalPages: totalPages,
      ),
    );
  }

  Future<void> onLoadMore(CharLoadMore event, Emitter<CharState> emit) async {
    if (state.page >= state.totalPages ||
        state.status == CharStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: CharStatus.loadingMore));

    final nextPage = state.page + 1;
    final box = Hive.box('chars');
    List<CharModel> newChars = [];

    if (box.containsKey('page_$nextPage')) {
      final list = box.get('page_$nextPage') as List;
      newChars = list
          .map((e) => CharModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      final data = await fetchChars(page: nextPage);
      newChars = data['chars'];

      box.put('page_$nextPage', newChars.map((e) => e.toJson()).toList());
    }

    emit(
      state.copyWith(
        chars: List.from(state.chars)..addAll(newChars),
        page: nextPage,
        status: CharStatus.fetched,
      ),
    );
  }
}
