import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';
import 'package:idiomer/core/utils/extensions/responsive_size.dart';
import 'package:idiomer/core/utils/extensions/responsive_values.dart';
import 'package:idiomer/core/utils/helpers/misc/idiom_image_saver.dart';
import 'package:idiomer/core/utils/helpers/misc/share_helper.dart';
import 'package:idiomer/core/utils/helpers/misc/url_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/toast_helper.dart';
import 'package:idiomer/core/utils/helpers/ui/widget_capture_helper.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/presentation/utils/idiom_share_formatter.dart';
import 'package:idiomer/features/idioms/presentation/widgets/idiom_share_card.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_icon.dart';
import 'package:idiomer/shared/widgets/misc/my_progress_indicator.dart';
import 'package:idiomer/shared/widgets/misc/my_toast.dart';
import 'package:idiomer/shared/widgets/sheets/my_bottom_sheet.dart';

class IdiomShareSheet extends StatefulWidget {
  final IdiomDetailEntity idiom;
  final Animation<double>? animation;
  final Future<void> Function(String text)? onShareText;
  final Future<void> Function(File file)? onShareImage;
  final Future<bool> Function(String text)? onShareWhatsApp;
  final Future<String?> Function(Uint8List bytes, String fileName)? onSaveImage;

  const IdiomShareSheet({
    super.key,
    required this.idiom,
    this.animation,
    this.onShareText,
    this.onShareImage,
    this.onShareWhatsApp,
    this.onSaveImage,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required IdiomDetailEntity idiom,
    Future<void> Function(String text)? onShareText,
    Future<void> Function(File file)? onShareImage,
    Future<bool> Function(String text)? onShareWhatsApp,
    Future<String?> Function(Uint8List bytes, String fileName)? onSaveImage,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: AppDurations.medium,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return IdiomShareSheet(
          idiom: idiom,
          animation: animation,
          onShareText: onShareText,
          onShareImage: onShareImage,
          onShareWhatsApp: onShareWhatsApp,
          onSaveImage: onSaveImage,
        );
      },
    );
  }

  @override
  State<IdiomShareSheet> createState() => _IdiomShareSheetState();
}

class _IdiomShareSheetState extends State<IdiomShareSheet> {
  final GlobalKey _cardKey = GlobalKey();

  String get _formattedText => IdiomShareFormatter.format(widget.idiom);

  Future<void> _handleWhatsApp(BuildContext context) async {
    final l10n = context.l10n;
    final launched = widget.onShareWhatsApp != null
        ? await widget.onShareWhatsApp!(_formattedText)
        : await UrlHelper.shareToWhatsApp(_formattedText);
    if (!launched && context.mounted) {
      ToastHelper.show(
        msg: l10n.whatsappUnavailable,
        status: ToastStatus.warning,
      );
    }
  }

  Future<void> _handleCopy(BuildContext context) async {
    final l10n = context.l10n;
    await Clipboard.setData(ClipboardData(text: _formattedText));
    if (context.mounted) {
      ToastHelper.show(
        msg: l10n.copiedToClipboard,
        status: ToastStatus.success,
      );
    }
  }

