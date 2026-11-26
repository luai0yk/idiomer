import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_assets.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_state.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_fade_switcher.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/images/my_image.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';

class DbSetupPage extends StatefulWidget {
  const DbSetupPage({super.key});

  @override
  State<DbSetupPage> createState() => _DbSetupPageState();
}

class _DbSetupPageState extends State<DbSetupPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DbSetupCubit>().startSetup();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<DbSetupCubit, DbSetupState>(
        listenWhen: (prev, curr) =>
            prev.stage != curr.stage && curr.stage == DbSetupStage.ready,
        listener: (context, state) {
          context.go(AppRoutes.home);
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.insetsAllL,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.setSize(420)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBrandHeader(context, textTheme, colorScheme, l10n),
                      context.verticalSpace(24),
                      MyAnimatedFadeSwitcher(
                        duration: AppDurations.fast,
                        child: state.stage == DbSetupStage.error
                            ? _buildErrorCard(context, state, l10n)
                            : _buildProgressCard(
                                context,
                                state,
                                textTheme,
                                colorScheme,
                                l10n,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandHeader(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyCard.filled(
          padding: context.insetsAllS,
          borderRadius: context.brL,
          color: colorScheme.primaryContainer.withValues(alpha: 0.16),
          child: MyImage.asset(
            asset: AppAssets.appIcon,
            width: context.setSize(56),
            height: context.setSize(56),
            fit: BoxFit.contain,
            borderRadius: context.brM,
          ),
        ),
        context.verticalSpace(12),
        Text(
          l10n.appName,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        context.verticalSpace(6),
        Text(
          l10n.dbSetupSubtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    DbSetupState state,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final stageLabel = _stageLabel(state.stage, l10n);
    final progress = state.progress;
    final hasDeterminateProgress =
        progress != null &&
        (state.stage == DbSetupStage.downloading ||
            state.stage == DbSetupStage.extracting);

    return MyCard.bordered(
      key: const ValueKey('setup_progress'),
      padding: context.insetsAllL,
      borderRadius: context.brL,
      color: colorScheme.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              MyProgressIndicator(
                size: context.setSize(24),
                strokeWidth: context.setSize(2.8),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Text(
                  stageLabel,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (hasDeterminateProgress)
                Text(
                  '${(progress * 100).round()}%',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
          context.verticalSpace(16),
          ClipRRect(
            borderRadius: context.brCircular,
            child: LinearProgressIndicator(
              value: hasDeterminateProgress ? progress : null,
              minHeight: context.setSize(8),
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          if (state.stage == DbSetupStage.downloading &&
              state.totalBytes > 0) ...[
            context.verticalSpace(10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                '${_formatMegabytes(state.receivedBytes)} / ${_formatMegabytes(state.totalBytes)}',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context,
    DbSetupState state,
    AppLocalizations l10n,
  ) {
    final isNoInternet = state.errorType == DbSetupErrorType.noInternet;
    final title = isNoInternet
        ? l10n.noInternetTitle
        : _errorTitle(state.errorType, l10n);
    final subtitle = isNoInternet
        ? l10n.noInternetSubtitle
        : _errorSubtitle(state.errorType, l10n);

    return MyCard.bordered(
      key: const ValueKey('setup_error'),
      padding: context.insetsAllL,
      borderRadius: context.brL,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyEmptyState(
            icon: isNoInternet ? AppIcons.connectionError : AppIcons.error,
            title: title,
            subtitle: subtitle,
            size: MyEmptyStateSize.small,
          ),
          context.verticalSpace(12),
          MyButton.primary(
            text: l10n.retry,
            prefixIcon: AppIcons.refresh,
            onPressed: () => context.read<DbSetupCubit>().retry(),
          ),
        ],
      ),
    );
  }

  String _stageLabel(DbSetupStage stage, AppLocalizations l10n) {
    return switch (stage) {
      DbSetupStage.checking => l10n.dbChecking,
      DbSetupStage.downloading => l10n.dbDownloading,
      DbSetupStage.extracting => l10n.dbExtracting,
      DbSetupStage.verifying => l10n.dbVerifying,
      DbSetupStage.ready => l10n.dbReady,
      DbSetupStage.error => l10n.dbSetupFailedTitle,
    };
  }

  String _errorTitle(DbSetupErrorType? errorType, AppLocalizations l10n) {
    return switch (errorType) {
      DbSetupErrorType.noInternet => l10n.noInternetTitle,
      DbSetupErrorType.networkError => l10n.dbDownloadFailedTitle,
      DbSetupErrorType.extractionFailed => l10n.dbExtractionFailedTitle,
      DbSetupErrorType.verificationFailed => l10n.dbVerificationFailedTitle,
      DbSetupErrorType.unknown || null => l10n.dbSetupFailedTitle,
    };
  }

  String _errorSubtitle(DbSetupErrorType? errorType, AppLocalizations l10n) {
    return switch (errorType) {
      DbSetupErrorType.noInternet => l10n.noInternetSubtitle,
      DbSetupErrorType.networkError => l10n.dbDownloadFailedSubtitle,
      DbSetupErrorType.extractionFailed => l10n.dbExtractionFailedSubtitle,
      DbSetupErrorType.verificationFailed => l10n.dbVerificationFailedSubtitle,
      DbSetupErrorType.unknown || null => l10n.dbSetupFailedSubtitle,
    };
  }

  String _formatMegabytes(int bytes) {
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }
}
