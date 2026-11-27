import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_state.dart';
import 'package:idiomer/features/idioms/presentation/widgets/explore_header.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_card.dart';
import 'package:idiomer/features/idioms/presentation/widgets/select_category_sheet.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';

class IdiomsPage extends StatefulWidget {
  const IdiomsPage({super.key});

  @override
  State<IdiomsPage> createState() => _IdiomsPageState();
}

class _IdiomsPageState extends State<IdiomsPage> {
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
      context.read<IdiomsBloc>().add(const IdiomsLoadMoreRequested());
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child:
                BlocSelector<
                  IdiomsBloc,
                  IdiomsState,
                  ({
                    List<CategoryEntity> categories,
                    String? selectedCategoryId,
                  })
                >(
                  selector: (state) => (
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                  ),
                  builder: (context, filterState) {
                    return ExploreHeader(
                      trailing: MyIconButton.ghost(
                        icon: AppIcons.settings,
                        tooltip: l10n.settings,
                        iconColor: colorScheme.primary,
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                      searchController: _searchController,
                      onSearchChanged: (value) {
                        context.read<IdiomsBloc>().add(
                          IdiomsSearchChanged(value),
                        );
                      },
                      hasCategories: filterState.categories.isNotEmpty,
                      hasActiveCategoryFilter:
                          filterState.selectedCategoryId != null,
                      onOpenCategorySheet: () {
                        SelectCategorySheet.show(
                          context,
                          categories: filterState.categories,
                          selectedCategoryId: filterState.selectedCategoryId,
                          onCategorySelected: (categoryId) {
                            context.read<IdiomsBloc>().add(
                              IdiomsCategorySelected(categoryId),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
          ),
          BlocBuilder<IdiomsBloc, IdiomsState>(
            builder: (context, state) => _buildBodySliver(context, state, l10n),
          ),
        ],
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
        child: Center(child: MyLoadingState(label: l10n.loadingIdioms)),
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
              context.read<IdiomsBloc>().add(const IdiomsRetryRequested());
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
                context.read<IdiomsBloc>().add(const IdiomsFiltersCleared());
              },
            ),
          ),
        );
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: MyEmptyState(
            icon: AppIcons.idioms,
            title: l10n.noIdiomsTitle,
            subtitle: l10n.noIdiomsSubtitle,
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
            onTap: () => context.push(AppRoutes.idiomDetailPath(idiom.id)),
          );
        },
      ),
    );
  }
}
