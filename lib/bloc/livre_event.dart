import 'package:equatable/equatable.dart';
import '../models/livre.dart';

abstract class LivreEvent extends Equatable {
  const LivreEvent(); // ← constructeur const ajouté

  @override
  List<Object?> get props => [];
}

class ChargerLivresEvent extends LivreEvent {
  const ChargerLivresEvent();
}

class AjouterLivreEvent extends LivreEvent {
  final Livre livre; // ← final obligatoire pour const
  const AjouterLivreEvent(this.livre);

  @override
  List<Object?> get props => [livre]; // ← List<Object?> pas Future
}

class ModifierLivreEvent extends LivreEvent {
  final Livre livre;
  const ModifierLivreEvent(this.livre);

  @override
  List<Object?> get props => [livre];
}

class SupprimerLivreEvent extends LivreEvent {
  final int id;
  const SupprimerLivreEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RechercherLivresEvent extends LivreEvent {
  final String query;
  const RechercherLivresEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FiltrerParGenreEvent extends LivreEvent {
  final String? genre;
  const FiltrerParGenreEvent(this.genre);

  @override
  List<Object?> get props => [genre];
}