# Shared Widgets & Controllers Catalog

Complete inventory of `lib/shared/widgets/` and `lib/shared/controller/`. Inspect the target file for exact optional parameters before use.

## Animations (`lib/shared/widgets/animations/`)
- `MyAnimatedFadeSwitcher` (`my_animated_fade_switcher.dart`)
- `MyAnimatedScaleFadeSwitcher` (`my_animated_scale_fade_switcher.dart`)
- `MyAnimatedScaleSwitcher` (`my_animated_scale_switcher.dart`)
- `MyAnimatedVisibility` (`my_animated_visibility.dart`)

## AppBars & Headers (`lib/shared/widgets/appbars/`)
- `MyAppBar` (`my_app_bar.dart`)
- `MyGradientHeader`, `ScrollUnderHeaderColumn` (`my_gradient_header.dart`)
- `MySliverAppBar`, `MySliverAppBar.expanded` (`my_sliver_app_bar.dart`)
- `MySliverHeader`, `SliverHeaderDelegate` (`sliver_header_delegate.dart`)

## Buttons (`lib/shared/widgets/buttons/`)
- `MyButton` (`my_button.dart`): `.primary`, `.outlined`, `.outlinedNeutral`, `.text` (supports `prefixIcon`, `suffixIcon`, `isDisabled`, `timerSeconds`, async `onPressed` loading state, `AppButtonTextStyle`)
- `MyFavoriteButton` (`my_favorite_button.dart`)
- `MyFloatingButton`, `MyFloatingButton.extended` (`my_floating_button.dart`)
- `MyIconButton` (`my_icon_button.dart`): `.solid`, `.outlined`, `.ghost`, `.bordered` (supports `isSelected`, async `onPressed` loading state)
- `MyPopupMenu<T>`, `MyPopupMenuItem<T>` (`my_popup_menu.dart`)
- `MySegmentButton<T>`, `MyButtonSegment<T>`, `SegmentButtonSize` (`my_segment_button.dart`)

## Cards (`lib/shared/widgets/cards/`)
- `MyCard` (`my_card.dart`): `.elevated`, `.outlined`, `.filled`, `.bordered`
- `MySectionCard` (`my_section_card.dart`): Grouped settings/section container with title and children

## Chips (`lib/shared/widgets/chips/`)
- `AnimatedChip` (`animated_chip.dart`)

## Dialogs (`lib/shared/widgets/dialogs/`)
- `MyDialog`, `DialogButton`, `DialogStatus` (`standard`, `success`, `warning`, `danger`, `info`) (`my_dialog.dart`)
- `MyProgressDialog` (`my_progress_dialog.dart`)

## Images (`lib/shared/widgets/images/`)
- `MyImage` (`my_image.dart`): `MyImage.network`, `MyImage.asset`, `MyImage.file` (supports skeleton loading, borders, `isViewable`)
- `ImageViewerPage` (`image_viewer_page.dart`)

## Inputs (`lib/shared/widgets/input/`)
- `MyTextField` (`my_text_field.dart`): standard and `.plain`
- `MyDropdownField<T>`, `MyDropdownItem<T>` (`my_dropdown_field.dart`)
- `MyCheckbox` (`my_checkbox.dart`)
- `MyRadio<T>` (`my_radio.dart`)
- `MySwitch` (`my_switch.dart`)

## Lists (`lib/shared/widgets/lists/`)
- `SelectableChipList<T>`, `SelectableChip<T>` (`.single`, `.multi`) (`selectable_chip_list.dart`)
- `SelectableList<T>` (`.single`, `.multi`, supports `enableSearch`) (`selectable_list.dart`)

## Misc (`lib/shared/widgets/misc/`)
- `InfoRow` (`info_row.dart`)
- `MyAvatar` (`my_avatar.dart`)
- `MyBottomNavigationBar`, `MyBottomNavigationBarItem`, `MyBottomNavigationBarDisplayMode`, `MyBottomNavigationBarAnimation`, `MyBottomNavigationBarItemOrientation` (`my_bottom_navigation_bar.dart`)
- `MyDotIndicator`, `DotIndicatorEffect` (`my_dot_indicator.dart`)
- `MyEmptyState`, `MyEmptyStateSize` (`my_empty_state.dart`)
- `MyIcon` (`my_icon.dart`)
- `MyLoadingState` (`my_loading_state.dart`)
- `MyProgressIndicator` (`my_progress_indicator.dart`)
- `MySnackBar`, `SnackBarStatus` (`my_snackbar.dart`)
- `MyStepper`, `MyStep` (`my_stepper.dart`)
- `MyToast`, `ToastStatus` (`my_toast.dart`)

## Pickers (`lib/shared/widgets/pickers/`)
- `MyColorPicker` (`my_color_picker.dart`)
- `MySimpleColorPicker` (`my_simple_color_picker.dart`)
- `MyDateRangePicker` (`my_date_range_picker.dart`)
- `MyDateTimePicker`, `MyDateBottomPickerMode` (`my_date_time_picker.dart`)
- `MyIconPicker` (`my_icon_picker.dart`)
- `MyImagePicker` (`my_image_picker.dart`)

## Sheets (`lib/shared/widgets/sheets/`)
- `MyBottomSheet`, `SheetButton`, `BottomSheetStatus` (`my_bottom_sheet.dart`)

## Texts (`lib/shared/widgets/texts/`)
- `InlineTextAction` (`inline_text_action.dart`)
- `TextSeparator` (`text_separator.dart`)

## Tiles (`lib/shared/widgets/tiles/`)
- `MyActionTile` (`my_action_tile.dart`)
- `MyCheckboxTile` (`my_checkbox_tile.dart`)
- `MyExpansionTile` (`my_expansion_tile.dart`)
- `MyListTile` (`my_list_tile.dart`)
- `MyRadioTile<T>` (`my_radio_tile.dart`)
- `MySwitchTile` (`my_switch_tile.dart`)

## Shared Controllers (`lib/shared/controller/`)
- `ImagePickerController` (`image_picker_controller.dart`)
- `SegmentButtonController<T>` (`segment_button_controller.dart`)
- `SelectableChipListController<T>`, `SelectableChipListType` (`selectable_chip_list_controller.dart`)
- `SelectableListController<T>`, `SelectableListType` (`selectable_list_controller.dart`)
