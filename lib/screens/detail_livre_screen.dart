import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';
import 'modifier_livre_screen.dart';

class DetailLivreScreen extends StatelessWidget {
  final Livre livre;
  const DetailLivreScreen({super.key, required this.livre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(livre.titre, overflow: TextOverflow.ellipsis),
        actions: [
          // Bouton modifier
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ModifierLivreScreen(livre: livre),
              ),
            ),
          ),
          // Bouton supprimer
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec initiale
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  livre.titre[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow(icon: Icons.book, label: 'Titre', value: livre.titre),
            _DetailRow(
                icon: Icons.person, label: 'Auteur', value: livre.auteur),
            if (livre.annee != null)
              _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Année',
                  value: livre.annee.toString()),
            if (livre.genre != null)
              _DetailRow(
                  icon: Icons.category, label: 'Genre', value: livre.genre!),
            if (livre.note != null)
              _DetailRow(
                icon: Icons.star,
                label: 'Note',
                value: '${livre.note!.toStringAsFixed(1)} / 5',
                valueColor: Colors.amber,
              ),
            _DetailRow(
              icon:
                  livre.lu ? Icons.check_circle : Icons.radio_button_unchecked,
              label: 'Statut',
              value: livre.lu ? 'Lu ✓' : 'Non lu',
              valueColor: livre.lu ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${livre.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext); // ferme le dialog
              // Envoie l'Event de suppression au BLoC
              context.read<LivreBloc>().add(SupprimerLivreEvent(livre.id!));
              Navigator.pop(context); // retourne à la liste
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable pour afficher une ligne de détail
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('$label : ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
