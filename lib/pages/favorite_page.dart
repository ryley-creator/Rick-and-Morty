import 'package:task/imports/imports.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

enum SortType { id, name }

class _FavoritesPageState extends State<FavoritesPage> {
  SortType _sortType = SortType.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton<SortType>(
            onSelected: (type) {
              setState(() {
                _sortType = type;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: SortType.id, child: Text('Sort by ID')),
              PopupMenuItem(value: SortType.name, child: Text('Sort by Name')),
            ],
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          final favs = List<CharModel>.from(state.favorites);

          if (_sortType == SortType.name) {
            favs.sort((a, b) => a.name.compareTo(b.name));
          } else {
            favs.sort((a, b) => a.id.compareTo(b.id));
          }

          if (favs.isEmpty) {
            return Center(
              child: Text('No favorites yet', style: TextStyle(fontSize: 20)),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CharCard(char: favs[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
