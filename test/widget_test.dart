import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reservamobile/app/app.dart';

void main() {
  testWidgets('Splash preloader renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReservaMobileApp()));

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
