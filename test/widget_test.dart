import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/app/app.dart';

void main() {
  testWidgets('login screen is the entry point', (tester) async {
    await tester.pumpWidget(const TokioMarineApp());
    await tester.pumpAndSettle();

    expect(find.text('Bem vindo!'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);
  });
}
