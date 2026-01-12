part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoriteEvent {
  final String uid;
  FavoritesLoaded(this.uid);

  @override
  List<Object> get props => [uid];
}

class FavoriteToggled extends FavoriteEvent {
  final CharModel char;
  final String uid;
  FavoriteToggled(this.char, this.uid);

  @override
  List<Object?> get props => [char, uid];
}
