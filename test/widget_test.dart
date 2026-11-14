import 'package:flutter_test/flutter_test.dart';
import 'package:guardario_mobile/main.dart';

void main() {
  testWidgets('Abre na tela de boas-vindas', (tester) async {
    await tester.pumpWidget(const GuardaRioApp());
    expect(find.text('GuardaRio'), findsOneWidget);
    expect(find.text('Continuar sem conta'), findsOneWidget);
  });
}
