import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_bloc.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_event.dart';
import 'package:idiomer/features/idioms/presentation/bloc/idioms_state.dart';
import 'package:idiomer/features/idioms/presentation/widgets/category_filter_bar.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_card.dart';
import 'package:idiomer/shared/widgets/appbars/my_app_bar.dart';
import 'package:idiomer/shared/widgets/input/my_text_field.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
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
      appBar: MyAppBar(
        title: l10n.appName,
        withLeading: false,
        centerTitle: true,
        isElevated: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.spaceM,
              context.spaceXs,
              context.spaceM,
              context.spaceS,
            ),
            child: MyTextField(
              controller: _searchController,
              isSearch: true,
              hintText: l10n.searchIdiomsHint,
              onChanged: (value) {
                context.read<IdiomsBloc>().add(IdiomsSearchChanged(value));
              },
            ),
          ),
          BlocBuilder<IdiomsBloc, IdiomsState>(
            buildWhen: (prev, curr) =>
                prev.categories != curr.categories ||
                prev.selectedCategoryId != curr.selectedCategoryId ||
                prev.isCategoriesExpanded != curr.isCategoriesExpanded,
            builder: (context, state) {
              return CategoryFilterBar(
                categories: state.categories,
                selectedCategoryId: state.selectedCategoryId,
                isExpanded: state.isCategoriesExpanded,
                onCategorySelected: (categoryId) {
                  context.read<IdiomsBloc>().add(
                    IdiomsCategorySelected(categoryId),
                  );
                },
                onToggleExpand: () {
                  context.read<IdiomsBloc>().add(
                    const IdiomsCategoryExpandToggled(),
                  );
                },
              );
            },
          ),
          Expanded(
            child: BlocBuilder<IdiomsBloc, IdiomsState>(
              builder: (context, state) {
                return _buildBody(context, state, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    IdiomsState state,
    AppLocalizations l10n,
  ) {
    if (state.status == IdiomsStatus.initial ||
        state.status == IdiomsStatus.loading) {
      return const Center(child: MyProgressIndicator());
    }

    if (state.status == IdiomsStatus.error) {
      return Center(
        child: MyEmptyState(
          icon: AppIcons.error,
          title: l10n.loadErrorTitle,
          subtitle: l10n.loadErrorSubtitle,
          actionText: l10n.retry,
          onAction: () {
            context.read<IdiomsBloc>().add(const IdiomsRetryRequested());
          },
        ),
      );
    }

    if (state.idioms.isEmpty) {
      if (state.hasActiveFilters) {
        return Center(
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
        );
      }

      return Center(
        child: MyEmptyState(
          icon: AppIcons.idioms,
          title: l10n.noIdiomsTitle,
          subtitle: l10n.noIdiomsSubtitle,
        ),
      );
    }

    final itemCount = state.idioms.length + (state.isLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        context.spaceM,
        context.spaceXs,
        context.spaceM,
        context.spaceXl,
      ),
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
          onToggleFavorite: () {
            context.read<IdiomsBloc>().add(IdiomsFavoriteToggled(idiom.id));
          },
        );
      },
    );
  }
}
