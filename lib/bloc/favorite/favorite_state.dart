part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, loading, loaded }

class FavoriteState extends Equatable {
  final List<CharModel> favorites;
  final FavoriteStatus status;
  const FavoriteState({
    this.favorites = const [],
    this.status = FavoriteStatus.initial,
  });

  FavoriteState copyWith({List<CharModel>? favorites, FavoriteStatus? status}) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [favorites];
}
