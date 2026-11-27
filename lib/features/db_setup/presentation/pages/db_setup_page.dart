import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/features/db_setup/domain/entities/db_setup_progress.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_cubit.dart';
import 'package:idiomer/features/db_setup/presentation/cubit/db_setup_state.dart';
import 'package:idiomer/shared/widgets/animations/my_animated_fade_switcher.dart';
import 'package:idiomer/shared/widgets/misc/my_empty_state.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_bar.dart';

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
          return Center(
            child: MyAnimatedFadeSwitcher(
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
          );
        },
      ),
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

    return Padding(
      padding: context.insetsAllM,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyProgressBar(
            label: stageLabel,
            showPercentage: true,
            value: hasDeterminateProgress ? progress : null,
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

    return MyEmptyState(
      icon: isNoInternet ? AppIcons.connectionError : AppIcons.error,
      title: title,
      subtitle: subtitle,
      actionText: l10n.tryAgain,
      onAction: context.read<DbSetupCubit>().retry,
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
