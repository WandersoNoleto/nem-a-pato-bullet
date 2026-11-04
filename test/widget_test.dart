import 'package:flutter_test/flutter_test.dart';
import 'package:nem_a_pato_bullet/app.dart';
import 'package:nem_a_pato_bullet/ui/screens/game_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/home_screen.dart';
import 'package:nem_a_pato_bullet/ui/screens/loading_screen.dart';

// The home screen's play button pulses forever, so these tests step frames
// instead of using pumpAndSettle, which would never settle.
const _frame = Duration(milliseconds: 100);
const _transition = Duration(milliseconds: 500);

/// Steps frames until the loading screen is gone, failing if that takes
/// noticeably longer than its duration plus the fade to home.
Future<void> _pastLoading(WidgetTester tester) async {
  await tester.pumpWidget(const NemAPatoApp());
  final limit = LoadingScreen.duration + const Duration(seconds: 1);
  var elapsed = Duration.zero;
  while (find.byType(LoadingScreen).evaluate().isNotEmpty) {
    expect(elapsed, lessThan(limit), reason: 'loading screen never finished');
    await tester.pump(_frame);
    elapsed += _frame;
  }
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
