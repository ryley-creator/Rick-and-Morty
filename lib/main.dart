import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/bloc/char/char_bloc.dart';
import 'package:task/bloc/favorite/favorite_bloc.dart';
import 'package:task/bloc/theme/theme_bloc.dart';
import 'package:task/database/char_repo.dart';
import 'package:task/database/favorite_repo.dart';
import 'package:task/pages/home_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('chars');
  final favoriteRepo = FavoriteRepo();
  final charRepo = CharRepo();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => CharBloc()..add(CharFetched())),
        BlocProvider(
          create: (_) =>
              FavoriteBloc(charRepo: charRepo, favoriteRepo: favoriteRepo)
                ..add(FavoritesLoaded()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          home: HomeNav(),
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        );
      },
    );
  }
}
