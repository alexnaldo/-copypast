import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 2) {
    print('Uso: dart class_usage_counter.dart <caminho_do_monorepo> <nome_da_classe>');
    exit(1);
  }

  final monorepoDir = arguments[0];
  final className = arguments[1];

  final usageCount = _countClassUsage(monorepoDir, className);
  print('A classe "$className" foi encontrada ${usageCount['total']} vezes em ${usageCount['files'].length} arquivos:');
  for (var filePath in usageCount['files']) {
    print(filePath);
  }
}

Map<String, dynamic> _countClassUsage(String directory, String className) {
  final usageCount = {'total': 0, 'files': <String>[]};

  final dir = Directory(directory);
  if (!dir.existsSync()) {
    print('Diretório não encontrado: $directory');
    exit(1);
  }

  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      final occurrences = _countOccurrences(content, className);
      if (occurrences > 0) {
        usageCount['total'] += occurrences;
        usageCount['files'].add(entity.path);
      }
    }
  }

  return usageCount;
}

int _countOccurrences(String content, String searchTerm) {
  final regex = RegExp('\\b$searchTerm\\b');
  return regex.allMatches(content).length;
}
