import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../bloc/livre_state.dart';
import '../models/livre.dart';
import 'ajouter_livre_screen.dart';
import 'detail_livre_screen.dart';
import 'statistiques_screen.dart';

const List<String> _genres = [
  'Tous',
  'Roman',
  'Science-Fiction',
  'Histoire',
  'Biographie',
  'Développement personnel',
  'Technique',
  'Autre'
];

class ListeLivresScreen extends StatefulWidget {
  const ListeLivresScreen({super.key});

  @override
  State<ListeLivresScreen> createState() => _ListeLivresScreenState();
}

class _ListeLivresScreenState extends State<ListeLivresScreen> {
  final _searchController = TextEditingController();
  String _genreSelectionne = 'Tous';

  @override
  void dispose() {
    // IMPORTANT : toujours libérer les controllers pour éviter les fuites mémoire
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioApp 📚'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Bouton vers l'écran statistiques
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistiques',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatistiquesScreen()),
            ),
          ),
        ],
      ),
      // BlocConsumer = BlocBuilder + BlocListener combinés
      // Builder : reconstruit l'UI selon le State
      // Listener : réagit aux States sans reconstruire (SnackBar, navigation)
      body: BlocConsumer<LivreBloc, LivreState>(
        listener: (context, state) {
          if (state is LivreOperationReussie) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is LivreErreur) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildSearchBar(context),
              _buildGenreFilter(context),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AjouterLivreScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher par titre ou auteur...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<LivreBloc>()
                        .add(const RechercherLivresEvent(''));
                  },
                )
              : null,
        ),
        onChanged: (value) {
          // Envoie un Event de recherche à chaque frappe
          context.read<LivreBloc>().add(RechercherLivresEvent(value));
          setState(() {}); // pour afficher/cacher le bouton clear
        },
      ),
    );
  }

  Widget _buildGenreFilter(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _genres.length,
        itemBuilder: (_, i) {
          final genre = _genres[i];
          final isSelected = genre == _genreSelectionne;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _genreSelectionne = genre);
                context.read<LivreBloc>().add(
                      FiltrerParGenreEvent(genre == 'Tous' ? null : genre),
                    );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, LivreState state) {
    if (state is LivreChargement) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LivreErreur) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message, textAlign: TextAlign.center),
            TextButton(
              onPressed: () =>
                  context.read<LivreBloc>().add(ChargerLivresEvent()),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state is LivresCharges) {
      if (state.livres.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                state.rechercheActive != null
                    ? 'Aucun résultat pour "${state.rechercheActive}"'
                    : 'Votre bibliothèque est vide.\nAjoutez votre premier livre !',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        );
      }
      return _buildListeLivres(context, state.livres);
    }

    return const SizedBox.shrink();
  }

  Widget _buildListeLivres(BuildContext context, List<Livre> livres) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: livres.length,
      itemBuilder: (context, index) {
        final livre = livres[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                livre.titre.isNotEmpty ? livre.titre[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(livre.titre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${livre.auteur}'
                '${livre.annee != null ? ' · ${livre.annee}' : ''}'
                '${livre.genre != null ? ' · ${livre.genre}' : ''}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicateur "lu"
                Icon(
                  livre.lu ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: livre.lu ? Colors.green : Colors.grey,
                  size: 20,
                ),
                if (livre.note != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(livre.note!.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12)),
                ],
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailLivreScreen(livre: livre),
              ),
            ),
          ),
        );
      },
    );
  }
}
