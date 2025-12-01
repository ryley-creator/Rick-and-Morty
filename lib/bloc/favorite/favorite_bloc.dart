import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task/database/char_repo.dart';
import 'package:task/database/favorite_repo.dart';
import 'package:task/models/char_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({required this.charRepo, required this.favoriteRepo})
    : super(const FavoriteState()) {
    on<FavoriteToggled>(onToggleFavorites);
    on<FavoritesLoaded>(onLoadFavorites);
  }

  final FavoriteRepo favoriteRepo;
  final CharRepo charRepo;

  Future<void> onLoadFavorites(
    FavoritesLoaded event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(status: FavoriteStatus.loading));

    final favIds = favoriteRepo.getFavorites();
    final allChars = charRepo.loadAllPages();

    final favorites = allChars
        .where((char) => favIds.contains(char.id))
        .toList();

    emit(state.copyWith(favorites: favorites, status: FavoriteStatus.loaded));
  }

  Future<void> onToggleFavorites(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    final char = event.char;

    // Update Hive repo
    if (favoriteRepo.isFavorite(char.id)) {
      favoriteRepo.removeFavorite(char.id);
    } else {
      favoriteRepo.addFavorite(char.id);
    }

    // Emit updated state so UI rebuilds
    final favIds = favoriteRepo.getFavorites();
    final allChars = charRepo.loadAllPages(); // load all cached chars
    final updatedFavorites = allChars
        .where((c) => favIds.contains(c.id))
        .toList();

    emit(
      state.copyWith(
        favorites: updatedFavorites,
        status: FavoriteStatus.loaded,
      ),
    );
  }
}
