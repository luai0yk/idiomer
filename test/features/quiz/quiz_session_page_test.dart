import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idiomer/app/l10n/app_localizations.dart';
import 'package:idiomer/app/theme/material_theme.dart';
import 'package:idiomer/core/constants/app_durations.dart';
import 'package:idiomer/core/constants/app_icons.dart';
import 'package:idiomer/core/database/app_database.dart';
import 'package:idiomer/core/utils/helpers/ui/app_navigator.dart';
import 'package:idiomer/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:idiomer/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:idiomer/features/quiz/domain/usecases/generate_quiz_usecase.dart';
import 'package:idiomer/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:idiomer/features/quiz/presentation/cubit/quiz_session_state.dart';
import 'package:idiomer/features/quiz/presentation/pages/quiz_session_page.dart';
import 'package:idiomer/features/quiz/presentation/widgets/quiz_option_card.dart';
import 'package:idiomer/shared/widgets/buttons/my_button.dart';
import 'package:idiomer/shared/widgets/buttons/my_icon_button.dart';
import 'package:idiomer/shared/widgets/cards/my_card.dart';
import 'package:idiomer/shared/widgets/misc/my_loading_state.dart';

import 'quiz_test.dart';

void main() {
  testWidgets(
    'QuizSessionPage slides between questions, uses ghost arrow buttons, and advances on option tap',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await seedQuizIdioms(db, total: 10);

      final dataSource = QuizLocalDataSourceImpl(
        database: db,
        random: Random(42),
      );
      final repository = QuizRepositoryImpl(localDataSource: dataSource);
      final cubit = QuizSessionCubit(
        generateQuiz: GenerateQuizUseCase(repository),
        saveQuizAttempt: SaveQuizAttemptUseCase(repository),
      );

      await cubit.startQuiz();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const QuizSessionPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Old Previous/Next MyButtons and card counter label are removed; ghost arrow buttons exist instead.
      expect(find.widgetWithText(MyButton, 'Previous'), findsNothing);
      expect(find.widgetWithText(MyButton, 'Next'), findsNothing);
      expect(find.text('1 / 8'), findsNothing);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byTooltip('Previous'), findsOneWidget);
      expect(find.byTooltip('Next'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byTooltip('Previous'),
          matching: find.byType(MyIconButton),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byTooltip('Next'),
          matching: find.byType(MyIconButton),
        ),
        findsOneWidget,
      );

      // Ghost arrow nav sits above the options and stays compact at the start.
      final nextFinder = find.byTooltip('Next');
      final firstOptionFinder = find.byType(QuizOptionCard).first;
      expect(
        tester.getCenter(nextFinder).dy,
        lessThan(tester.getCenter(firstOptionFinder).dy),
      );
      expect(
        tester.getBottomRight(nextFinder).dx,
        lessThan(tester.getCenter(firstOptionFinder).dx),
      );

      // Navigate forward and backward using the ghost arrow buttons.
      expect(cubit.state.currentIndex, 0);
      await tester.tap(find.byTooltip('Next'));
      await tester.pumpAndSettle();
      expect(cubit.state.currentIndex, 1);

      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      expect(cubit.state.currentIndex, 0);

      // Slide between questions via horizontal drag on PageView.
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(cubit.state.currentIndex, 1);

      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(cubit.state.currentIndex, 0);

      // Tapping an answer option selects it and auto-advances to the next question.
      for (int i = 0; i < 8; i++) {
        expect(cubit.state.currentIndex, i);
        await tester.tap(find.byType(QuizOptionCard).first);
        await tester.pump();
        await tester.pump(AppDurations.fast + const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
      }

      expect(cubit.state.allAnswered, isTrue);
      expect(cubit.state.currentIndex, 7);

      // Submit Quiz button appears once all questions are answered.
      final submitFinder = find.widgetWithText(MyButton, 'Submit Quiz');
      expect(submitFinder, findsOneWidget);

      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(cubit.state.status, QuizSessionStatus.completed);
      expect(find.byIcon(AppIcons.checkCircle), findsWidgets);

      await cubit.close();
      await db.close();
    },
  );

  testWidgets(
    'QuizSessionPage shows flat MyLoadingState with Preparing quiz text while loading',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await seedQuizIdioms(db, total: 10);

      final dataSource = QuizLocalDataSourceImpl(
        database: db,
        random: Random(42),
      );
      final repository = QuizRepositoryImpl(localDataSource: dataSource);
      final cubit = QuizSessionCubit(
        generateQuiz: GenerateQuizUseCase(repository),
        saveQuizAttempt: SaveQuizAttemptUseCase(repository),
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavigator.key,
          theme: const MaterialTheme().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const QuizSessionPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(MyLoadingState), findsOneWidget);
      expect(find.text('Preparing quiz...'), findsOneWidget);
      expect(find.byType(MyCard), findsNothing);

      final arLocalizations = await AppLocalizations.delegate.load(
        const Locale('ar'),
      );
      expect(arLocalizations.submitQuiz, 'تأكيد الإجابات');

      await cubit.close();
      await db.close();
    },
  );
}
