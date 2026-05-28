import '../services/api_service.dart';

List<Map<String, dynamic>> historicoGlobal = [];

Future<void> sincronizarHistoricoGlobal() async {
  final checkIns = await MockApiService.loadCheckIns();
  historicoGlobal = checkIns.map((item) => item.toLegacyMap()).toList();
}
