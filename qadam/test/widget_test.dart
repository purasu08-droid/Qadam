import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qadam/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'qadam.language': 'en'});
  });

  testWidgets('Qadam MVP starts with welcome and language switcher', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('RU'), findsOneWidget);
  });

  testWidgets('Continue opens sign in screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Phone'));
    await tester.pumpAndSettle();

    expect(find.text('QADAM'), findsOneWidget);
    expect(find.text('Your Email'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Sign in screen follows Russian language', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'qadam.language': 'ru'});

    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Ваш Email'), findsOneWidget);
    expect(find.text('Ваш пароль'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });

  testWidgets('Sign in screen follows Turkish language', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'qadam.language': 'tr'});

    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pumpAndSettle();

    expect(find.text('E-postanız'), findsOneWidget);
    expect(find.text('Şifreniz'), findsOneWidget);
    expect(find.text('Giriş yap'), findsOneWidget);
  });

  testWidgets('Password visibility toggle works on sign in screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Phone'));
    await tester.pumpAndSettle();

    TextField passwordField = tester.widget(find.byType(TextField).at(1));
    expect(passwordField.obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();

    passwordField = tester.widget(find.byType(TextField).at(1));
    expect(passwordField.obscureText, isFalse);

    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();

    passwordField = tester.widget(find.byType(TextField).at(1));
    expect(passwordField.obscureText, isTrue);
  });

  testWidgets('Context messages use Jockey One font', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Phone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    final snackText = tester.widget<Text>(
      find.text('Please enter a valid email for the demo.'),
    );
    expect(snackText.style?.fontFamily, 'Jockey One');
  });

  testWidgets('Demo sign in opens category screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QadamApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Phone'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'client@qadam.local');
    await tester.enterText(find.byType(TextField).at(1), 'qadam2026');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Search places'), findsOneWidget);
    expect(find.text('Meetups'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
  });

  testWidgets('App shell can open directly on categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QadamApp(showWelcome: false));
    await tester.pumpAndSettle();

    expect(find.text('Search places'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
  });

  testWidgets('Bell opens local notification sheet', (
    WidgetTester tester,
  ) async {
    final event = {
      'id': 'demo-event',
      'title': 'Demo meetup',
      'description': 'Demo meetup description',
      'category': 'events',
      'locationName': 'Bandırma AVM',
      'lat': 40.3470,
      'lng': 27.9810,
      'createdAt': DateTime.now().toIso8601String(),
      'photoBase64': '',
    };
    SharedPreferences.setMockInitialValues({
      'qadam.language': 'en',
      'qadam.localEvents': [jsonEncode(event)],
    });

    await tester.pumpWidget(const QadamApp(showWelcome: false));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('notificationBell')));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Event published'), findsOneWidget);
    expect(find.textContaining('Demo meetup'), findsOneWidget);
  });

  test('Local event keeps photo in local json', () {
    final event = LocalEvent(
      id: 'event-photo',
      title: 'Photo event',
      description: 'Photo event description',
      category: EventCategory.events,
      locationName: 'Bandırma AVM',
      lat: 40.3470,
      lng: 27.9810,
      createdAt: DateTime(2026, 5, 21),
      photoBase64: 'abc123',
    );

    final decoded = LocalEvent.fromJson(event.toJson());

    expect(decoded.photoBase64, 'abc123');
  });

  testWidgets('Bottom nav keeps labels inside a narrow capsule', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 220);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 272,
              child: QadamBottomNav(
                text: const AppText(AppLanguage.ru),
                currentIndex: 1,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    final navRect = tester.getRect(find.byType(QadamBottomNav));
    for (final element in find.byType(Text).evaluate()) {
      final textWidget = element.widget as Text;
      final rect = tester.getRect(find.byWidget(textWidget));

      expect(rect.left, greaterThanOrEqualTo(navRect.left));
      expect(rect.right, lessThanOrEqualTo(navRect.right));
    }
  });
}
