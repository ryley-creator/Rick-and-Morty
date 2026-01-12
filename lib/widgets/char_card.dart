import 'package:task/imports/imports.dart';

class CharCard extends StatelessWidget {
  const CharCard({super.key, required this.char});
  final CharModel char;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        bool isFavorite = state.favorites.any((p) => p.id == char.id);
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border(
              bottom: BorderSide(width: 1),
              top: BorderSide(width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: char.image,
                      width: 150,
                      height: 150,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150,
                          height: 150,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          char.name,
                          softWrap: true,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'Gender: ${char.gender}',
                          softWrap: true,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'Specie: ${char.species}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'Status: ${char.status}',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text('ID: ${char.id}', style: TextStyle(fontSize: 17)),
                        Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: IconButton(
                            onPressed: () {
                              context.read<FavoriteBloc>().add(
                                FavoriteToggled(
                                  char,
                                  FirebaseAuth.instance.currentUser!.uid,
                                ),
                              );
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
