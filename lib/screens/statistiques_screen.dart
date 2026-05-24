import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../bloc/livre_state.dart';
import '../models/livre.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocBuilder<LivreBloc, LivreState>(
        builder: (context, state) {
          if (state is LivreChargement) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LivresCharges) {
            return _buildStats(context, state.livres);
          }
          // Si pas encore chargé, déclenche le chargement
          if (state is LivreInitial) {
            context.read<LivreBloc>().add(ChargerLivresEvent());
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Aucune donnée disponible'));
        },
      ),
    );
  }

  Widget _buildStats(BuildContext context, List<Livre> livres) {
    // Calculs d'agrégation
    final total = livres.length;
    final lus = livres.where((l) => l.lu).length;
    final nonLus = total - lus;
    final avecNote = livres.where((l) => l.note != null).toList();
    final noteMoyenne = avecNote.isNotEmpty
        ? avecNote.map((l) => l.note!).reduce((a, b) => a + b) / avecNote.length
        : 0.0;

    // Comptage par genre
    final parGenre = <String, int>{};
    for (final livre in livres) {
      if (livre.genre != null) {
        parGenre[livre.genre!] = (parGenre[livre.genre!] ?? 0) + 1;
      }
    }
    // Tri décroissant par nombre de livres
    final genresTries = parGenre.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cartes de métriques principales
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      icon: Icons.menu_book,
                      label: 'Total',
                      value: '$total',
                      color: Colors.blue)),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.check_circle,
                      label: 'Lus',
                      value: '$lus',
                      color: Colors.green)),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.radio_button_unchecked,
                      label: 'Non lus',
                      value: '$nonLus',
                      color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 16),
          if (avecNote.isNotEmpty)
            _StatCard(
              icon: Icons.star,
              label: 'Note moyenne',
              value: noteMoyenne.toStringAsFixed(2),
              color: Colors.amber,
              fullWidth: true,
            ),
          const SizedBox(height: 24),

          // Répartition par genre
          if (genresTries.isNotEmpty) ...[
            Text('Répartition par genre',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...genresTries.map((entry) => _GenreBar(
                  genre: entry.key,
                  count: entry.value,
                  total: total,
                )),
          ],

          // Taux de lecture
          if (total > 0) ...[
            const SizedBox(height: 24),
            Text('Taux de lecture',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: lus / total,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 4),
            Text('${(lus / total * 100).toStringAsFixed(1)}% lus',
                style: const TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool fullWidth;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: card) : card;
  }
}

class _GenreBar extends StatelessWidget {
  final String genre;
  final int count;
  final int total;

  const _GenreBar(
      {required this.genre, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(genre),
              Text('$count livre${count > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
