import 'package:task/imports/imports.dart';
import 'package:task/tools/char/char_repository.dart';
part 'char_event.dart';
part 'char_state.dart';

class CharBloc extends Bloc<CharEvent, CharState> {
  CharBloc(this.repository) : super(CharState()) {
    on<CharFetched>(onFetchChars);
    on<CharLoadMore>(onLoadMore);
  }

  final CharRepository repository;

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
