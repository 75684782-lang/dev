import 'package:flutter_test/flutter_test.dart';
import 'package:appbanco_incasur_cliente/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppCliente());
    expect(find.byType(AppCliente), findsOneWidget);
  });
}
