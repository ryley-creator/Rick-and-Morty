part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoriteEvent {}

class FavoriteToggled extends FavoriteEvent {
  final CharModel char;
  FavoriteToggled(this.char);

  @override
  List<Object?> get props => [char];
}
