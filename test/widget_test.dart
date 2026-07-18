import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowday/main.dart';

void main() {
  testWidgets('Flowday starts on local database screen', (tester) async {
    await tester.pumpWidget(const FlowdayApp());

    expect(find.text('Flowday'), findsOneWidget);
    expect(find.text('Local Database'), findsOneWidget);
    expect(find.text('CREATE NEW DATABASE (!)'), findsOneWidget);
    expect(find.text('SELECT EXISTING DATABASE (!)'), findsOneWidget);
  });

  testWidgets('create database opens profile setup', (tester) async {
    await tester.pumpWidget(const FlowdayApp());

    await tester.tap(find.text('CREATE NEW DATABASE (!)'));
    await tester.pumpAndSettle();

    expect(find.text('Create personal profile'), findsOneWidget);
    expect(find.text('Name or Nick Name'), findsOneWidget);
  });
}
