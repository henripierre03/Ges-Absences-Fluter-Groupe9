import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_gesabsence/main.dart';

void main() {
  testWidgets('App démarre correctement', (WidgetTester tester) async {
    // Lance l'application
    await tester.pumpWidget(const App());

    // Vérifie que le widget de base s'affiche bien (tu peux adapter selon ta vue d’accueil)
    expect(find.byType(App), findsOneWidget);

    // Optionnel : tu peux vérifier un texte ou un widget particulier de ta page d’accueil ici
    // Par exemple si ta première page contient "Bienvenue"
    // expect(find.text('Bienvenue'), findsOneWidget);
  });
}
