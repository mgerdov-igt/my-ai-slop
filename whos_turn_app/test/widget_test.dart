import 'package:flutter_test/flutter_test.dart';

import 'package:whos_turn/main.dart';

void main() {
  testWidgets('App shows player count screen', (WidgetTester tester) async {
    await tester.pumpWidget(const WhosTurnApp());

    expect(find.text("Who's Turn?"), findsOneWidget);
    expect(find.text('Select number of players'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });
}
