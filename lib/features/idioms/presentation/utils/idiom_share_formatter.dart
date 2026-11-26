import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/shared/widgets/texts/highlighted_markup_text.dart';

/// Formats an [IdiomDetailEntity] into clean shareable text.
class IdiomShareFormatter {
  IdiomShareFormatter._();

  static String format(IdiomDetailEntity idiom) {
    final buffer = StringBuffer()
      ..writeln(idiom.englishText)
      ..writeln(idiom.arabicText);

    if (idiom.definitions.isNotEmpty) {
      buffer.writeln();
      for (final def in idiom.definitions) {
        final enMeaning = HighlightedMarkupText.stripMarkers(
          def.englishMeaning,
        );
        final arMeaning = HighlightedMarkupText.stripMarkers(def.arabicMeaning);
        buffer.writeln('- $enMeaning');
        if (arMeaning.trim().isNotEmpty) {
          buffer.writeln('  $arMeaning');
        }
      }
    }

    if (idiom.examples.isNotEmpty) {
      buffer.writeln();
      for (final ex in idiom.examples) {
        final enSentence = HighlightedMarkupText.stripMarkers(
          ex.englishSentence,
        );
        final arSentence = HighlightedMarkupText.stripMarkers(
          ex.arabicSentence,
        );
        buffer.writeln('• $enSentence');
        if (arSentence.trim().isNotEmpty) {
          buffer.writeln('  $arSentence');
        }
      }
    }

    if (idiom.englishNotes != null && idiom.englishNotes!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln(idiom.englishNotes!.trim());
    }

    return buffer.toString().trim();
  }
}
