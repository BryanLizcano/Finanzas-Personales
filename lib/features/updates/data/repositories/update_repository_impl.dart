import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/update_info.dart';
import '../../domain/repositories/update_repository.dart';

class UpdateRepositoryImpl implements UpdateRepository {
  final http.Client _client;
  final String currentVersion;
  final String owner;
  final String repo;

  // GitHub repository configuration for In-App Updates
  static const defaultOwner = 'BryanLizcano';
  static const defaultRepo = 'Finanzas-Personales';

  UpdateRepositoryImpl({
    http.Client? client,
    this.currentVersion = '1.2.0',
    this.owner = defaultOwner,
    this.repo = defaultRepo,
  }) : _client = client ?? http.Client();

  @override
  Future<Result<UpdateInfo, Failure>> checkForUpdate() async {
    try {
      final uri = Uri.parse(
        'https://api.github.com/repos/$owner/$repo/releases/latest',
      );
      final response = await _client
          .get(uri, headers: {'Accept': 'application/vnd.github.v3+json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return const Result.error(
          Failure(
            FailureCode.networkError,
            'Unable to fetch latest release from GitHub API',
          ),
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Result.error(
          Failure(FailureCode.networkError, 'Invalid GitHub API response'),
        );
      }

      final tagName = decoded['tag_name'] as String? ?? '';
      final body = decoded['body'] as String? ?? '';
      final assets = (decoded['assets'] as List?) ?? [];

      String apkUrl = '';
      String? sha256Expected;

      for (final asset in assets) {
        if (asset is Map<String, dynamic>) {
          final name = asset['name'] as String? ?? '';
          if (name.endsWith('.apk')) {
            apkUrl = asset['browser_download_url'] as String? ?? '';
          }
          if (name.endsWith('.sha256')) {
            // Optional direct sha256 asset
            final shaUrl = asset['browser_download_url'] as String? ?? '';
            if (shaUrl.isNotEmpty) {
              try {
                final shaRes = await _client
                    .get(Uri.parse(shaUrl))
                    .timeout(const Duration(seconds: 5));
                if (shaRes.statusCode == 200) {
                  sha256Expected = shaRes.body.trim().split(' ').first;
                }
              } catch (_) {}
            }
          }
        }
      }

      final hasUpdate = isNewerVersion(currentVersion, tagName);

      return Result.ok(
        UpdateInfo(
          currentVersion: currentVersion,
          latestVersion: tagName,
          hasUpdate: hasUpdate,
          releaseNotes: body,
          apkDownloadUrl: apkUrl,
          sha256Expected: sha256Expected,
        ),
      );
    } catch (e) {
      return Result.error(Failure(FailureCode.networkError, e.toString()));
    }
  }

  @override
  Future<Result<String, Failure>> downloadAndVerifyUpdate({
    required String downloadUrl,
    required String expectedSha256,
    required String destinationFilePath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await _client.send(request);

      if (response.statusCode != 200) {
        return const Result.error(
          Failure(
            FailureCode.packageDownloadFailed,
            'Failed downloading APK package',
          ),
        );
      }

      final contentLength = response.contentLength ?? 0;
      var bytesReceived = 0;
      final file = File(destinationFilePath);
      final sink = file.openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        bytesReceived += chunk.length;
        if (contentLength > 0 && onProgress != null) {
          onProgress(bytesReceived / contentLength);
        }
      }
      await sink.flush();
      await sink.close();

      // Verify SHA-256
      final bytes = await file.readAsBytes();
      final computedSha = sha256.convert(bytes).toString().toLowerCase();
      final cleanExpected = expectedSha256.trim().toLowerCase();

      if (computedSha != cleanExpected) {
        try {
          file.deleteSync();
        } catch (_) {}
        return const Result.error(
          Failure(
            FailureCode.sha256VerificationFailed,
            'Downloaded APK SHA-256 does not match release hash',
          ),
        );
      }

      return Result.ok(destinationFilePath);
    } catch (e) {
      return Result.error(
        Failure(FailureCode.packageDownloadFailed, e.toString()),
      );
    }
  }
}
