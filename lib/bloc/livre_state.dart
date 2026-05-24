import 'package:equatable/equatable.dart';
import '../models/livre.dart';

abstract class LivreState extends Equatable {
  const LivreState(); // ← constructeur const ajouté

  @override
  List<Object?> get props => [];
}

class LivreInitial extends LivreState {
  const LivreInitial();
}

class LivreChargement extends LivreState {
  const LivreChargement();
}

class LivresCharges extends LivreState {
  final List<Livre> livres;
  final String? filtreGenre;
  final String? rechercheActive;

  const LivresCharges(this.livres, {this.filtreGenre, this.rechercheActive});

  @override
  List<Object?> get props => [livres, filtreGenre, rechercheActive];
}

class LivreOperationReussie extends LivreState {
  final String message;
  const LivreOperationReussie(this.message);

  @override
  List<Object?> get props => [message];
}

class LivreErreur extends LivreState {
  final String message;
  const LivreErreur(this.message);

  @override
  List<Object?> get props => [message];
}