import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';

class UIState<T> extends Equatable {
  const UIState({
    required this.data,
    this.error,
    this.loading = true,
    this.empty = false,
  });

  final T data;
  final String? error;
  final bool loading;
  final bool empty;

  UIState<T> loadingState({required bool isLoading}) =>
      copyWith(loading: isLoading, empty: false);

  UIState<T> errorState(String error) =>
      copyWith(loading: false, error: error, empty: false);

  UIState<T> successState(T data, {bool? empty}) =>
      copyWith(loading: false, data: data, empty: empty ?? false);

  UIState<T> copyWith({
    T? data,
    String? error,
    bool? loading,
    bool? empty,
  }) {
    return UIState(
      data: data ?? this.data,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      empty: empty ?? this.empty,
    );
  }

  @override
  List<Object?> get props => [data, error, loading, empty];

  @override
  bool? get stringify => true;
}

abstract class BaseDataController<T> extends ChangeNotifier {
  BaseDataController({required T data}) : _data = data;
  final T _data;

  late UIState<T> _state = UIState<T>(data: _data);

  set state(UIState<T> newState) {
    if (newState == _state) return;

    _state = newState;

    notifyListeners();
  }

  UIState<T> get state => _state;
}

abstract class BaseListDataController<T> extends BaseDataController<List<T>> {
  BaseListDataController({required List<T> data}) : super(data: data);

  int _nextPage = 1;

  @visibleForTesting
  set nextPage(int nextPage) {
    _nextPage = nextPage;
  }

  @visibleForTesting
  int get nextPage => _nextPage;

  bool get fetchingNext => state.loading && _nextPage > 1;

  void fetch();
}

class PokemonDataController extends BaseListDataController<PokemonEntity> {
  PokemonDataController({required RepositoryBase repository})
      : _repository = repository,
        super(data: []);

  final RepositoryBase _repository;

  @override
  void fetch() async {
    state = _state.loadingState(isLoading: true);

    final result =
        await _repository.fetchPokemons(offset: pageOffset, limit: _pageLimit);

    result.fold(
      (left) => state = _state.errorState(left),
      (right) {
        final newList = List<PokemonEntity>.from(state.data).toList()
          ..addAll(right);

        if (right.isNotEmpty) {
          nextPage++;
        }

        state = _state.successState(
          newList,
          empty: newList.isEmpty,
        );
      },
    );
  }

  @visibleForTesting
  int get pageOffset {
    return ((nextPage - 1) * _pageLimit);
  }

  int get _pageLimit => 20;
}

class FavoritePokenDataController
    extends BaseListDataController<PokemonEntity> {
  FavoritePokenDataController({required RepositoryBase repository})
      : _repository = repository,
        super(data: []);

  final RepositoryBase _repository;

  @override
  void fetch() async {
    state = state.loadingState(isLoading: true);

    final result = await _repository.fetchFavouritePokemons();

    result.fold(
      (left) => state = state.errorState(left),
      (right) => state = state.successState(right, empty: right.isEmpty),
    );
  }

  void updateList(List<PokemonEntity> newList) {
    if (newList == state.data) return;

    state = state.successState(newList);
  }
}

class AddToFavouriteDataController extends BaseDataController<bool?> {
  AddToFavouriteDataController({
    required FavoritePokenDataController favoritePokenDataController,
  })  : _favoritePokenDataController = favoritePokenDataController,
        super(data: null);

  final FavoritePokenDataController _favoritePokenDataController;

  void saveFavourite(PokemonEntity entity) async {
    state = state.loadingState(isLoading: true);
    // await Future.delayed(const Duration(milliseconds: 900));
    final result =
        await _favoritePokenDataController._repository.saveFavourite(entity);

    result.fold(
      (left) => state = state.errorState(left),
      (right) {
        state = state.successState(true);
        _favoritePokenDataController.updateList(right);
      },
    );
  }

  bool isFavourited(PokemonEntity entity) =>
      _favoritePokenDataController.state.data
          .where((element) => element.id == entity.id)
          .isNotEmpty;
}
