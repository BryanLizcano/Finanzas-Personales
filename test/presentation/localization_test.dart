import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/core/errors/failure_message.dart';
import 'package:finanzas_personales/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization & FailureCode translation', () {
    testWidgets('Spanish localizations translate all FailureCodes', (
      tester,
    ) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Container();
            },
          ),
        ),
      );

      for (final code in FailureCode.values) {
        final message = Failure(code).toLocalizedMessage(l10n);
        expect(
          message,
          isNotEmpty,
          reason: 'FailureCode $code missing Spanish translation',
        );
      }

      // Verify category translation
      expect(l10n.translateCategoryKey('fuel'), 'Gasolina / Combustible');
      expect(l10n.translateCategoryKey('partner'), 'Pareja');
      expect(l10n.translateCategoryKey('custom_key'), 'custom_key');
    });

    testWidgets('English localizations translate all FailureCodes', (
      tester,
    ) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Container();
            },
          ),
        ),
      );

      for (final code in FailureCode.values) {
        final message = Failure(code).toLocalizedMessage(l10n);
        expect(
          message,
          isNotEmpty,
          reason: 'FailureCode $code missing English translation',
        );
      }

      // Verify category translation
      expect(l10n.translateCategoryKey('fuel'), 'Fuel');
      expect(l10n.translateCategoryKey('partner'), 'Partner');
    });
  });
}
