// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('No coverage file found');
    return;
  }
  final lines = file.readAsLinesSync();
  String currentFile = '';
  int currentLf = 0;
  int currentLh = 0;

  int domainLf = 0;
  int domainLh = 0;

  void reportCurrent() {
    if (currentFile.isNotEmpty && currentLf > 0) {
      final pct = (currentLh / currentLf) * 100;
      if (currentFile.contains('domain') || currentFile.contains('usecase')) {
        domainLf += currentLf;
        domainLh += currentLh;
      }
      print(
        '${currentFile.padRight(60)} $currentLh / $currentLf (${pct.toStringAsFixed(1)}%)',
      );
    }
  }

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      reportCurrent();
      currentFile = line.substring(3).replaceAll(r'\', '/');
      currentLf = 0;
      currentLh = 0;
    }
    if (line.startsWith('LF:')) {
      currentLf = int.parse(line.substring(3));
    }
    if (line.startsWith('LH:')) {
      currentLh = int.parse(line.substring(3));
    }
  }
  reportCurrent();

  if (domainLf > 0) {
    final domainPct = (domainLh / domainLf) * 100;
    print(
      '\nTOTAL DOMAIN & USECASES: $domainLh / $domainLf (${domainPct.toStringAsFixed(1)}%)',
    );
  }
}
