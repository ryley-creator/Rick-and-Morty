import 'imports/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('chars');
  await Hive.openBox('theme');
  final favoriteRepo = FavoriteFirestoreRepo();
  final charRepo = CharRepo();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => CharBloc()..add(CharFetched())),
        BlocProvider(
          create: (_) =>
              FavoriteBloc(charRepo: charRepo, favoriteRepo: favoriteRepo)
                ..add(FavoritesLoaded(FirebaseAuth.instance.currentUser!.uid)),
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
          home: AuthGate(),
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        );
      },
    );
  }
}
