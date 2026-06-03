import 'package:flutter_test/flutter_test.dart';

import 'package:steven_asuncion_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app renders without crashing', (tester) async {
    await tester.pumpWidget(const MyApp());

    // The splash screen should show the logo
    expect(find.byType(MyApp), findsOneWidget);

    // The splash animation displays "Software Developer" title
    // (it's inside a FadeTransition so it may not be visible immediately,
    //  but the widget tree should contain it.)
    expect(find.text('Software Developer'), findsOneWidget);
  });
}
