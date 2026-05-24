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

class ModifierLivreScreen extends StatefulWidget {
  final Livre livre; // livre existant à modifier
  const ModifierLivreScreen({super.key, required this.livre});

  @override
  State<ModifierLivreScreen> createState() => _ModifierLivreScreenState();
}

class _ModifierLivreScreenState extends State<ModifierLivreScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titreCtrl;
  late final TextEditingController _auteurCtrl;
  late final TextEditingController _anneeCtrl;
  late final TextEditingController _noteCtrl;
  String? _genreSelectionne;
  late bool _lu;

  @override
  void initState() {
    super.initState();
    // Pré-remplissage des champs avec les valeurs existantes
    // C'est la différence principale avec AjouterLivreScreen
    _titreCtrl = TextEditingController(text: widget.livre.titre);
    _auteurCtrl = TextEditingController(text: widget.livre.auteur);
    _anneeCtrl =
        TextEditingController(text: widget.livre.annee?.toString() ?? '');
    _noteCtrl =
        TextEditingController(text: widget.livre.note?.toString() ?? '');
    _genreSelectionne = widget.livre.genre;
    _lu = widget.livre.lu;
  }

  @override
  void dispose() {
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
        title: const Text('Modifier le livre'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreCtrl,
                decoration: const InputDecoration(
                    labelText: 'Titre *', prefixIcon: Icon(Icons.book)),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Titre obligatoire'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _auteurCtrl,
                decoration: const InputDecoration(
                    labelText: 'Auteur *', prefixIcon: Icon(Icons.person)),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Auteur obligatoire'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anneeCtrl,
                decoration: const InputDecoration(
                    labelText: 'Année', prefixIcon: Icon(Icons.calendar_today)),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final a = int.tryParse(v);
                    if (a == null || a < 1 || a > DateTime.now().year) {
                      return 'Année invalide';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _genreSelectionne,
                decoration: const InputDecoration(
                    labelText: 'Genre', prefixIcon: Icon(Icons.category)),
                items: _genres
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _genreSelectionne = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                    labelText: 'Note (0 à 5)', prefixIcon: Icon(Icons.star)),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final n = double.tryParse(v);
                    if (n == null || n < 0 || n > 5) return 'Note entre 0 et 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Livre lu'),
                value: _lu,
                onChanged: (v) => setState(() => _lu = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Mettre à jour',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
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
    if (!_formKey.currentState!.validate()) return;

    // copyWith : conserve l'id existant, met à jour les autres champs
    final livreModifie = widget.livre.copyWith(
      titre: _titreCtrl.text.trim(),
      auteur: _auteurCtrl.text.trim(),
      annee: _anneeCtrl.text.isNotEmpty ? int.parse(_anneeCtrl.text) : null,
      genre: _genreSelectionne,
      note: _noteCtrl.text.isNotEmpty ? double.parse(_noteCtrl.text) : null,
      lu: _lu,
    );

    context.read<LivreBloc>().add(ModifierLivreEvent(livreModifie));
    Navigator.pop(context);
  }
}
