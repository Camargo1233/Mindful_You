import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_you/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('mostra login quando nao ha sessao ativa', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Acessar'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Usar conta demo'), findsOneWidget);
  });
}
