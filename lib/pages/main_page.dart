import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/char/char_bloc.dart';
import 'package:task/widgets/char_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<CharBloc>().add(CharLoadMore());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<CharBloc, CharState>(
        builder: (context, state) {
          if (state.status == CharStatus.loading && state.chars.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == CharStatus.error && state.chars.isEmpty) {
            return Center(child: Text('Cannot load characters...'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                controller: scrollController,
                itemCount: state.chars.length,
                itemBuilder: (context, index) {
                  if (index < state.chars.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CharCard(char: state.chars[index]),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
