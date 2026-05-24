import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../models/livre.dart';

const List<String> _genres = [
  'Roman',
  'Science-Fiction',
  'Histoire',
  'Biographie',
  'Développement personnel',
  'Technique',
  'Autre'
];

class AjouterLivreScreen extends StatefulWidget {
  const AjouterLivreScreen({super.key});

  @override
  State<AjouterLivreScreen> createState() => _AjouterLivreScreenState();
}

class _AjouterLivreScreenState extends State<AjouterLivreScreen> {
  // GlobalKey permet d'accéder à l'état du formulaire (validation)
  final _formKey = GlobalKey<FormState>();

  final _titreCtrl = TextEditingController();
  final _auteurCtrl = TextEditingController();
  final _anneeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String? _genreSelectionne;
  bool _lu = false;

  @override
  void dispose() {
    // Libération systématique de tous les controllers
    _titreCtrl.dispose();
    _auteurCtrl.dispose();
    _anneeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ Titre — OBLIGATOIRE
              TextFormField(
                controller: _titreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titre *',
                  prefixIcon: Icon(Icons.book),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Le titre est obligatoire';
                  if (v.trim().length < 2) return 'Titre trop court';
                  return null; // null = valide
                },
              ),
              const SizedBox(height: 16),

              // Champ Auteur — OBLIGATOIRE
              TextFormField(
                controller: _auteurCtrl,
                decoration: const InputDecoration(
                  labelText: 'Auteur *',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'L\'auteur est obligatoire';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ Année — OPTIONNEL
              TextFormField(
                controller: _anneeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Année de publication',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final annee = int.tryParse(v);
                    if (annee == null) return 'Année invalide';
                    if (annee < 1 || annee > DateTime.now().year)
                      return 'Année hors plage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Genre — OPTIONNEL
              DropdownButtonFormField<String>(
                value: _genreSelectionne,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _genres
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _genreSelectionne = v),
              ),
              const SizedBox(height: 16),

              // Champ Note — OPTIONNEL
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note (0 à 5)',
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final note = double.tryParse(v);
                    if (note == null) return 'Note invalide';
                    if (note < 0 || note > 5)
                      return 'La note doit être entre 0 et 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Switch "Lu"
              SwitchListTile(
                title: const Text('Livre lu'),
                subtitle: const Text('Avez-vous déjà lu ce livre ?'),
                value: _lu,
                onChanged: (v) => setState(() => _lu = v),
              ),
              const SizedBox(height: 24),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label:
                      const Text('Enregistrer', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _soumettre,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _soumettre() {
    // validate() déclenche tous les validators du formulaire
    if (!_formKey.currentState!.validate()) return;

    final livre = Livre(
      titre: _titreCtrl.text.trim(),
      auteur: _auteurCtrl.text.trim(),
      annee: _anneeCtrl.text.isNotEmpty ? int.parse(_anneeCtrl.text) : null,
      genre: _genreSelectionne,
      note: _noteCtrl.text.isNotEmpty ? double.parse(_noteCtrl.text) : null,
      lu: _lu,
    );

    // Envoie l'Event au BLoC — le BLoC gère le reste
    context.read<LivreBloc>().add(AjouterLivreEvent(livre));
    Navigator.pop(context); // retour à la liste
  }
}
