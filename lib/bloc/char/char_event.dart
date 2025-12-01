part of 'char_bloc.dart';

sealed class CharEvent {}

class CharFetched extends CharEvent {}

class CharFavoriteToggled extends CharEvent {
  final CharModel char;
  CharFavoriteToggled(this.char);
}

class CharFavoritesLoaded extends CharEvent {}

class CharLoadMore extends CharEvent {}
