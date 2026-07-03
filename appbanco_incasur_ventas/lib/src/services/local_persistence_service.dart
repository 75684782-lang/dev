import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalPersistenceService {
  static const String _outboxFileName = 'sync_outbox.json';

  static Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  static Future<List<Map<String, dynamic>>> loadOutbox() async {
    try {
      final file = await _getFile(_outboxFileName);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> data = jsonDecode(content);
      return data.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveOutbox(List<Map<String, dynamic>> items) async {
    try {
      final file = await _getFile(_outboxFileName);
      await file.writeAsString(jsonEncode(items));
    } catch (_) {}
  }
}
