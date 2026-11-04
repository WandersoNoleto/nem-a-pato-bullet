import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/ui/screens/home_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';

void main() {
  testWidgets('loading screen shows the title and credits', (tester) async {
    await tester.pumpWidget(const NemAPatoApp());

    expect(find.byType(LoadingScreen), findsOneWidget);
    expect(find.text('BULLET'), findsOneWidget);
    expect(find.textContaining('Rodrigo Rego'), findsOneWidget);
  });

  testWidgets('loading screen goes to home after its duration', (tester) async {
    await tester.pumpWidget(const NemAPatoApp());

    await tester.pump(LoadingScreen.duration);
    await tester.pumpAndSettle();

    expect(find.byType(LoadingScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
