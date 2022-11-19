import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokedex/domain/repository_base.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

class FavouritedCountChip extends StatelessWidget {
  const FavouritedCountChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.favouritePokemonController,
      builder: (context, _) {
        final state = context.favouritePokemonController.state;

        if (state.data.isNotEmpty) {
          return CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).primaryColor,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                 
                  "${state.data.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class PokemonGridView<T extends BaseDataController<PokemonList>>
    extends StatefulWidget {
  const PokemonGridView({
    super.key,
    Listenable? externalListenable,
    VoidCallback? emptyStateButtonAction,
    String? emptyStateButtonText,
    String? emptyStateText,
  })  : _emptyStateTapped = emptyStateButtonAction,
        _emptyStateButtonText = emptyStateButtonText,
        _emptyStateText = emptyStateText,
        paginated = false;

  const PokemonGridView.favouritedPokemons(
      {super.key, required VoidCallback emptyStateTapped})
      : paginated = false,
        _emptyStateTapped = emptyStateTapped,
        _emptyStateText = "No favourite pokemons yet",
        _emptyStateButtonText = "Add Favourite";

  const PokemonGridView.pokemons({super.key, required Listenable listenable})
      : paginated = true,
        _emptyStateTapped = null,
        _emptyStateText = null,
        _emptyStateButtonText = null;

  final VoidCallback? _emptyStateTapped;
  final String? _emptyStateButtonText;
  final String? _emptyStateText;
  final bool paginated;

  @override
  State<PokemonGridView> createState() => _PokemonGridViewState<T>();
}

class _PokemonGridViewState<T extends BaseDataController<PokemonList>>
    extends State<PokemonGridView<T>> {
  final _animateCardNotifier = ValueNotifier(true);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    const margin = 10.0;
    final dataController = context.dataController<T>();

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotfication,
      child: AnimatedBuilder(
        animation: dataController,
        builder: (context, _) {
          final state = context.dataController<T>().state;

          bool isLoading = state.loading && !dataController.fetchingNext;

          if (state.error != null) {
            return InfoWidget(
              text: state.error!,
              buttonText: "Retry",
              onPressed: () => dataController.fetch(),
            );
          }

          if (state.empty) {
            return InfoWidget(
              text: widget._emptyStateText ?? "No pokemon found",
              buttonText: widget._emptyStateButtonText ?? "Retry",
              onPressed: () => widget._emptyStateButtonText != null
                  ? widget._emptyStateTapped!()
                  : dataController.fetch(),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: margin,
                    crossAxisSpacing: margin,
                    mainAxisExtent: 200,
                  ),
                  itemCount: isLoading ? 12 : state.data.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => isLoading
                      ? PokedexCardShimmer(index: index, animate: !isLoading)
                      : PokedexCard(
                          key: ValueKey(state.data[index]),
                          index: index % 20,
                          pokemon: state.data[index],
                          animate: _animateCardNotifier.value,
                        ),
                ),
              ),
              if (dataController.fetchingNext) const BottomLoadingWidget(),
            ],
          );
        },
      ),
    );
  }

  bool _onScrollNotfication(ScrollNotification notification) {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _animateCardNotifier.value = false;
    } else {
      _animateCardNotifier.value = true;
    }
    if (widget.paginated) {
      if (_fetchMore(notification)) {
        context.dataController<T>().fetch();
        return true;
      }
    }
    return false;
  }

  bool _fetchMore(ScrollNotification notification) {
    return notification is ScrollEndNotification &&
        notification.metrics.extentAfter < 20 &&
        !context.dataController<T>().state.loading;
  }

  @override
  void dispose() {
    _animateCardNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class BottomLoadingWidget extends StatelessWidget {
  const BottomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: LinearProgressIndicator(minHeight: 6),
    );
  }
}
