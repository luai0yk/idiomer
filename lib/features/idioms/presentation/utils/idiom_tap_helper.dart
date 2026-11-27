import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idiomer/app/di/injection.dart';
import 'package:idiomer/app/routes/app_routes.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/helpers/settings_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_detail_usecase.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_sheet.dart';
import 'package:idiomer/features/settings/domain/entities/app_settings.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';

/// Opens either [IdiomDetailPage] or [IdiomShareSheet] based on user settings.
class IdiomTapHelper {
  IdiomTapHelper._();

  static Future<void> handleIdiomTap(
    BuildContext context, {
    required int idiomId,
    IdiomDetailEntity? detail,
  }) async {
    final action = SettingsHelper.readIdiomTapAction(context);
    if (action == IdiomTapAction.details) {
      context.push(AppRoutes.idiomDetailPath(idiomId));
      return;
    }

    final resolved =
        detail ?? await sl<WatchIdiomDetailUseCase>()(idiomId).first;
    if (!context.mounted) return;
    if (resolved == null) {
      ToastHelper.show(
        msg: context.l10n.idiomNotFoundTitle,
        status: ToastStatus.warning,
      );
      return;
    }
    await IdiomShareSheet.show(context: context, idiom: resolved);
  }
}
