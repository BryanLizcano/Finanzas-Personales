class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final bool hasUpdate;
  final String releaseNotes;
  final String apkDownloadUrl;
  final String? sha256Expected;

  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.hasUpdate,
    required this.releaseNotes,
    required this.apkDownloadUrl,
    this.sha256Expected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateInfo &&
          runtimeType == other.runtimeType &&
          currentVersion == other.currentVersion &&
          latestVersion == other.latestVersion &&
          hasUpdate == other.hasUpdate &&
          releaseNotes == other.releaseNotes &&
          apkDownloadUrl == other.apkDownloadUrl &&
          sha256Expected == other.sha256Expected;

  @override
  int get hashCode => Object.hash(
    currentVersion,
    latestVersion,
    hasUpdate,
    releaseNotes,
    apkDownloadUrl,
    sha256Expected,
  );
}

bool isNewerVersion(String currentVersion, String candidateVersion) {
  final cleanCurrent = currentVersion.trim().replaceFirst(RegExp(r'^v'), '');
  final cleanCandidate = candidateVersion.trim().replaceFirst(
    RegExp(r'^v'),
    '',
  );

  final currentParts = cleanCurrent
      .split(RegExp(r'[.\-+_]'))
      .map((e) => int.tryParse(e) ?? 0)
      .toList();
  final candidateParts = cleanCandidate
      .split(RegExp(r'[.\-+_]'))
      .map((e) => int.tryParse(e) ?? 0)
      .toList();

  for (var i = 0; i < 3; i++) {
    final cur = i < currentParts.length ? currentParts[i] : 0;
    final cand = i < candidateParts.length ? candidateParts[i] : 0;
    if (cand > cur) return true;
    if (cand < cur) return false;
  }
  return false;
}
