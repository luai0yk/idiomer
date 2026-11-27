import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/ui/dialog_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_state.dart';
import 'package:idiomer/features/idioms/presentation/utils/idiom_tap_helper.dart';
import 'package:idiomer/features/idioms/presentation/widgets/explore_header.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_card.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/shared/widgets/appbars/my_gradient_header.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/dialogs/my_dialog.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 250) {
      context.read<FavoritesBloc>().add(const IdiomsLoadMoreRequested());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ScrollUnderHeaderColumn(
        floatingBarHeight: ExploreSearchHeader.barHeight(context),
        headerBuilder: (context, showBottomBorder) =>
            BlocSelector<FavoritesBloc, IdiomsState, bool>(
              selector: (state) => state.idioms.isNotEmpty,
              builder: (context, hasFavorites) {
                return ExploreFixedHeader(
                  title: l10n.favorites,
                  showBottomBorder: showBottomBorder,
                  trailing: hasFavorites
                      ? MyIconButton.ghost(
                          icon: AppIcons.clear,
                          iconColor: colorScheme.primary,
                          tooltip: l10n.clearAll,
                          onPressed: () => _confirmClearAll(context, l10n),
                        )
                      : null,
                );
              },
            ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            BlocSelector<
              FavoritesBloc,
              IdiomsState,
              ({
                bool searchEnabled,
                List<CategoryEntity> categories,
                String? selectedCategoryId,
              })
            >(
              selector: (state) => (
                searchEnabled:
                    state.status == IdiomsStatus.loaded &&
                    (state.idioms.isNotEmpty ||
                        state.hasActiveFilters ||
                        state.isApplyingFilter),
                categories: state.categories,
                selectedCategoryId: state.selectedCategoryId,
              ),
              builder: (context, headerState) {
                final isArabic =
                    Directionality.of(context) == TextDirection.rtl;
                final selectedCategoryName = headerState.categories
                    .where((c) => c.id == headerState.selectedCategoryId)
                    .firstOrNull
                    ?.localizedName(isArabic: isArabic);

                return ExploreSearchHeader(
                  searchEnabled: headerState.searchEnabled,
                  searchController: _searchController,
                  onSearchChanged: (value) {
                    context.read<FavoritesBloc>().add(
                      IdiomsSearchChanged(value),
                    );
                  },
                  hasCategories: headerState.categories.isNotEmpty,
                  hasActiveCategoryFilter:
                      headerState.selectedCategoryId != null,
                  selectedCategoryName: selectedCategoryName,
                  onClearCategory: () {
                    context.read<FavoritesBloc>().add(
                      const IdiomsCategorySelected(null, toggle: false),
                    );
                  },
                  onOpenCategorySheet: () {
                    SelectCategorySheet.show(
                      context,
                      categories: headerState.categories,
                      selectedCategoryId: headerState.selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        context.read<FavoritesBloc>().add(
                          IdiomsCategorySelected(categoryId),
                        );
                      },
                    );
                  },
                );
              },
            ),
            BlocBuilder<FavoritesBloc, IdiomsState>(
              builder: (context, state) =>
                  _buildBodySliver(context, state, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodySliver(
    BuildContext context,
    IdiomsState state,
    AppLocalizations l10n,
  ) {
    if (state.status == IdiomsStatus.initial ||
        state.status == IdiomsStatus.loading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: MyLoadingState(label: l10n.loadingFavorites)),
      );
    }

    if (state.status == IdiomsStatus.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: MyEmptyState(
            icon: AppIcons.error,
            title: l10n.loadErrorTitle,
            subtitle: l10n.loadErrorSubtitle,
            actionText: l10n.retry,
            onAction: () {
              context.read<FavoritesBloc>().add(const IdiomsRetryRequested());
            },
          ),
        ),
      );
    }

    if (state.idioms.isEmpty) {
      if (state.hasActiveFilters) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: MyEmptyState(
              icon: AppIcons.searchOff,
              title: l10n.noResultsFound,
              subtitle: l10n.tryAdjustingSearch,
              actionText: l10n.clearFilters,
              onAction: () {
                _searchController.clear();
                context.read<FavoritesBloc>().add(const IdiomsFiltersCleared());
              },
            ),
          ),
        );
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: MyEmptyState(
            icon: AppIcons.favorite,
            title: l10n.noFavoritesTitle,
            subtitle: l10n.noFavoritesSubtitle,
          ),
        ),
      );
    }

    final itemCount = state.idioms.length + (state.isLoadingMore ? 1 : 0);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        context.spaceM,
        context.spaceXs,
        context.spaceM,
        context.spaceXl,
      ),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, _) => context.verticalSpace(10),
        itemBuilder: (context, index) {
          if (index >= state.idioms.length) {
            return Padding(
              padding: context.insetsVerticalM,
              child: const Center(child: MyProgressIndicator()),
            );
          }

          final idiom = state.idioms[index];
          return IdiomCard(
            idiom: idiom,
            onTap: () =>
                IdiomTapHelper.handleIdiomTap(context, idiomId: idiom.id),
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppLocalizations l10n) {
    final bloc = context.read<FavoritesBloc>();
    DialogHelper.show(
      child: MyDialog(
        status: DialogStatus.danger,
        statusIcon: AppIcons.clear,
        title: l10n.clearFavoritesTitle,
        content: l10n.clearFavoritesMessage,
        primaryButton: DialogButton(
          text: l10n.clearAll,
          timerSeconds: 10,
          onPressed: () {
            bloc.add(const FavoritesClearedRequested());
            ToastHelper.show(
              msg: l10n.favoritesCleared,
              status: ToastStatus.info,
            );
          },
        ),
        secondaryButton: DialogButton(text: l10n.cancel),
      ),
    );
  }
}
