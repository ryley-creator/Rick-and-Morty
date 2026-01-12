import 'package:equatable/equatable.dart';
import 'package:task/imports/imports.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({required this.charRepo, required this.favoriteRepo})
    : super(const FavoriteState()) {
    on<FavoriteToggled>(onToggleFavorites);
    on<FavoritesLoaded>(onLoadFavorites);
  }
  final FavoriteFirestoreRepo favoriteRepo;
  final CharRepo charRepo;

  // Future<void> onLoadFavorites(
  //   FavoritesLoaded event,
  //   Emitter<FavoriteState> emit,
  // ) async {
  //   emit(state.copyWith(status: FavoriteStatus.loading));

  //   final favIds = favoriteRepo.getFavorites();
  //   final allChars = charRepo.loadAllPages();

  //   final favorites = allChars
  //       .where((char) => favIds.contains(char.id))
  //       .toList();

  //   emit(state.copyWith(favorites: favorites, status: FavoriteStatus.loaded));
  // }

  Future<void> onLoadFavorites(
    FavoritesLoaded event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(status: FavoriteStatus.loading));

    final favIds = await favoriteRepo.getFavorites(event.uid);
    final allChars = charRepo.loadAllPages();
    final favorites = allChars.where((c) => favIds.contains(c.id)).toList();
    emit(state.copyWith(favorites: favorites, status: FavoriteStatus.loaded));
  }

  Future<void> onToggleFavorites(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    final char = event.char;
    final currentFavs = List<String>.from(state.favorites.map((t) => t.id));
    if (currentFavs.contains(char.id)) {
      currentFavs.remove(char.id);
    } else {
      currentFavs.add(char.id);
    }
    await favoriteRepo.setFavorites(event.uid, currentFavs);
    final allChars = charRepo.loadAllPages();
    final updatedFavorites = allChars
        .where((c) => currentFavs.contains(c.id))
        .toList();
    emit(
      state.copyWith(
        favorites: updatedFavorites,
        status: FavoriteStatus.loaded,
      ),
    );
  }

  // Future<void> onToggleFavorites(
  //   FavoriteToggled event,
  //   Emitter<FavoriteState> emit,
  // ) async {
  //   final char = event.char;

  //   if (favoriteRepo.isFavorite(char.id)) {
  //     favoriteRepo.removeFavorite(char.id);
  //   } else {
  //     favoriteRepo.addFavorite(char.id);
  //   }

  //   final favIds = favoriteRepo.getFavorites();
  //   final allChars = charRepo.loadAllPages();
  //   final updatedFavorites = allChars
  //       .where((c) => favIds.contains(c.id))
  //       .toList();

  //   emit(
  //     state.copyWith(
  //       favorites: updatedFavorites,
  //       status: FavoriteStatus.loaded,
  //     ),
  //   );
  // }
}
