import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:finanzas_personales/core/errors/failure.dart';
import 'package:finanzas_personales/features/updates/data/repositories/update_repository_impl.dart';
import 'package:finanzas_personales/features/updates/domain/entities/update_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('In-App Updates & Semver (T-100, T-101, RF-25)', () {
    test('semver comparison detects newer versions', () {
      expect(isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(isNewerVersion('1.0.0', '1.1.0'), isTrue);
      expect(isNewerVersion('1.0.0', '2.0.0'), isTrue);
      expect(isNewerVersion('v1.0.0', 'v1.0.1'), isTrue);

      expect(isNewerVersion('1.0.1', '1.0.0'), isFalse);
      expect(isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(isNewerVersion('2.0.0', '1.9.9'), isFalse);
    });

    test(
      'checkForUpdate successfully parses GitHub releases API response',
      () async {
        final mockClient = MockClient((request) async {
          final body = jsonEncode({
            'tag_name': 'v1.1.0',
            'body': 'Novedades de la versión 1.1.0',
            'assets': [
              {
                'name': 'app-release.apk',
                'browser_download_url': 'https://github.com/TODO_OWNER/TODO_REPO/releases/download/v1.1.0/app-release.apk',
              },
            ],
          });
          return http.Response(
            body,
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final repo = UpdateRepositoryImpl(
          client: mockClient,
          currentVersion: '1.0.0',
        );

        final res = await repo.checkForUpdate();
        expect(res.isOk, isTrue);
        final info = res.valueOrNull!;
        expect(info.hasUpdate, isTrue);
        expect(info.latestVersion, 'v1.1.0');
        expect(info.releaseNotes, 'Novedades de la versión 1.1.0');
        expect(
          info.apkDownloadUrl,
          'https://github.com/TODO_OWNER/TODO_REPO/releases/download/v1.1.0/app-release.apk',
        );
      },
    );

    test('checkForUpdate handles network errors gracefully', () async {
      final mockClient = MockClient((request) async {
        throw const SocketException('No Internet Connection');
      });

      final repo = UpdateRepositoryImpl(client: mockClient);
      final res = await repo.checkForUpdate();

      expect(res.isError, isTrue);
      expect(res.errorOrNull!.code, FailureCode.networkError);
    });

    test('downloadAndVerifyUpdate verifies SHA-256 and rejects corrupted download', () async {
      final apkBytes = utf8.encode('dummy apk content');
      final validSha = sha256.convert(apkBytes).toString();

      final mockClient = MockClient((request) async {
        return http.Response.bytes(apkBytes, 200);
      });

      final repo = UpdateRepositoryImpl(client: mockClient);
      final tempFile =
          '${Directory.systemTemp.path}/test_apk_${DateTime.now().millisecondsSinceEpoch}.apk';

      // 1. Valid download
      final validRes = await repo.downloadAndVerifyUpdate(
        downloadUrl: 'https://example.com/app.apk',
        expectedSha256: validSha,
        destinationFilePath: tempFile,
      );
      expect(validRes.isOk, isTrue);
      expect(File(tempFile).existsSync(), isTrue);
      File(tempFile).deleteSync();

      // 2. Hash mismatch (tampered/corrupted download)
      final invalidRes = await repo.downloadAndVerifyUpdate(
        downloadUrl: 'https://example.com/app.apk',
        expectedSha256:
            '0000000000000000000000000000000000000000000000000000000000000000',
        destinationFilePath: tempFile,
      );
      expect(invalidRes.isError, isTrue);
      expect(
        invalidRes.errorOrNull!.code,
        FailureCode.sha256VerificationFailed,
      );
      // Ensure file was deleted after verification failed
      expect(File(tempFile).existsSync(), isFalse);
    });
  });
}
