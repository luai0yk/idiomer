---
name: project-shared-widgets
description: >-
  Guides selection and usage of existing custom widgets in lib/shared/widgets/ and
  controllers in lib/shared/controller/. Use when building or editing any Flutter UI
  component, screen, form, button, card, tile, list, chip, image, picker, or
  animation so raw Material/Flutter widgets are not used and duplicate widgets are
  not created.
---

# Project Shared Widgets

Use existing components from `lib/shared/widgets/` and `lib/shared/controller/` instead of raw Flutter/Material widgets or creating new custom widgets.

## Rules

1. **Check the catalog first**: Before writing any UI widget, check [widget-catalog.md](./references/widget-catalog.md) and `lib/shared/widgets/` for an existing component.
2. **Never use raw Flutter widgets** when a project widget exists (see mapping below).
3. **Never create a new shared or local widget** that duplicates an existing `My*` or custom widget. Extend or configure the existing widget instead.
4. **Pair pickers/selectors with their `shared/controller/`**: Use `ImagePickerController`, `SegmentButtonController`, `SelectableChipListController`, and `SelectableListController` when state needs external control.
5. **Pair overlays with `core` UI helpers**: Always display `MyDialog` via `DialogHelper.show`, `MyProgressDialog` via `ProgressDialog.show`, `MyBottomSheet` via `BottomSheetHelper.show`, `MySnackBar` via `SnackBarHelper.show`, and `MyToast` via `ToastHelper.show`.

## Raw Flutter Widget -> Project Replacement

| Raw Flutter / Material Widget | Use Project Widget Instead | Location |
| :--- | :--- | :--- |
| `AppBar` | `MyAppBar` | `shared/widgets/appbars/my_app_bar.dart` |
| `SliverAppBar` | `MySliverAppBar` / `MySliverAppBar.expanded` | `shared/widgets/appbars/my_sliver_app_bar.dart` |
| `SliverPersistentHeader` | `MySliverHeader` / `SliverHeaderDelegate` | `shared/widgets/appbars/sliver_header_delegate.dart` |
| `ElevatedButton`, `OutlinedButton`, `TextButton` | `MyButton.primary`, `.outlined`, `.outlinedNeutral`, `.text` | `shared/widgets/buttons/my_button.dart` |
| `IconButton` | `MyIconButton.solid`, `.outlined`, `.ghost`, `.bordered` | `shared/widgets/buttons/my_icon_button.dart` |
| `FloatingActionButton` | `MyFloatingButton`, `MyFloatingButton.extended` | `shared/widgets/buttons/my_floating_button.dart` |
| `PopupMenuButton` | `MyPopupMenu<T>` + `MyPopupMenuItem<T>` | `shared/widgets/buttons/my_popup_menu.dart` |
| `SegmentedButton` | `MySegmentButton<T>` + `MyButtonSegment<T>` | `shared/widgets/buttons/my_segment_button.dart` |
| `Card` | `MyCard.elevated`, `.outlined`, `.filled`, `.bordered` | `shared/widgets/cards/my_card.dart` |
| Sectioned card group | `MySectionCard` | `shared/widgets/cards/my_section_card.dart` |
| `Chip` / `FilterChip` / `ChoiceChip` | `AnimatedChip` | `shared/widgets/chips/animated_chip.dart` |
| `AlertDialog` / `Dialog` | `MyDialog` + `DialogButton` (via `DialogHelper.show`) | `shared/widgets/dialogs/my_dialog.dart` |
| `Image.network`, `Image.asset`, `Image.file` | `MyImage.network`, `.asset`, `.file` | `shared/widgets/images/my_image.dart` |
| `TextField` / `TextFormField` | `MyTextField` / `MyTextField.plain` | `shared/widgets/input/my_text_field.dart` |
| `DropdownButtonFormField` | `MyDropdownField<T>` + `MyDropdownItem<T>` | `shared/widgets/input/my_dropdown_field.dart` |
| `Checkbox` | `MyCheckbox` | `shared/widgets/input/my_checkbox.dart` |
| `Radio` | `MyRadio<T>` | `shared/widgets/input/my_radio.dart` |
| `Switch` | `MySwitch` | `shared/widgets/input/my_switch.dart` |
| `ListTile` | `MyListTile` | `shared/widgets/tiles/my_list_tile.dart` |
| `CheckboxListTile` | `MyCheckboxTile` | `shared/widgets/tiles/my_checkbox_tile.dart` |
| `RadioListTile` | `MyRadioTile<T>` | `shared/widgets/tiles/my_radio_tile.dart` |
| `SwitchListTile` | `MySwitchTile` | `shared/widgets/tiles/my_switch_tile.dart` |
| `ExpansionTile` | `MyExpansionTile` | `shared/widgets/tiles/my_expansion_tile.dart` |
| `Icon` (for app icons with filled/outline state) | `MyIcon` | `shared/widgets/misc/my_icon.dart` |
| `CircleAvatar` | `MyAvatar` | `shared/widgets/misc/my_avatar.dart` |
| `BottomNavigationBar` / `NavigationBar` | `MyBottomNavigationBar` + `MyBottomNavigationBarItem` | `shared/widgets/misc/my_bottom_navigation_bar.dart` |
| `CircularProgressIndicator` | `MyProgressIndicator` | `shared/widgets/misc/my_progress_indicator.dart` |
| `Stepper` | `MyStepper` + `MyStep` | `shared/widgets/misc/my_stepper.dart` |
| `AnimatedSwitcher` / `AnimatedOpacity` | `MyAnimatedFadeSwitcher`, `MyAnimatedScaleSwitcher`, `MyAnimatedScaleFadeSwitcher`, `MyAnimatedVisibility` | `shared/widgets/animations/` |

## Verification

Before finishing any UI change, verify:
- No raw Material widgets from the left column above were introduced.
- All imported widgets come from `package:idiomer/shared/widgets/...`.
- `dart analyze` reports no issues on modified files.
