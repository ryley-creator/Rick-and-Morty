part of 'char_bloc.dart';

enum CharStatus { initial, loading, fetched, error, loadingMore }

class CharState {
  final List<CharModel> chars;
  final CharStatus status;
  final List<CharModel> favorites;
  final List<int> favIds;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  CharState({
    this.chars = const [],
    this.status = CharStatus.initial,
    this.favorites = const [],
    this.favIds = const [],
    this.page = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
  });

  CharState copyWith({
    CharStatus? status,
    List<CharModel>? chars,
    List<CharModel>? favorites,
    List<int>? favIds,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return CharState(
      status: status ?? this.status,
      chars: chars ?? this.chars,
      favorites: favorites ?? this.favorites,
      favIds: favIds ?? this.favIds,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
