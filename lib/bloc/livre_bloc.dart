import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/livre_repository.dart';
import 'livre_event.dart';
import 'livre_state.dart';

// Le Bloc orchestre : il reçoit un Event, appelle le Repository, émet un State.
// C'est le seul endroit où la logique métier réside — jamais dans les widgets.
class LivreBloc extends Bloc<LivreEvent, LivreState> {
  final LivreRepository _repository;

  LivreBloc(this._repository) : super(LivreInitial()) {
    // on<EventType> enregistre un handler pour chaque type d'Event
    on<ChargerLivresEvent>(_onCharger);
    on<AjouterLivreEvent>(_onAjouter);
    on<ModifierLivreEvent>(_onModifier);
    on<SupprimerLivreEvent>(_onSupprimer);
    on<RechercherLivresEvent>(_onRechercher);
    on<FiltrerParGenreEvent>(_onFiltrer);
  }

  Future<void> _onCharger(
      ChargerLivresEvent event, Emitter<LivreState> emit) async {
    emit(LivreChargement()); // 1. signal de chargement
    try {
      final livres = await _repository.lireTous();
      emit(LivresCharges(livres)); // 2. données disponibles
    } catch (e) {
      emit(LivreErreur('Impossible de charger les livres : $e'));
    }
  }

  Future<void> _onAjouter(
      AjouterLivreEvent event, Emitter<LivreState> emit) async {
    emit(LivreChargement());
    try {
      await _repository.creer(event.livre);
      emit(const LivreOperationReussie('Livre ajouté avec succès !'));
      // Recharge la liste complète après ajout
      final livres = await _repository.lireTous();
      emit(LivresCharges(livres));
    } catch (e) {
      emit(LivreErreur('Erreur lors de l\'ajout : $e'));
    }
  }

  Future<void> _onModifier(
      ModifierLivreEvent event, Emitter<LivreState> emit) async {
    emit(LivreChargement());
    try {
      await _repository.mettreAJour(event.livre);
      emit(const LivreOperationReussie('Livre modifié avec succès !'));
      final livres = await _repository.lireTous();
      emit(LivresCharges(livres));
    } catch (e) {
      emit(LivreErreur('Erreur lors de la modification : $e'));
    }
  }

  Future<void> _onSupprimer(
      SupprimerLivreEvent event, Emitter<LivreState> emit) async {
    emit(LivreChargement());
    try {
      await _repository.supprimer(event.id);
      emit(const LivreOperationReussie('Livre supprimé.'));
      final livres = await _repository.lireTous();
      emit(LivresCharges(livres));
    } catch (e) {
      emit(LivreErreur('Erreur lors de la suppression : $e'));
    }
  }

  Future<void> _onRechercher(
      RechercherLivresEvent event, Emitter<LivreState> emit) async {
    try {
      final livres = event.query.isEmpty
          ? await _repository.lireTous()
          : await _repository.rechercher(event.query);
      emit(LivresCharges(livres,
          rechercheActive: event.query.isEmpty ? null : event.query));
    } catch (e) {
      emit(LivreErreur('Erreur de recherche : $e'));
    }
  }

  Future<void> _onFiltrer(
      FiltrerParGenreEvent event, Emitter<LivreState> emit) async {
    try {
      final livres = event.genre == null
          ? await _repository.lireTous()
          : await _repository.filtrerParGenre(event.genre!);
      emit(LivresCharges(livres, filtreGenre: event.genre));
    } catch (e) {
      emit(LivreErreur('Erreur de filtre : $e'));
    }
  }
}