  Future<void> _handleSaveImage(BuildContext context) async {
    final l10n = context.l10n;
    try {
      final bytes = await WidgetCaptureHelper.captureToBytes(
        boundaryKey: _cardKey,
      );
      if (bytes == null) {
        if (context.mounted) {
          ToastHelper.show(
            msg: l10n.failedToSaveImage,
            status: ToastStatus.danger,
          );
        }
        return;
      }

      final fileName = IdiomImageSaver.buildFileName(widget.idiom.englishText);
      final savedPath = widget.onSaveImage != null
          ? await widget.onSaveImage!(bytes, fileName)
          : await IdiomImageSaver.saveToDownloads(
              bytes: bytes,
              idiomText: widget.idiom.englishText,
            );

      if (savedPath != null && context.mounted) {
        ToastHelper.show(
          msg: l10n.imageSavedToDownloads,
          status: ToastStatus.success,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ToastHelper.show(
          msg: l10n.failedToSaveImage,
          status: ToastStatus.danger,
        );
      }
    }
  }

  Future<void> _handleShareImage(BuildContext context) async {
    final l10n = context.l10n;
    try {
      final file = await WidgetCaptureHelper.captureToFile(
        boundaryKey: _cardKey,
        filePrefix: 'idiomer_${widget.idiom.id}',
      );
      if (file == null) {
        if (context.mounted) {
          ToastHelper.show(msg: l10n.failedToShare, status: ToastStatus.danger);
        }
        return;
      }
      if (widget.onShareImage != null) {
        await widget.onShareImage!(file);
      } else {
        await ShareHelper.shareFile(file);
      }
    } catch (_) {
      if (context.mounted) {
        ToastHelper.show(msg: l10n.failedToShare, status: ToastStatus.danger);
      }
    }
  }

  Future<void> _handleShareText(
    BuildContext context, {
    bool withSubject = false,
  }) async {
    final l10n = context.l10n;
    try {
      if (widget.onShareText != null) {
        await widget.onShareText!(_formattedText);
      } else {
        await ShareHelper.shareText(
          _formattedText,
          subject: withSubject ? widget.idiom.englishText : null,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ToastHelper.show(msg: l10n.failedToShare, status: ToastStatus.danger);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;

    final anim =
        widget.animation ??
        ModalRoute.of(context)?.animation ??
        kAlwaysCompleteAnimation;

    final sheetSlide =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spaceL,
                        vertical: context.spaceM,
                      ),
                      child: IdiomShareCard(
                        idiom: widget.idiom,
                        boundaryKey: _cardKey,
                        animation: anim,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SlideTransition(
                  position: sheetSlide,
                  child: MyBottomSheet(
                    title: l10n.shareIdiom,
                    hideHandle: false,
                    padding: EdgeInsets.fromLTRB(
                      context.spaceM,
                      context.spaceXs,
                      context.spaceM,
                      context.spaceL,
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: context.spaceS,
                      crossAxisSpacing: context.spaceS,
                      mainAxisExtent: context.setSize(90),
                      children: [
                        _ShareGridButton(
                          icon: AppIcons.importBackup,
                          label: l10n.saveAsImage,
                          accentColor: extendedColors.info.color,
                          onTap: () => _handleSaveImage(context),
                        ),
                        _ShareGridButton(
                          icon: AppIcons.copy,
                          label: l10n.copy,
                          accentColor: colorScheme.primary,
                          onTap: () => _handleCopy(context),
                        ),
                        _ShareGridButton(
                          icon: AppIcons.gallery,
                          label: l10n.shareAsImage,
                          accentColor: colorScheme.tertiary,
                          onTap: () => _handleShareImage(context),
                        ),
                        _ShareGridButton(
                          icon: AppIcons.text,
                          label: l10n.shareAsText,
                          accentColor: colorScheme.secondary,
                          onTap: () => _handleShareText(context),
                        ),
                        _ShareGridButton(
                          icon: AppIcons.whatsapp,
                          label: l10n.shareViaWhatsApp,
                          accentColor: extendedColors.success.color,
                          onTap: () => _handleWhatsApp(context),
                        ),
                        _ShareGridButton(
                          icon: AppIcons.more,
                          label: l10n.shareOther,
                          accentColor: colorScheme.onSurfaceVariant,
                          onTap: () =>
                              _handleShareText(context, withSubject: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareGridButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final Future<void> Function() onTap;

  const _ShareGridButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ShareGridButton> createState() => _ShareGridButtonState();
}

class _ShareGridButtonState extends State<_ShareGridButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onTap();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return MyCard.filled(
      borderRadius: context.brXl,
      padding: context.insetsAllS,
      onTap: _isLoading ? null : _handleTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.setSize(34),
            height: context.setSize(34),
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _isLoading
                  ? MyProgressIndicator(
                      size: context.iconS,
                      color: widget.accentColor,
                      strokeWidth: context.setSize(2.2),
                    )
                  : MyIcon(
                      icon: widget.icon,
                      size: context.iconS,
                      color: widget.accentColor,
                    ),
            ),
          ),
          context.verticalSpace(8),
          Text(
            widget.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
