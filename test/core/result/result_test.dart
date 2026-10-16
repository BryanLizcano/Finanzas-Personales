import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success returns value and isOk is true', () {
      const result = Result<int, Failure>.ok(42);

      expect(result.isOk, isTrue);
      expect(result.isError, isFalse);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
      expect(
        result.fold(onOk: (v) => 'value: $v', onError: (e) => 'error: $e'),
        'value: 42',
      );
    });

    test('Error returns failure and isError is true', () {
      const failure = Failure(FailureCode.invalidAmount, 'Amount must be > 0');
      const result = Result<int, Failure>.error(failure);

      expect(result.isOk, isFalse);
      expect(result.isError, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, failure);
      expect(
        result.fold(
          onOk: (v) => 'value: $v',
          onError: (e) => e.code.toString(),
        ),
        'FailureCode.invalidAmount',
      );
    });
  });
}
