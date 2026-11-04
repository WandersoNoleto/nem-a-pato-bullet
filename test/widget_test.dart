import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/home_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';

// The home screen's play button pulses forever, so these tests pump fixed
// durations instead of pumpAndSettle, which would never settle.
const _transition = Duration(milliseconds: 500);

Future<void> _pastLoading(WidgetTester tester) async {
  await tester.pumpWidget(const NemAPatoApp());
  await tester.pump(LoadingScreen.duration);
  await tester.pump(_transition);
}

void main() {
  testWidgets('loading screen shows the title and credits', (tester) async {
    await tester.pumpWidget(const NemAPatoApp());

    expect(find.byType(LoadingScreen), findsOneWidget);
    expect(find.text('BULLET'), findsOneWidget);
    expect(find.textContaining('Rodrigo Rego'), findsOneWidget);
  });

  testWidgets('loading screen goes to home after its duration', (tester) async {
    await _pastLoading(tester);

    expect(find.byType(LoadingScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
  });

  testWidgets('tapping JOGAR opens the game screen', (tester) async {
    await _pastLoading(tester);

    await tester.tap(find.text('JOGAR'));
    await tester.pump();
    await tester.pump(_transition);

    expect(find.byType(GameScreen), findsOneWidget);
  });
}
