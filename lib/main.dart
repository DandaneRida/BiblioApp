import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/livre_bloc.dart';
import 'bloc/livre_event.dart';
import 'repositories/livre_repository.dart';
import 'screens/liste_livres_screen.dart';

void main() {
  runApp(const BiblioApp());
}

class BiblioApp extends StatelessWidget {
  const BiblioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // BlocProvider injecte le LivreBloc dans tout l'arbre de widgets
      // create : appelé une seule fois, retourne l'instance du Bloc
      create: (_) => LivreBloc(LivreRepository())
        ..add(ChargerLivresEvent()), // charge les données immédiatement
      child: MaterialApp(
        title: 'BiblioApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const ListeLivresScreen(),
      ),
    );
  }
}
