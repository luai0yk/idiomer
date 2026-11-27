import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/services/cash/cash_service.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_attempt_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:idiomer/features/quiz/domain/usecases/watch_quiz_stats_usecase.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_overview_page.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_stat_card.dart';
import 'package:idiomer/shared/widgets/buttons/my_floating_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubQuizRepository implements QuizRepository {
  final QuizStatsEntity stats;

  _StubQuizRepository(this.stats);

  @override
  Stream<QuizStatsEntity> watchQuizStats() => Stream.value(stats);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await CashService.instance.init();
  });

  testWidgets(
    'QuizOverviewPage removes FAB and displays compact New Quiz card under stats cards',
    (tester) async {

      final stats = QuizStatsEntity(
        totalQuizzes: 1,
        averagePercentage: 75,
        attempts: [
          QuizAttemptEntity(
            id: 1,
            totalQuestions: 8,
            correctAnswers: 6,
            durationSeconds: 45,
            completedAt: DateTime(2026, 11, 27, 13, 0),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider(
            create: (_) => QuizOverviewCubit(
              watchQuizStats: WatchQuizStatsUseCase(_StubQuizRepository(stats)),
            )..watchStats(),
            child: const QuizOverviewPage(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(MyFloatingButton), findsNothing);
      expect(find.byType(QuizStatCard), findsNWidgets(2));

      final newQuizCard = find.text('New Quiz');
      final statCard = find.byType(QuizStatCard).first;
      final historyHeading = find.text('Quiz History');

      expect(newQuizCard, findsOneWidget);
      expect(
        tester.getCenter(newQuizCard).dy,
        greaterThan(tester.getBottomRight(statCard).dy),
      );
      expect(
        tester.getCenter(newQuizCard).dy,
        lessThan(tester.getCenter(historyHeading).dy),
      );
    },
  );
}
