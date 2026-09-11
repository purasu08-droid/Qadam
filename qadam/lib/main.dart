import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QadamApp());
}

const Color _lime = Color(0xFFD6F75F);
const Color _ink = Color(0xFF07090E);
const Color _muted = Color(0xFF74777F);
const Color _line = Color(0xFFD9DBDF);
const Color _paper = Color(0xFFF7F7F8);
const String _inderFont = 'Inder';
const String _jaroFont = 'Jaro';
const String _jockeyOneFont = 'Jockey One';
const String _montserratFont = 'Montserrat';
const String _jaldiFont = 'Jaldi';
const String _istokWebFont = 'Istok Web';
const String _qadamLogoAsset = 'assets/images/qadam_logo.png';
const String _figmaSearchIconAsset = 'assets/images/figma_search_icon.png';
const String _figmaBellAsset = 'assets/images/figma_bell.png';

enum AppLanguage { ru, en, tr }

extension AppLanguageLabel on AppLanguage {
  String get shortLabel {
    switch (this) {
      case AppLanguage.ru:
        return 'RU';
      case AppLanguage.en:
        return 'EN';
      case AppLanguage.tr:
        return 'TR';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.ru:
        return const Locale('ru');
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.tr:
        return const Locale('tr');
    }
  }
}

class AppText {
  const AppText(this.currentLanguage);

  final AppLanguage currentLanguage;

  String pick({required String ru, required String en, required String tr}) {
    switch (currentLanguage) {
      case AppLanguage.ru:
        return ru;
      case AppLanguage.en:
        return en;
      case AppLanguage.tr:
        return tr;
    }
  }

  String get searchPoints =>
      pick(ru: 'Искать точки', en: 'Search places', tr: 'Noktalar ara');
  String get categories =>
      pick(ru: 'Категорий', en: 'Categories', tr: 'Kategoriler');
  String get map => pick(ru: 'Карта', en: 'Map', tr: 'Harita');
  String get random => pick(ru: 'Разное', en: 'Mixed', tr: 'Karışık');
  String get resultSuffix => pick(ru: 'рез.', en: 'res.', tr: 'son.');
  String get add => pick(ru: 'Добавить', en: 'Add', tr: 'Ekle');
  String get points => pick(ru: 'Точки', en: 'Points', tr: 'Noktalar');
  String get messages => pick(ru: 'Сообщения', en: 'Messages', tr: 'Mesajlar');
  String get profile => pick(ru: 'Профиль', en: 'Profile', tr: 'Profil');
  String get addEvent =>
      pick(ru: 'Добавить событие', en: 'Add event', tr: 'Etkinlik ekle');
  String get writeDescription => pick(
    ru: 'Напишите описание...',
    en: 'Write a description...',
    tr: 'Açıklama yazın...',
  );
  String get activityType =>
      pick(ru: 'Вид деятельности', en: 'Activity type', tr: 'Faaliyet türü');
  String get location =>
      pick(ru: 'Местоположение', en: 'Location', tr: 'Konum');
  String get dateTime =>
      pick(ru: 'Дата и время', en: 'Date and time', tr: 'Tarih ve saat');
  String get price => pick(ru: 'Цена', en: 'Price', tr: 'Fiyat');
  String get inbox => pick(ru: 'Входящие', en: 'Inbox', tr: 'Gelenler');
  String get outbox => pick(ru: 'Исходящие', en: 'Outgoing', tr: 'Gidenler');
  String get myAds => pick(ru: 'Мои объявления', en: 'My ads', tr: 'İlanlarım');
  String get edit => pick(ru: 'Изменить', en: 'Edit', tr: 'Düzenle');
  String get delete => pick(ru: 'Удалить', en: 'Delete', tr: 'Sil');
  String get save => pick(ru: 'Сохранить', en: 'Save', tr: 'Kaydet');
  String get cancel => pick(ru: 'Отмена', en: 'Cancel', tr: 'İptal');
  String get details => pick(ru: 'Подробнее', en: 'Details', tr: 'Detaylar');
  String get writeMessage =>
      pick(ru: 'Написать', en: 'Message', tr: 'Mesaj yaz');
  String get profileUpdated => pick(
    ru: 'Профиль обновлен',
    en: 'Profile updated',
    tr: 'Profil güncellendi',
  );
  String get eventUpdated => pick(
    ru: 'Событие обновлено',
    en: 'Event updated',
    tr: 'Etkinlik güncellendi',
  );
  String get eventDeleted =>
      pick(ru: 'Событие удалено', en: 'Event deleted', tr: 'Etkinlik silindi');
  String get messageSent => pick(
    ru: 'Сообщение добавлено в исходящие',
    en: 'Message added to outgoing',
    tr: 'Mesaj gidenlere eklendi',
  );
  String get emptyOutbox => pick(
    ru: 'Пока нет исходящих сообщений',
    en: 'No outgoing messages yet',
    tr: 'Henüz giden mesaj yok',
  );
  String get noSearchResults => pick(
    ru: 'Ничего не найдено',
    en: 'Nothing found',
    tr: 'Sonuç bulunamadı',
  );
  String activeWorkResults(int count) {
    return pick(
      ru: '$count активных ивента работы',
      en: '$count active work events',
      tr: '$count aktif iş etkinliği',
    );
  }

  String searchResults(int count) {
    return pick(
      ru: '$count результатов',
      en: '$count results',
      tr: '$count sonuç',
    );
  }

  String get openOnMap => pick(ru: 'На карте', en: 'On map', tr: 'Haritada');
  String get removeResponse =>
      pick(ru: 'Удалить отклик', en: 'Delete response', tr: 'Başvuruyu sil');
  String get changePhoto =>
      pick(ru: 'Сменить фото', en: 'Change photo', tr: 'Fotoğrafı değiştir');
  String get name => pick(ru: 'Имя', en: 'Name', tr: 'İsim');
  String get role => pick(ru: 'Профессия', en: 'Role', tr: 'Rol');
  String get about => pick(ru: 'О себе', en: 'About', tr: 'Hakkında');
  String get city => pick(ru: 'Город', en: 'City', tr: 'Şehir');
  String get welcome =>
      pick(ru: 'Добро пожаловать', en: 'Welcome', tr: 'Hoş geldin');
  String get welcomeSubtitle => pick(
    ru: 'Первый шаг начинается здесь',
    en: 'Your first step begins here',
    tr: 'İlk adımın burada başlıyor',
  );
  String get continuePhone => pick(
    ru: 'Продолжить с телефоном',
    en: 'Continue with Phone',
    tr: 'Telefon ile devam et',
  );
  String get continueApple => pick(
    ru: 'Продолжить с Apple',
    en: 'Continue with Apple',
    tr: 'Apple ile devam et',
  );
  String get authFirstStep => pick(
    ru: 'Сделаем первый шаг',
    en: 'Let\u2019s take the first step',
    tr: 'İlk adımı atalım',
  );
  String get authEmail =>
      pick(ru: 'Ваш Email', en: 'Your Email', tr: 'E-postanız');
  String get authPassword =>
      pick(ru: 'Ваш пароль', en: 'Your Password', tr: 'Şifreniz');
  String get forgotPassword => pick(
    ru: 'Забыли пароль?',
    en: 'Forgot password?',
    tr: 'Şifrenizi mi unuttunuz?',
  );
  String get signIn => pick(ru: 'Войти', en: 'Sign in', tr: 'Giriş yap');
  String get authOr => pick(ru: 'или', en: 'or', tr: 'veya');
  String get noAccount => pick(
    ru: 'Нет аккаунта?',
    en: 'Don\u2019t have an account?',
    tr: 'Hesabınız yok mu?',
  );
  String get invalidEmailDemo => pick(
    ru: 'Введите корректный email для демо.',
    en: 'Please enter a valid email for the demo.',
    tr: 'Demo için geçerli bir e-posta girin.',
  );
  String get shortPasswordDemo => pick(
    ru: 'Для демо пароль должен быть минимум 6 символов.',
    en: 'Use at least 6 characters for the demo password.',
    tr: 'Demo şifresi en az 6 karakter olmalı.',
  );
  String get resetNeedsEmail => pick(
    ru: 'Введите email, и Qadam подготовит демо-ссылку для восстановления.',
    en: 'Enter your email and Qadam will prepare a demo reset link.',
    tr: 'E-postanızı girin, Qadam demo sıfırlama bağlantısı hazırlasın.',
  );
  String resetPrepared(String email) {
    return pick(
      ru: 'Демо-ссылка для восстановления подготовлена: $email.',
      en: 'Demo reset link prepared for $email.',
      tr: '$email için demo sıfırlama bağlantısı hazırlandı.',
    );
  }

  String get demoAccountFilled => pick(
    ru: 'Демо-аккаунт заполнен. Нажмите «Войти».',
    en: 'Demo account filled. Tap Sign in to continue.',
    tr: 'Demo hesabı dolduruldu. Devam etmek için Giriş yapın.',
  );
  String get showPassword =>
      pick(ru: 'Показать пароль', en: 'Show password', tr: 'Şifreyi göster');
  String get hidePassword =>
      pick(ru: 'Скрыть пароль', en: 'Hide password', tr: 'Şifreyi gizle');
  String get agreement => pick(
    ru: 'Нажимая "Продолжить", вы соглашаетесь с условиями сервиса и политикой приватности',
    en: 'By pressing "Continue with" you agree to our Terms of Service and Privacy Policy',
    tr: '"Devam et"e basarak Kullanım Şartları ve Gizlilik Politikası kabul edilir',
  );
  String get languageLabel => pick(ru: 'Язык', en: 'Language', tr: 'Dil');
  String get nowWatching => pick(
    ru: 'Сейчас смотрят 8 человек',
    en: '8 people are viewing now',
    tr: 'Şu an 8 kişi bakıyor',
  );
  String get results =>
      pick(ru: '1988 результатов', en: '1988 results', tr: '1988 sonuç');
  String get respond => pick(ru: 'Откликнуться', en: 'Respond', tr: 'Başvur');
  String get deadline =>
      pick(ru: 'Срок: до 3 дней', en: 'Deadline: 3 days', tr: 'Süre: 3 gün');
  String get deadlineShort =>
      pick(ru: 'Срок: до 1 дня', en: 'Deadline: 1 day', tr: 'Süre: 1 gün');
  String get publishedToday => pick(
    ru: 'Опубликовано сегодня',
    en: 'Published today',
    tr: 'Bugün yayınlandı',
  );
  String get offline => pick(ru: 'Оффлайн', en: 'Offline', tr: 'Çevrimdışı');
  String get online => pick(ru: 'Онлайн', en: 'Online', tr: 'Online');
  String get continueDemo => pick(
    ru: 'Это демо-MVP без базы данных',
    en: 'This is a demo MVP without a database',
    tr: 'Bu veritabanı olmayan demo MVP',
  );
  String get notifications =>
      pick(ru: 'Уведомления', en: 'Notifications', tr: 'Bildirimler');
  String get noNotifications => pick(
    ru: 'Пока нет новых уведомлений',
    en: 'No new notifications yet',
    tr: 'Henüz yeni bildirim yok',
  );
  String get markAllRead => pick(
    ru: 'Отметить как прочитано',
    en: 'Mark all read',
    tr: 'Tümünü okundu yap',
  );
  String get eventPublished => pick(
    ru: 'Ивент опубликован',
    en: 'Event published',
    tr: 'Etkinlik yayınlandı',
  );
  String get responseNotification =>
      pick(ru: 'Новый отклик', en: 'New response', tr: 'Yeni yanıt');
  String get eventPhotoAdded => pick(
    ru: 'Фото добавлено к ивенту',
    en: 'Photo added to the event',
    tr: 'Fotoğraf etkinliğe eklendi',
  );
  String get savedDraft => pick(
    ru: 'Событие сохранено в демо-режиме',
    en: 'Event saved in demo mode',
    tr: 'Etkinlik demo modunda kaydedildi',
  );
  String get uploadDemo => pick(
    ru: 'Загрузка фото в MVP показана как демо',
    en: 'Photo upload is mocked for the MVP',
    tr: 'Fotoğraf yükleme MVP için demodur',
  );
  String get myProjects =>
      pick(ru: 'Мои проекты', en: 'My projects', tr: 'Benim projelerim');
  String get eventsTitle =>
      pick(ru: 'События', en: 'Events', tr: 'Etkinlikler');
  String get profileReviews =>
      pick(ru: '12 отзывов', en: '12 reviews', tr: '12 yorum');
  String get profileEventsIntro => pick(
    ru: 'Ближайшие события рядом',
    en: 'Nearby events',
    tr: 'Yakındaki etkinlikler',
  );
  String get profileEventsHint => pick(
    ru: 'Нажмите на событие, чтобы посмотреть детали и написать организатору.',
    en: 'Tap an event to check details and message the organizer.',
    tr: 'Detayları görmek ve organizatöre yazmak için etkinliğe dokun.',
  );
  String get teamSearching =>
      pick(ru: 'Ищу команду', en: 'Looking for team', tr: 'Ekip arıyorum');
  String get cityAstana => pick(ru: 'Астана', en: 'Astana', tr: 'Astana');
  String get cityAlmaty => pick(ru: 'Алматы', en: 'Almaty', tr: 'Almatı');
  String get cityQyzylorda =>
      pick(ru: 'Кызылорда', en: 'Qyzylorda', tr: 'Kızılorda');
  String get emptyAdList => pick(
    ru: 'Пока нет активных объявлений',
    en: 'No active ads yet',
    tr: 'Henüz aktif ilan yok',
  );

  String category(EventCategory category) {
    switch (category) {
      case EventCategory.meetings:
        return pick(ru: 'Встречи', en: 'Meetups', tr: 'Buluşmalar');
      case EventCategory.work:
        return pick(ru: 'Работа', en: 'Work', tr: 'İş');
      case EventCategory.startups:
        return pick(ru: 'Стартапы', en: 'Startups', tr: 'Girişimler');
      case EventCategory.events:
        return pick(ru: 'События', en: 'Events', tr: 'Etkinlikler');
    }
  }
}

class QadamApp extends StatefulWidget {
  const QadamApp({super.key, this.showWelcome = true});

  final bool showWelcome;

  @override
  State<QadamApp> createState() => _QadamAppState();
}

class _QadamAppState extends State<QadamApp> {
  AppLanguage _language = AppLanguage.ru;
  List<LocalEvent> _localEvents = const [];
  Set<String> _respondedRequestIds = const {};
  List<OutgoingMessage> _outgoingMessages = const [];
  UserProfile _profile = UserProfile.defaults;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final data = await LocalDataStore.load();
    if (!mounted) return;
    setState(() {
      _language = data.language;
      _localEvents = data.events;
      _respondedRequestIds = data.respondedRequestIds;
      _outgoingMessages = data.outgoingMessages;
      _profile = data.profile;
    });
  }

  Future<void> _setLanguage(AppLanguage language) async {
    setState(() => _language = language);
    await LocalDataStore.saveLanguage(language);
  }

  Future<void> _addLocalEvent(LocalEvent event) async {
    final nextEvents = [event, ..._localEvents];
    setState(() => _localEvents = nextEvents);
    await LocalDataStore.saveEvents(nextEvents);
  }

  Future<void> _updateLocalEvent(LocalEvent event) async {
    final nextEvents = [
      for (final item in _localEvents) item.id == event.id ? event : item,
    ];
    setState(() => _localEvents = nextEvents);
    await LocalDataStore.saveEvents(nextEvents);
  }

  Future<void> _deleteLocalEvent(String eventId) async {
    final nextEvents = _localEvents
        .where((event) => event.id != eventId)
        .toList();
    setState(() => _localEvents = nextEvents);
    await LocalDataStore.saveEvents(nextEvents);
  }

  Future<void> _updateProfile(UserProfile profile) async {
    setState(() => _profile = profile);
    await LocalDataStore.saveProfile(profile);
  }

  Future<void> _addOutgoingMessage(OutgoingMessage message) async {
    final nextMessages = [
      message,
      ..._outgoingMessages.where(
        (item) =>
            item.kind != message.kind || item.targetId != message.targetId,
      ),
    ];
    setState(() => _outgoingMessages = nextMessages);
    await LocalDataStore.saveOutgoingMessages(nextMessages);
  }

  Future<void> _deleteOutgoingMessage(OutgoingMessage message) async {
    final nextMessages = _outgoingMessages
        .where((item) => item.id != message.id)
        .toList();
    final nextIds = Set<String>.from(_respondedRequestIds);
    if (message.kind == OutgoingMessageKind.workResponse.name) {
      nextIds.remove(message.targetId);
    }
    setState(() {
      _outgoingMessages = nextMessages;
      _respondedRequestIds = nextIds;
    });
    await Future.wait([
      LocalDataStore.saveOutgoingMessages(nextMessages),
      LocalDataStore.saveRespondedRequestIds(nextIds),
    ]);
  }

  Future<void> _toggleRespondedRequest(String requestId) async {
    final nextIds = Set<String>.from(_respondedRequestIds);
    final isNewResponse = nextIds.add(requestId);
    final nextMessages = List<OutgoingMessage>.from(_outgoingMessages);

    if (!isNewResponse) {
      nextIds.remove(requestId);
      nextMessages.removeWhere(
        (message) =>
            message.kind == OutgoingMessageKind.workResponse.name &&
            message.targetId == requestId,
      );
    } else {
      final request = _workRequests.firstWhere(
        (request) => request.id == requestId,
        orElse: () => _workRequests.first,
      );
      final text = AppText(_language);
      nextMessages
        ..removeWhere(
          (message) =>
              message.kind == OutgoingMessageKind.workResponse.name &&
              message.targetId == requestId,
        )
        ..insert(
          0,
          OutgoingMessage(
            id: 'message-${DateTime.now().microsecondsSinceEpoch}',
            kind: OutgoingMessageKind.workResponse.name,
            targetId: request.id,
            title: request.title(text),
            subtitle: request.company,
            body: text.pick(
              ru: 'Отклик отправлен на задание',
              en: 'Response sent to the request',
              tr: 'İlana başvuru gönderildi',
            ),
            createdAt: DateTime.now(),
          ),
        );
    }

    setState(() {
      _respondedRequestIds = nextIds;
      _outgoingMessages = nextMessages;
    });
    await Future.wait([
      LocalDataStore.saveRespondedRequestIds(nextIds),
      LocalDataStore.saveOutgoingMessages(nextMessages),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _lime,
      brightness: Brightness.light,
      primary: _ink,
      surface: Colors.white,
    );

    return MaterialApp(
      title: 'Qadam',
      debugShowCheckedModeBanner: false,
      locale: _language.locale,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _ink,
          displayColor: _ink,
          fontFamily: _jockeyOneFont,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
      home: QadamRoot(
        showWelcome: widget.showWelcome,
        language: _language,
        localEvents: _localEvents,
        respondedRequestIds: _respondedRequestIds,
        outgoingMessages: _outgoingMessages,
        profile: _profile,
        onLanguageChanged: _setLanguage,
        onEventAdded: _addLocalEvent,
        onEventUpdated: _updateLocalEvent,
        onEventDeleted: _deleteLocalEvent,
        onRequestResponded: _toggleRespondedRequest,
        onOutgoingMessageAdded: _addOutgoingMessage,
        onOutgoingMessageDeleted: _deleteOutgoingMessage,
        onProfileChanged: _updateProfile,
      ),
    );
  }
}

enum LaunchStage { welcome, signIn, app }

class QadamRoot extends StatefulWidget {
  const QadamRoot({
    super.key,
    required this.showWelcome,
    required this.language,
    required this.localEvents,
    required this.respondedRequestIds,
    required this.outgoingMessages,
    required this.profile,
    required this.onLanguageChanged,
    required this.onEventAdded,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onRequestResponded,
    required this.onOutgoingMessageAdded,
    required this.onOutgoingMessageDeleted,
    required this.onProfileChanged,
  });

  final bool showWelcome;
  final AppLanguage language;
  final List<LocalEvent> localEvents;
  final Set<String> respondedRequestIds;
  final List<OutgoingMessage> outgoingMessages;
  final UserProfile profile;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<LocalEvent> onEventAdded;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<String> onRequestResponded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;
  final ValueChanged<UserProfile> onProfileChanged;

  @override
  State<QadamRoot> createState() => _QadamRootState();
}

class _QadamRootState extends State<QadamRoot> {
  late LaunchStage _stage;

  @override
  void initState() {
    super.initState();
    _stage = widget.showWelcome ? LaunchStage.welcome : LaunchStage.app;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppText(widget.language);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (_stage) {
        LaunchStage.welcome => WelcomeScreen(
          key: const ValueKey('welcome'),
          text: text,
          language: widget.language,
          onLanguageChanged: widget.onLanguageChanged,
          onContinue: () => setState(() => _stage = LaunchStage.signIn),
        ),
        LaunchStage.signIn => SignInScreen(
          key: const ValueKey('signIn'),
          text: text,
          onSignedIn: _completeSignIn,
        ),
        LaunchStage.app => QadamShell(
          key: const ValueKey('app'),
          text: text,
          language: widget.language,
          localEvents: widget.localEvents,
          respondedRequestIds: widget.respondedRequestIds,
          outgoingMessages: widget.outgoingMessages,
          profile: widget.profile,
          onLanguageChanged: widget.onLanguageChanged,
          onEventAdded: widget.onEventAdded,
          onEventUpdated: widget.onEventUpdated,
          onEventDeleted: widget.onEventDeleted,
          onRequestResponded: widget.onRequestResponded,
          onOutgoingMessageAdded: widget.onOutgoingMessageAdded,
          onOutgoingMessageDeleted: widget.onOutgoingMessageDeleted,
          onProfileChanged: widget.onProfileChanged,
        ),
      },
    );
  }

  Future<void> _completeSignIn(String email) async {
    await LocalDataStore.saveSignedInEmail(email);
    if (!mounted) return;
    setState(() => _stage = LaunchStage.app);
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.text,
    required this.language,
    required this.onLanguageChanged,
    required this.onContinue,
  });

  final AppText text;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: Colors.white,
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: LanguageSwitcher(
                      language: language,
                      onChanged: onLanguageChanged,
                    ),
                  ),
                  const Spacer(flex: 2),
                  const QadamLogoImage(width: 78),
                  const Spacer(flex: 2),
                  Text(
                    text.welcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _ink,
                      fontFamily: _inderFont,
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      height: 1.05,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    text.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _muted,
                      fontFamily: _inderFont,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 44),
                  OutlinedButton(
                    onPressed: onContinue,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      foregroundColor: _ink,
                      side: const BorderSide(color: _ink, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      text.continuePhone,
                      style: const TextStyle(
                        fontFamily: _inderFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: onContinue,
                    child: Text(
                      text.continueApple,
                      style: const TextStyle(
                        fontFamily: _inderFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    text.agreement,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _ink,
                      fontFamily: _inderFont,
                      fontSize: 11,
                      height: 1.25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.text, required this.onSignedIn});

  final AppText text;
  final Future<void> Function(String email) onSignedIn;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedEmail() async {
    final email = await LocalDataStore.loadSignedInEmail();
    if (!mounted || email.isEmpty || _emailController.text.isNotEmpty) return;
    _emailController.text = email;
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (!_looksLikeEmail(email)) {
      _showSnack(context, widget.text.invalidEmailDemo);
      return;
    }
    if (password.trim().length < 6) {
      _showSnack(context, widget.text.shortPasswordDemo);
      return;
    }

    await _signInAs(email);
  }

  Future<void> _signInAs(String email) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await widget.onSignedIn(email);
    if (!mounted) return;
    setState(() => _isSubmitting = false);
  }

  void _handleForgotPassword() {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = _emailController.text.trim();
    final message = email.isEmpty
        ? widget.text.resetNeedsEmail
        : widget.text.resetPrepared(email);
    _showSnack(context, message);
  }

  void _fillDemoAccount() {
    _emailController.text = 'demo@qadam.local';
    _passwordController.text = 'qadam2026';
    FocusManager.instance.primaryFocus?.unfocus();
    _showSnack(context, widget.text.demoAccountFilled);
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topGap = math.max(
                52.0,
                math.min(118.0, constraints.maxHeight * 0.14),
              );

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 34),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 328),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: topGap),
                          const QadamLogoImage(width: 60),
                          const SizedBox(height: 24),
                          const Text(
                            'QADAM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _ink,
                              fontFamily: _jaroFont,
                              fontSize: 38,
                              fontWeight: FontWeight.w400,
                              height: 0.9,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 27),
                          Text(
                            text.authFirstStep,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _ink,
                              fontFamily: _inderFont,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 27),
                          _SignInTextField(
                            controller: _emailController,
                            hintText: text.authEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: 17),
                          _SignInTextField(
                            controller: _passwordController,
                            hintText: text.authPassword,
                            obscureText: !_passwordVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onSubmitted: (_) => _submit(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                  () => _passwordVisible = !_passwordVisible,
                                );
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                              ),
                              color: _ink,
                              padding: EdgeInsets.zero,
                              tooltip: _passwordVisible
                                  ? text.hidePassword
                                  : text.showPassword,
                            ),
                          ),
                          const SizedBox(height: 11),
                          TextButton(
                            onPressed: _handleForgotPassword,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF484848),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: const Size(0, 34),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              text.forgotPassword,
                              style: const TextStyle(
                                fontFamily: _inderFont,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              disabledBackgroundColor: Colors.black.withValues(
                                alpha: 0.72,
                              ),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(47),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    text.signIn,
                                    style: const TextStyle(
                                      fontFamily: _inderFont,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 15),
                          _AuthDivider(label: text.authOr),
                          const SizedBox(height: 15),
                          OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => _signInAs('apple@qadam.local'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _ink,
                              minimumSize: const Size.fromHeight(49),
                              padding: EdgeInsets.zero,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              text.continueApple,
                              style: const TextStyle(
                                fontFamily: _inderFont,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          TextButton(
                            onPressed: _isSubmitting ? null : _fillDemoAccount,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF595959),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              text.noAccount,
                              style: const TextStyle(
                                fontFamily: _inderFont,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SignInTextField extends StatelessWidget {
  const _SignInTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.onSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        cursorColor: _ink,
        style: const TextStyle(
          color: _ink,
          fontFamily: _inderFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF747474),
            fontFamily: _inderFont,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 19,
            vertical: 14,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 46,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Colors.black, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFF555555))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontFamily: _inderFont,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFF555555))),
      ],
    );
  }
}

bool _looksLikeEmail(String value) {
  final trimmed = value.trim();
  final at = trimmed.indexOf('@');
  final dot = trimmed.lastIndexOf('.');
  return at > 0 && dot > at + 1 && dot < trimmed.length - 1;
}

class QadamShell extends StatefulWidget {
  const QadamShell({
    super.key,
    required this.text,
    required this.language,
    required this.localEvents,
    required this.respondedRequestIds,
    required this.outgoingMessages,
    required this.profile,
    required this.onLanguageChanged,
    required this.onEventAdded,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onRequestResponded,
    required this.onOutgoingMessageAdded,
    required this.onOutgoingMessageDeleted,
    required this.onProfileChanged,
  });

  final AppText text;
  final AppLanguage language;
  final List<LocalEvent> localEvents;
  final Set<String> respondedRequestIds;
  final List<OutgoingMessage> outgoingMessages;
  final UserProfile profile;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<LocalEvent> onEventAdded;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<String> onRequestResponded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;
  final ValueChanged<UserProfile> onProfileChanged;

  @override
  State<QadamShell> createState() => _QadamShellState();
}

class _QadamShellState extends State<QadamShell> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              AddEventPage(
                text: widget.text,
                onEventAdded: widget.onEventAdded,
              ),
              PointsPage(
                text: widget.text,
                language: widget.language,
                localEvents: widget.localEvents,
                outgoingMessages: widget.outgoingMessages,
                respondedRequestIds: widget.respondedRequestIds,
                onLanguageChanged: widget.onLanguageChanged,
                onEventUpdated: widget.onEventUpdated,
                onEventDeleted: widget.onEventDeleted,
                onRequestResponded: widget.onRequestResponded,
                onOutgoingMessageAdded: widget.onOutgoingMessageAdded,
                onOutgoingMessageDeleted: widget.onOutgoingMessageDeleted,
              ),
              MessagesPage(
                text: widget.text,
                localEvents: widget.localEvents,
                respondedRequestIds: widget.respondedRequestIds,
                outgoingMessages: widget.outgoingMessages,
                onEventUpdated: widget.onEventUpdated,
                onEventDeleted: widget.onEventDeleted,
                onRequestResponded: widget.onRequestResponded,
                onOutgoingMessageDeleted: widget.onOutgoingMessageDeleted,
              ),
              ProfilePage(
                text: widget.text,
                profile: widget.profile,
                localEvents: widget.localEvents,
                outgoingMessages: widget.outgoingMessages,
                onProfileChanged: widget.onProfileChanged,
                onEventUpdated: widget.onEventUpdated,
                onEventDeleted: widget.onEventDeleted,
                onOutgoingMessageAdded: widget.onOutgoingMessageAdded,
                onOutgoingMessageDeleted: widget.onOutgoingMessageDeleted,
              ),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: bottomPadding,
            child: QadamBottomNav(
              text: widget.text,
              currentIndex: _currentIndex,
              onChanged: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}

enum PointsView { categories, map, workList }

class PointsPage extends StatefulWidget {
  const PointsPage({
    super.key,
    required this.text,
    required this.language,
    required this.localEvents,
    required this.outgoingMessages,
    required this.respondedRequestIds,
    required this.onLanguageChanged,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onRequestResponded,
    required this.onOutgoingMessageAdded,
    required this.onOutgoingMessageDeleted,
  });

  final AppText text;
  final AppLanguage language;
  final List<LocalEvent> localEvents;
  final List<OutgoingMessage> outgoingMessages;
  final Set<String> respondedRequestIds;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<String> onRequestResponded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  PointsView _view = PointsView.categories;
  EventCategory _selectedCategory = EventCategory.meetings;
  String _query = '';
  final Set<String> _readNotificationIds = <String>{};

  void _setView(PointsView view) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      if (view == PointsView.map && _selectedCategory == EventCategory.work) {
        _view = PointsView.workList;
      } else {
        _view = view;
      }
    });
  }

  void _openCategory(EventCategory category, {bool preferMap = false}) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _selectedCategory = category;
      _view = category == EventCategory.work && !preferMap
          ? PointsView.workList
          : PointsView.map;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showTopControls = _view != PointsView.workList;
    final switchValue = _view == PointsView.map
        ? PointsView.map
        : PointsView.categories;
    final notifications = _buildNotifications(
      widget.text,
      widget.localEvents,
      widget.outgoingMessages,
    );
    final unreadCount = notifications
        .where((item) => !_readNotificationIds.contains(item.id))
        .length;

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final offset = Tween<Offset>(
                    begin: const Offset(0.035, 0),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offset, child: child),
                  );
                },
                child: switch (_view) {
                  PointsView.categories => CategoryScreen(
                    key: const ValueKey('categories'),
                    text: widget.text,
                    localEvents: widget.localEvents,
                    query: _query,
                    selectedCategory: _selectedCategory,
                    onCategoryTap: _openCategory,
                  ),
                  PointsView.map => MapScreen(
                    key: const ValueKey('map'),
                    text: widget.text,
                    query: _query,
                    localEvents: widget.localEvents,
                    selectedCategory: _selectedCategory,
                    onEventUpdated: widget.onEventUpdated,
                    onEventDeleted: widget.onEventDeleted,
                    onOutgoingMessageAdded: widget.onOutgoingMessageAdded,
                  ),
                  PointsView.workList => WorkListScreen(
                    key: const ValueKey('workList'),
                    text: widget.text,
                    query: _query,
                    localEvents: widget.localEvents,
                    outgoingMessages: widget.outgoingMessages,
                    respondedRequestIds: widget.respondedRequestIds,
                    onQueryChanged: (value) => setState(() => _query = value),
                    onRequestResponded: widget.onRequestResponded,
                    onOutgoingMessageAdded: widget.onOutgoingMessageAdded,
                    onOutgoingMessageDeleted: widget.onOutgoingMessageDeleted,
                    onOpenMap: () =>
                        _openCategory(EventCategory.work, preferMap: true),
                    onBackToCategories: () =>
                        setState(() => _view = PointsView.categories),
                  ),
                },
              ),
            ),
            if (showTopControls)
              Positioned(
                left: 20,
                right: 20,
                top: 14,
                child: _PointsTopControls(
                  text: widget.text,
                  language: widget.language,
                  onLanguageChanged: widget.onLanguageChanged,
                  query: _query,
                  onQueryChanged: (value) => setState(() => _query = value),
                  selected: switchValue,
                  onModeChanged: _setView,
                  notifications: notifications,
                  unreadCount: unreadCount,
                  onNotificationsRead: () {
                    setState(() {
                      _readNotificationIds.addAll(
                        notifications.map((item) => item.id),
                      );
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PointsTopControls extends StatelessWidget {
  const _PointsTopControls({
    required this.text,
    required this.language,
    required this.onLanguageChanged,
    required this.query,
    required this.onQueryChanged,
    required this.selected,
    required this.onModeChanged,
    required this.notifications,
    required this.unreadCount,
    required this.onNotificationsRead,
  });

  final AppText text;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final PointsView selected;
  final ValueChanged<PointsView> onModeChanged;
  final List<QadamNotification> notifications;
  final int unreadCount;
  final VoidCallback onNotificationsRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopSearchBar(
          text: text,
          language: language,
          onLanguageChanged: onLanguageChanged,
          query: query,
          onQueryChanged: onQueryChanged,
          backgroundColor: Colors.white.withValues(alpha: 0.94),
          notifications: notifications,
          unreadCount: unreadCount,
          onNotificationsRead: onNotificationsRead,
        ),
        const SizedBox(height: 12),
        ModeSwitch(text: text, selected: selected, onChanged: onModeChanged),
      ],
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.text,
    required this.localEvents,
    required this.query,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  final AppText text;
  final List<LocalEvent> localEvents;
  final String query;
  final EventCategory selectedCategory;
  final void Function(EventCategory category, {bool preferMap}) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final foundStaticEvents = _events
        .where((event) => _matchesStaticEvent(text, event, query))
        .toList();
    final foundLocalEvents = localEvents
        .where((event) => _matchesLocalEvent(text, event, query))
        .toList();
    final isSearching = query.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 142, 0, 110),
      children: [
        if (isSearching) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SearchResultsHeader(
              text: text,
              count: foundStaticEvents.length + foundLocalEvents.length,
            ),
          ),
          const SizedBox(height: 12),
          for (final event in foundStaticEvents) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SearchEventResultCard(
                text: text,
                title: event.title(text),
                category: event.category,
                locationName: event.locationName,
                onTap: () => onCategoryTap(event.category, preferMap: true),
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (final event in foundLocalEvents) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SearchEventResultCard(
                text: text,
                title: event.title,
                category: event.category,
                locationName: event.locationName,
                onTap: () => onCategoryTap(event.category, preferMap: true),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (foundStaticEvents.isEmpty && foundLocalEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: EmptyCompactBox(message: text.noSearchResults),
            ),
        ] else
          CategoryDeck(
            text: text,
            localEvents: localEvents,
            selectedCategory: selectedCategory,
            onCategoryTap: onCategoryTap,
          ),
      ],
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.text,
    required this.query,
    required this.localEvents,
    required this.selectedCategory,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onOutgoingMessageAdded,
  });

  final AppText text;
  final String query;
  final List<LocalEvent> localEvents;
  final EventCategory selectedCategory;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;

  @override
  Widget build(BuildContext context) {
    final isSearching = query.trim().isNotEmpty;
    final staticEvents = _events
        .where(
          (event) => isSearching
              ? _matchesStaticEvent(text, event, query)
              : event.category == selectedCategory,
        )
        .toList();
    final userEvents = localEvents
        .where(
          (event) => isSearching
              ? _matchesLocalEvent(text, event, query)
              : event.category == selectedCategory,
        )
        .toList();
    final markers = <Marker>[
      for (final event in staticEvents)
        Marker(
          point: event.point,
          width: 54,
          height: 64,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => _showStaticEventDetails(
              context,
              text: text,
              event: event,
              onOutgoingMessageAdded: onOutgoingMessageAdded,
            ),
            child: MapPin(color: event.category.color),
          ),
        ),
      for (final event in userEvents)
        Marker(
          point: event.point,
          width: 54,
          height: 64,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => _showLocalEventDetails(
              context,
              text: text,
              event: event,
              onEventUpdated: onEventUpdated,
              onEventDeleted: onEventDeleted,
              onOutgoingMessageAdded: onOutgoingMessageAdded,
            ),
            child: MapPin(color: event.category.color),
          ),
        ),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(40.3509, 27.9775),
              initialZoom: 14.0,
              minZoom: 5,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onTap: (_, point) => _showSnack(
                context,
                text.pick(
                  ru: 'Точка: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                  en: 'Point: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                  tr: 'Nokta: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                ),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.qadam',
              ),
              MarkerLayer(markers: markers),
              RichAttributionWidget(
                popupInitialDisplayDuration: const Duration(seconds: 2),
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => _showSnack(context, 'openstreetmap.org'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkListScreen extends StatelessWidget {
  const WorkListScreen({
    super.key,
    required this.text,
    required this.query,
    required this.localEvents,
    required this.outgoingMessages,
    required this.respondedRequestIds,
    required this.onQueryChanged,
    required this.onRequestResponded,
    required this.onOutgoingMessageAdded,
    required this.onOutgoingMessageDeleted,
    required this.onOpenMap,
    required this.onBackToCategories,
  });

  final AppText text;
  final String query;
  final List<LocalEvent> localEvents;
  final List<OutgoingMessage> outgoingMessages;
  final Set<String> respondedRequestIds;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onRequestResponded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;
  final VoidCallback onOpenMap;
  final VoidCallback onBackToCategories;

  @override
  Widget build(BuildContext context) {
    final workEvents = _events
        .where(
          (event) =>
              event.category == EventCategory.work &&
              _matchesStaticEvent(text, event, query),
        )
        .toList();
    final userWorkEvents = localEvents
        .where(
          (event) =>
              event.category == EventCategory.work &&
              _matchesLocalEvent(text, event, query),
        )
        .toList();
    final totalCount = workEvents.length + userWorkEvents.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 112),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBackToCategories,
              icon: const Icon(Icons.tune_rounded),
            ),
            Expanded(
              child: SearchField(
                label: text.searchPoints,
                value: query,
                onChanged: onQueryChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          text.activeWorkResults(totalCount),
          style: const TextStyle(
            color: _muted,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (totalCount == 0)
          EmptyCompactBox(message: text.noSearchResults)
        else ...[
          for (final event in workEvents) ...[
            WorkEventCard(
              text: text,
              title: event.title(text),
              locationName: event.locationName,
              description: event.description(text),
              response: _workEventResponse(outgoingMessages, event),
              onOpenMap: onOpenMap,
              onRespond: () {
                final response = _workEventResponse(outgoingMessages, event);
                if (response != null) {
                  onOutgoingMessageDeleted(response);
                } else {
                  onOutgoingMessageAdded(
                    _workEventResponseMessage(text, event),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
          ],
          for (final event in userWorkEvents) ...[
            WorkEventCard(
              text: text,
              title: event.title,
              locationName: event.locationName,
              description: event.description,
              response: _localWorkEventResponse(outgoingMessages, event),
              onOpenMap: onOpenMap,
              onRespond: () {
                final response = _localWorkEventResponse(
                  outgoingMessages,
                  event,
                );
                if (response != null) {
                  onOutgoingMessageDeleted(response);
                } else {
                  onOutgoingMessageAdded(
                    _localWorkEventResponseMessage(text, event),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class AddEventPage extends StatefulWidget {
  const AddEventPage({
    super.key,
    required this.text,
    required this.onEventAdded,
  });

  final AppText text;
  final ValueChanged<LocalEvent> onEventAdded;

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _descriptionController = TextEditingController();
  EventCategory _category = EventCategory.events;
  LocationOption _location = _locationOptions.first;
  String _photoBase64 = '';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      _showSnack(
        context,
        widget.text.pick(
          ru: 'Напишите описание события',
          en: 'Write an event description',
          tr: 'Etkinlik açıklaması yazın',
        ),
      );
      return;
    }

    final now = DateTime.now();
    final event = LocalEvent(
      id: 'event-${now.microsecondsSinceEpoch}',
      title: description.split('\n').first,
      description: description,
      category: _category,
      locationName: _location.label,
      lat: _location.point.latitude,
      lng: _location.point.longitude,
      createdAt: now,
      photoBase64: _photoBase64,
    );
    widget.onEventAdded(event);
    _descriptionController.clear();
    setState(() => _photoBase64 = '');
    _showSnack(context, widget.text.savedDraft);
  }

  Future<void> _pickPhoto() async {
    final photoBase64 = await _pickImageBase64(context, widget.text);
    if (photoBase64 == null || !mounted) return;
    setState(() => _photoBase64 = photoBase64);
    _showSnack(context, widget.text.eventPhotoAdded);
  }

  Future<void> _pickCategory() async {
    final selected = await _showQadamActionSheet<EventCategory>(
      context: context,
      title: widget.text.activityType,
      actions: [
        for (final category in EventCategory.values)
          QadamSheetAction(
            value: category,
            title: widget.text.category(category),
            icon: Icons.circle_rounded,
            iconColor: category.color,
            selected: category == _category,
          ),
      ],
    );
    if (selected != null) {
      setState(() => _category = selected);
    }
  }

  Future<void> _pickLocation() async {
    final selected = await _showQadamActionSheet<LocationOption>(
      context: context,
      title: widget.text.location,
      actions: [
        for (final location in _locationOptions)
          QadamSheetAction(
            value: location,
            title: location.label,
            subtitle:
                '${location.point.latitude.toStringAsFixed(4)}, '
                '${location.point.longitude.toStringAsFixed(4)}',
            icon: Icons.location_on_outlined,
            selected: location == _location,
          ),
      ],
    );
    if (selected != null) {
      setState(() => _location = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(26, 42, 26, 112),
          children: [
            DashedUploadBox(
              photoBase64: _photoBase64,
              changeLabel: text.changePhoto,
              onTap: _pickPhoto,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: text.writeDescription,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: _muted,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 58),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickCategory,
                    child: EventFormChip(
                      label:
                          '${text.activityType}: ${text.category(_category)}',
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickLocation,
                    child: EventFormChip(
                      label: '${text.location}: ${_location.label}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 104),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: OutlinedButton(
                onPressed: _saveEvent,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: const BorderSide(color: _ink, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  text.add,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageMode { inbox, outbox, mine }

class MessagesPage extends StatefulWidget {
  const MessagesPage({
    super.key,
    required this.text,
    required this.localEvents,
    required this.respondedRequestIds,
    required this.outgoingMessages,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onRequestResponded,
    required this.onOutgoingMessageDeleted,
  });

  final AppText text;
  final List<LocalEvent> localEvents;
  final Set<String> respondedRequestIds;
  final List<OutgoingMessage> outgoingMessages;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<String> onRequestResponded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  MessageMode _mode = MessageMode.inbox;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 44, 22, 24),
              child: SegmentSwitch<MessageMode>(
                value: _mode,
                items: [
                  SegmentItem(
                    value: MessageMode.inbox,
                    label: widget.text.inbox,
                  ),
                  SegmentItem(
                    value: MessageMode.outbox,
                    label: widget.text.outbox,
                  ),
                  SegmentItem(
                    value: MessageMode.mine,
                    label: widget.text.myAds,
                  ),
                ],
                onChanged: (mode) => setState(() => _mode = mode),
              ),
            ),
            Expanded(
              child: switch (_mode) {
                MessageMode.inbox => ListView(
                  padding: const EdgeInsets.fromLTRB(32, 0, 22, 112),
                  children: [MessagePreview(text: widget.text)],
                ),
                MessageMode.outbox =>
                  widget.outgoingMessages.isEmpty
                      ? EmptyStateMessage(message: widget.text.emptyOutbox)
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 112),
                          children: [
                            for (final message in widget.outgoingMessages) ...[
                              OutgoingMessageCard(
                                text: widget.text,
                                message: message,
                                onDelete: () =>
                                    widget.onOutgoingMessageDeleted(message),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                MessageMode.mine =>
                  widget.localEvents.isEmpty &&
                          widget.respondedRequestIds.isEmpty
                      ? EmptyStateMessage(message: widget.text.emptyAdList)
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 112),
                          children: [
                            for (final event in widget.localEvents) ...[
                              LocalEventCard(
                                text: widget.text,
                                event: event,
                                onTap: () => _showLocalEventDetails(
                                  context,
                                  text: widget.text,
                                  event: event,
                                  onEventUpdated: widget.onEventUpdated,
                                  onEventDeleted: widget.onEventDeleted,
                                ),
                                onEdit: () => _editLocalEvent(
                                  context,
                                  text: widget.text,
                                  event: event,
                                  onEventUpdated: widget.onEventUpdated,
                                ),
                                onDelete: () => _deleteLocalEvent(
                                  context,
                                  text: widget.text,
                                  event: event,
                                  onEventDeleted: widget.onEventDeleted,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            for (final request in _workRequests.where(
                              (request) => widget.respondedRequestIds.contains(
                                request.id,
                              ),
                            )) ...[
                              RespondedRequestCard(
                                text: widget.text,
                                request: request,
                                onDelete: () =>
                                    widget.onRequestResponded(request.id),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.text,
    required this.profile,
    required this.localEvents,
    required this.outgoingMessages,
    required this.onProfileChanged,
    required this.onEventUpdated,
    required this.onEventDeleted,
    required this.onOutgoingMessageAdded,
    required this.onOutgoingMessageDeleted,
  });

  final AppText text;
  final UserProfile profile;
  final List<LocalEvent> localEvents;
  final List<OutgoingMessage> outgoingMessages;
  final ValueChanged<UserProfile> onProfileChanged;
  final ValueChanged<LocalEvent> onEventUpdated;
  final ValueChanged<String> onEventDeleted;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;
  final ValueChanged<OutgoingMessage> onOutgoingMessageDeleted;

  Future<void> _changePhoto(BuildContext context) async {
    await _pickProfilePhoto(
      context,
      text: text,
      profile: profile,
      onProfileChanged: onProfileChanged,
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    await _showQadamBottomSheet<void>(
      context,
      isScrollControlled: true,
      builder: (context) => ProfileEditSheet(
        text: text,
        profile: profile,
        onProfileChanged: onProfileChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontFamily: _jaldiFont,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 52, 22, 112),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _changePhoto(context),
                    child: Stack(
                      children: [
                        ProfileAvatar(profile: profile, size: 136),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              size: 18,
                              color: _ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                profile.name,
                                style: const TextStyle(
                                  fontFamily: _jaldiFont,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _editProfile(context),
                              icon: const Icon(Icons.edit_outlined, size: 21),
                              tooltip: text.edit,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.role,
                          style: const TextStyle(
                            color: _muted,
                            fontFamily: _jaldiFont,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.bio,
                          style: const TextStyle(
                            color: _muted,
                            fontFamily: _jaldiFont,
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 14),
                        RatingLine(text: text),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFF63DA7A),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${profile.city} • ${text.online}',
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: _jaldiFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                text.myProjects,
                style: const TextStyle(
                  fontFamily: _jaldiFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              if (outgoingMessages.isEmpty)
                EmptyCompactBox(message: text.emptyOutbox)
              else
                SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: outgoingMessages.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 184,
                        child: ProjectMapCard(
                          text: text,
                          message: outgoingMessages[index],
                          onDelete: () =>
                              onOutgoingMessageDeleted(outgoingMessages[index]),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 34),
              Text(
                text.eventsTitle,
                style: const TextStyle(
                  fontFamily: _jaldiFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              if (localEvents.isEmpty)
                ProfileEventBox(
                  text: text,
                  onOutgoingMessageAdded: onOutgoingMessageAdded,
                )
              else
                for (final event in localEvents.take(3)) ...[
                  LocalEventCard(
                    text: text,
                    event: event,
                    onTap: () => _showLocalEventDetails(
                      context,
                      text: text,
                      event: event,
                      onEventUpdated: onEventUpdated,
                      onEventDeleted: onEventDeleted,
                    ),
                    onEdit: () => _editLocalEvent(
                      context,
                      text: text,
                      event: event,
                      onEventUpdated: onEventUpdated,
                    ),
                    onDelete: () => _deleteLocalEvent(
                      context,
                      text: text,
                      event: event,
                      onEventDeleted: onEventDeleted,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class QadamBottomNav extends StatelessWidget {
  const QadamBottomNav({
    super.key,
    required this.text,
    required this.currentIndex,
    required this.onChanged,
  });

  final AppText text;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(Icons.add_rounded, text.add),
      _NavItemData(Icons.location_on_outlined, text.points),
      _NavItemData(Icons.mail_outline_rounded, text.messages),
      _NavItemData(Icons.person_outline_rounded, text.profile),
    ];

    const radius = 50.0;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFEBECED),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFD4D5D6), width: 0.8),
        boxShadow: [
          // мягкая светлая тень сверху-слева (highlight)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.90),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
          // тёмная тень снизу-справа (depth)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 10,
            offset: const Offset(3, 5),
          ),
          // общая мягкая тень
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(radius),
                    splashColor: Colors.black.withValues(alpha: 0.05),
                    highlightColor: Colors.black.withValues(alpha: 0.02),
                    onTap: () => onChanged(index),
                    child: _BottomNavItem(
                      item: items[index],
                      isActive: index == currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({required this.item, required this.isActive});

  final _NavItemData item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0D0D0D) : const Color(0xFF6B6B6B);

    return Semantics(
      button: true,
      selected: isActive,
      label: item.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final labelWidth = math.max(0.0, constraints.maxWidth - 4);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: color, size: 24),
                const SizedBox(height: 3),
                SizedBox(
                  width: labelWidth,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontFamily: _jaldiFont,
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      letterSpacing: 0,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData(this.icon, this.label);

  final IconData icon;
  final String label;
}

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({
    super.key,
    required this.text,
    required this.language,
    required this.onLanguageChanged,
    this.query = '',
    this.onQueryChanged,
    this.backgroundColor = Colors.white,
    this.notifications = const [],
    this.unreadCount = 0,
    this.onNotificationsRead,
  });

  final AppText text;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final String query;
  final ValueChanged<String>? onQueryChanged;
  final Color backgroundColor;
  final List<QadamNotification> notifications;
  final int unreadCount;
  final VoidCallback? onNotificationsRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchField(
            label: text.searchPoints,
            value: query,
            onChanged: onQueryChanged,
            color: backgroundColor,
          ),
        ),
        const SizedBox(width: 10),
        LanguageSwitcher(language: language, onChanged: onLanguageChanged),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: text.notifications,
          child: SizedBox(
            width: 24,
            height: 41,
            child: InkResponse(
              key: const Key('notificationBell'),
              radius: 24,
              onTap: () => _showNotificationsSheet(
                context,
                text: text,
                notifications: notifications,
                onMarkRead: onNotificationsRead,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    _figmaBellAsset,
                    width: 24,
                    height: 24,
                    color: Colors.black,
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 5,
                      right: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white, width: 1.4),
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: _jockeyOneFont,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.label,
    this.value = '',
    this.onChanged,
    this.color = Colors.white,
  });

  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final Color color;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF8E8E8E), width: 1.15),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  setState(() {});
                },
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.label,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 46),
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Color(0xFF858585),
                    fontFamily: _montserratFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    height: 1,
                  ),
                ),
                style: const TextStyle(
                  color: _ink,
                  fontFamily: _montserratFont,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                  height: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 19,
            bottom: 0,
            child: Center(
              child: _controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF8E8E8E),
                        size: 20,
                      ),
                    )
                  : Image.asset(
                      _figmaSearchIconAsset,
                      width: 17,
                      height: 15,
                      color: const Color(0xFF8E8E8E),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({
    super.key,
    required this.language,
    required this.onChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in AppLanguage.values)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: item == language ? _ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item.shortLabel,
                  style: TextStyle(
                    color: item == language ? Colors.white : _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ModeSwitch extends StatelessWidget {
  const ModeSwitch({
    super.key,
    required this.text,
    required this.selected,
    required this.onChanged,
  });

  final AppText text;
  final PointsView selected;
  final ValueChanged<PointsView> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentSwitch<PointsView>(
      value: selected,
      height: 42,
      glass: true,
      items: [
        SegmentItem(value: PointsView.categories, label: text.categories),
        SegmentItem(value: PointsView.map, label: text.map),
      ],
      onChanged: onChanged,
    );
  }
}

class SegmentItem<T> {
  const SegmentItem({required this.value, required this.label});

  final T value;
  final String label;
}

class SegmentSwitch<T> extends StatelessWidget {
  const SegmentSwitch({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 34,
    this.glass = false,
  });

  final T value;
  final List<SegmentItem<T>> items;
  final ValueChanged<T> onChanged;
  final double height;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = math.max(
      0,
      items.indexWhere((item) => item.value == value),
    );
    final radius = BorderRadius.circular(height / 2);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: glass ? Colors.white.withValues(alpha: 0.14) : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: glass
              ? const Color(0xFF95979B).withValues(alpha: 0.70)
              : const Color(0xFFA7A9AE),
          width: glass ? 1.35 : 1.2,
        ),
        boxShadow: glass
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 24,
                  spreadRadius: -8,
                  offset: const Offset(0, 13),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.48),
                  blurRadius: 11,
                  spreadRadius: -5,
                  offset: const Offset(-4, -5),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / items.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 330),
                curve: Curves.easeOutCubic,
                left: selectedIndex * itemWidth + 1.5,
                top: 1.5,
                bottom: 1.5,
                width: itemWidth - 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular((height - 3) / 2),
                    border: Border.all(
                      color: const Color(0xFFE1E1E1).withValues(alpha: 0.82),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 11,
                        spreadRadius: -4,
                        offset: const Offset(3, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.78),
                        blurRadius: 8,
                        spreadRadius: -2,
                        offset: const Offset(-3, -2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (final item in items)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          onChanged(item.value);
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                style: TextStyle(
                                  color: item.value == value
                                      ? Colors.black
                                      : const Color(0xFF666F72),
                                  fontFamily: _montserratFont,
                                  fontSize: glass ? 20 : 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0,
                                  height: 1,
                                ),
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryDeck extends StatelessWidget {
  const CategoryDeck({
    super.key,
    required this.text,
    required this.localEvents,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  final AppText text;
  final List<LocalEvent> localEvents;
  final EventCategory selectedCategory;
  final void Function(EventCategory category, {bool preferMap}) onCategoryTap;

  static const double _step = 150;
  static const double _tileHeight = 190;
  static const double _tileContentHeight = 157;
  static const double _eventsHeight = 170;
  static const double _edgeBleed = 36;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _step * 3 + _eventsHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var index = 0; index < _categories.length; index++)
            Positioned(
              left: -_categoryDeckBleedLeft(_categories[index].category),
              right: -_categoryDeckBleedRight(_categories[index].category),
              top: index * _step,
              child: CategoryTile(
                text: text,
                item: _categories[index],
                count: _mapEventCountForCategory(
                  _categories[index].category,
                  localEvents,
                ),
                isSelected: _categories[index].category == selectedCategory,
                height: _categories[index].category == EventCategory.events
                    ? _eventsHeight
                    : _tileHeight,
                contentHeight:
                    _categories[index].category == EventCategory.events
                    ? _eventsHeight
                    : _tileContentHeight,
                borderRadius: _categoryDeckRadius(_categories[index].category),
                bleedLeft: _categoryDeckBleedLeft(_categories[index].category),
                bleedRight: _categoryDeckBleedRight(
                  _categories[index].category,
                ),
                onTap: () => onCategoryTap(_categories[index].category),
              ),
            ),
        ],
      ),
    );
  }

  static double _categoryDeckBleedLeft(EventCategory category) {
    return category == EventCategory.work ? _edgeBleed : 0;
  }

  static double _categoryDeckBleedRight(EventCategory category) {
    return category == EventCategory.meetings ||
            category == EventCategory.startups
        ? _edgeBleed
        : 0;
  }
}

BorderRadius _categoryDeckRadius(EventCategory category) {
  const radius = Radius.circular(30);
  switch (category) {
    case EventCategory.meetings:
      return const BorderRadius.only(topLeft: radius);
    case EventCategory.work:
      return const BorderRadius.only(topRight: radius);
    case EventCategory.startups:
      return const BorderRadius.only(topLeft: radius);
    case EventCategory.events:
      return const BorderRadius.only(topRight: radius);
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.text,
    required this.item,
    required this.count,
    required this.isSelected,
    required this.height,
    required this.contentHeight,
    required this.borderRadius,
    required this.bleedLeft,
    required this.bleedRight,
    required this.onTap,
  });

  final AppText text;
  final CategoryItem item;
  final int count;
  final bool isSelected;
  final double height;
  final double contentHeight;
  final BorderRadius borderRadius;
  final double bleedLeft;
  final double bleedRight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.accent ?? item.category.accentColor;

    return Material(
      color: item.color,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          height: height,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: contentHeight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  42 + bleedLeft,
                  28,
                  54 + bleedRight,
                  24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text.category(item.category),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: accent,
                              fontFamily: _montserratFont,
                              fontSize: 35,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 18),
                          CategoryCountPill(
                            count: count,
                            suffix: text.resultSuffix,
                            color: accent,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accent, width: 1.3),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: accent,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCountPill extends StatelessWidget {
  const CategoryCountPill({
    super.key,
    required this.count,
    required this.suffix,
    required this.color,
  });

  final int count;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 6, 14, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color, width: 1.3),
      ),
      child: RichText(
        maxLines: 1,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$count ',
              style: TextStyle(
                color: color,
                fontFamily: _jockeyOneFont,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
            TextSpan(
              text: suffix,
              style: TextStyle(
                color: color,
                fontFamily: _montserratFont,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlinePill extends StatelessWidget {
  const OutlinePill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontFamily: 'Jaldi',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class SearchResultsHeader extends StatelessWidget {
  const SearchResultsHeader({
    super.key,
    required this.text,
    required this.count,
  });

  final AppText text;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.searchResults(count),
      style: const TextStyle(
        color: _muted,
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class SearchEventResultCard extends StatelessWidget {
  const SearchEventResultCard({
    super.key,
    required this.text,
    required this.title,
    required this.category,
    required this.locationName,
    required this.onTap,
  });

  final AppText text;
  final String title;
  final EventCategory category;
  final String locationName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _line),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: category.color,
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${text.category(category)} • $locationName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: _jockeyOneFont,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }
}

class CityChip extends StatelessWidget {
  const CityChip({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selected ? const Color(0xFF61A7D7) : const Color(0xFF9B8B76),
        image: DecorationImage(
          image: CityPatternImage(label.hashCode),
          fit: BoxFit.cover,
          opacity: 0.55,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: _jockeyOneFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
        ),
      ),
    );
  }
}

class WorkRequestCard extends StatelessWidget {
  const WorkRequestCard({
    super.key,
    required this.text,
    required this.request,
    required this.isResponded,
    required this.onRespond,
  });

  final AppText text;
  final WorkRequest request;
  final bool isResponded;
  final VoidCallback onRespond;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 16,
                color: Color(0xFF34C759),
              ),
              const SizedBox(width: 6),
              Text(
                text.nowWatching,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontFamily: _istokWebFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            request.title(text),
            style: const TextStyle(
              fontFamily: _istokWebFont,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request.company,
            style: const TextStyle(
              fontFamily: _istokWebFont,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            request.price,
            style: const TextStyle(
              fontFamily: _istokWebFont,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${text.cityAstana} • ${text.online} / ${text.offline}',
            style: const TextStyle(
              fontFamily: _jockeyOneFont,
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request.shortDeadline ? text.deadlineShort : text.deadline,
            style: const TextStyle(
              fontFamily: _istokWebFont,
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {}, // Fixed undefined onOpenMap
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        text.openOnMap, // Fixed undefined text.onMap
                        style: const TextStyle(
                          fontFamily: _istokWebFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRespond,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFFF2F2F7),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isResponded
                        ? text.pick(
                            ru: 'Отклик отправлен',
                            en: 'Responded',
                            tr: 'Başvuruldu',
                          )
                        : text.respond,
                    style: const TextStyle(
                      fontFamily: _istokWebFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkEventCard extends StatelessWidget {
  const WorkEventCard({
    super.key,
    required this.text,
    required this.title,
    required this.locationName,
    required this.description,
    required this.response,
    required this.onOpenMap,
    required this.onRespond,
  });

  final AppText text;
  final String title;
  final String locationName;
  final String description;
  final OutgoingMessage? response;
  final VoidCallback onOpenMap;
  final VoidCallback onRespond;

  @override
  Widget build(BuildContext context) {
    final isResponded = response != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpenMap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF8E9095), width: 1.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: Color(0xFF62D879),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    text.nowWatching,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                locationName,
                style: const TextStyle(
                  color: _muted,
                  fontFamily: _jockeyOneFont,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 13,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenMap,
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: Text(text.openOnMap),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _ink,
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRespond,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isResponded ? Colors.white : _ink,
                        backgroundColor: isResponded ? _ink : _paper,
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        isResponded ? text.removeResponse : text.respond,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedUploadBox extends StatelessWidget {
  const DashedUploadBox({
    super.key,
    required this.photoBase64,
    required this.changeLabel,
    required this.onTap,
  });

  final String photoBase64;
  final String changeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (photoBase64.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(photoBase64));
      } catch (_) {
        image = null;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          height: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image(image: image, fit: BoxFit.cover)
              else
                const SizedBox.shrink(),
              if (image != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                ),
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: image == null
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: image == null
                          ? const Color(0xFF62646A)
                          : Colors.white,
                      width: 1.4,
                    ),
                  ),
                  child: Icon(
                    image == null
                        ? Icons.photo_camera_outlined
                        : Icons.edit_outlined,
                    size: 36,
                    color: const Color(0xFF62646A),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 16,
                child: AnimatedOpacity(
                  opacity: image == null ? 0 : 1,
                  duration: const Duration(milliseconds: 180),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Text(
                        changeLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _ink,
                          fontFamily: _jockeyOneFont,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalEventPhotoThumb extends StatelessWidget {
  const LocalEventPhotoThumb({
    super.key,
    required this.photoBase64,
    required this.size,
  });

  final String photoBase64;
  final double size;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (photoBase64.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(photoBase64));
      } catch (_) {
        image = null;
      }
    }
    if (image == null) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(image: image, fit: BoxFit.cover),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
      ),
    );
  }
}

class EventPhotoHeader extends StatelessWidget {
  const EventPhotoHeader({super.key, required this.photoBase64});

  final String photoBase64;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (photoBase64.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(photoBase64));
      } catch (_) {
        image = null;
      }
    }
    if (image == null) return const SizedBox.shrink();

    return Container(
      height: 168,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

class EventFormChip extends StatelessWidget {
  const EventFormChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 104,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFD9DADC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: _muted,
              fontFamily: _jaldiFont,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePreview extends StatelessWidget {
  const MessagePreview({super.key, required this.text});

  final AppText text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showInboxMessageDetails(context, text),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text.pick(
                      ru: 'Ислам Исламович',
                      en: 'Islam Islamovich',
                      tr: 'Islam Islamovich',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text.pick(
                      ru: 'Отправлено 2 ч. назад',
                      en: 'Sent 2 hours ago',
                      tr: '2 saat önce gönderildi',
                    ),
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: _paper,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.photo_camera_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

void _showInboxMessageDetails(BuildContext context, AppText text) {
  _showQadamBottomSheet<void>(
    context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: _paper,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_camera_outlined),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text.pick(
                          ru: 'Ислам Исламович',
                          en: 'Islam Islamovich',
                          tr: 'Islam Islamovich',
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        text.pick(
                          ru: 'Отправлено 2 ч. назад',
                          en: 'Sent 2 hours ago',
                          tr: '2 saat önce gönderildi',
                        ),
                        style: const TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              text.pick(
                ru: 'Здравствуйте! Я увидел ваше объявление и хочу обсудить детали. Могу подойти сегодня вечером или завтра утром.',
                en: 'Hi! I saw your listing and want to discuss the details. I can come by this evening or tomorrow morning.',
                tr: 'Merhaba! İlanınızı gördüm ve detayları konuşmak istiyorum. Bu akşam veya yarın sabah gelebilirim.',
              ),
              style: const TextStyle(
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showSnack(
                  context,
                  text.pick(
                    ru: 'Ответ сохранен в демо-режиме',
                    en: 'Reply saved in demo mode',
                    tr: 'Yanıt demo modunda kaydedildi',
                  ),
                );
              },
              icon: const Icon(Icons.reply_rounded),
              label: Text(
                text.pick(ru: 'Ответить', en: 'Reply', tr: 'Yanıtla'),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: _ink,
                side: const BorderSide(color: _ink, width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class LocalEventCard extends StatelessWidget {
  const LocalEventCard({
    super.key,
    required this.text,
    required this.event,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final AppText text;
  final LocalEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final foreground = event.category.foregroundColor;
    final accent = event.category.accentColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 112),
        padding: const EdgeInsets.fromLTRB(24, 18, 16, 18),
        decoration: BoxDecoration(
          color: event.category.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground,
                      fontFamily: 'Jaldi',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinePill(
                        label: text.category(event.category),
                        color: accent,
                      ),
                      OutlinePill(label: event.locationName, color: accent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (event.photoBase64.isNotEmpty) ...[
              LocalEventPhotoThumb(photoBase64: event.photoBase64, size: 54),
              const SizedBox(width: 10),
            ],
            if (onEdit != null || onDelete != null)
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accent, width: 1.4),
                ),
                child: IconButton(
                  icon: Icon(Icons.more_horiz_rounded, color: accent),
                  onPressed: () async {
                    final action = await _showQadamActionSheet<String>(
                      context: context,
                      title: event.title,
                      actions: [
                        if (onEdit != null)
                          QadamSheetAction(
                            value: 'edit',
                            title: text.edit,
                            icon: Icons.edit_outlined,
                          ),
                        if (onDelete != null)
                          QadamSheetAction(
                            value: 'delete',
                            title: text.delete,
                            icon: Icons.delete_outline_rounded,
                            destructive: true,
                          ),
                      ],
                    );
                    if (action == 'edit') onEdit?.call();
                    if (action == 'delete') onDelete?.call();
                  },
                ),
              )
            else
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accent, width: 1.4),
                ),
                child: Icon(Icons.arrow_forward_rounded, color: accent),
              ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateMessage extends StatelessWidget {
  const EmptyStateMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 96),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class OutgoingMessageCard extends StatelessWidget {
  const OutgoingMessageCard({
    super.key,
    required this.text,
    required this.message,
    required this.onDelete,
  });

  final AppText text;
  final OutgoingMessage message;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: _ink,
            child: const Icon(
              Icons.north_east_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message.body,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _relativeTime(text, message.createdAt),
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () async {
              final action = await _showQadamActionSheet<String>(
                context: context,
                title: message.title,
                actions: [
                  QadamSheetAction(
                    value: 'delete',
                    title: text.delete,
                    icon: Icons.delete_outline_rounded,
                    destructive: true,
                  ),
                ],
              );
              if (action == 'delete') onDelete();
            },
          ),
        ],
      ),
    );
  }
}

class RespondedRequestCard extends StatelessWidget {
  const RespondedRequestCard({
    super.key,
    required this.text,
    required this.request,
    required this.onDelete,
  });

  final AppText text;
  final WorkRequest request;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply_rounded, color: _ink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              request.title(text),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            request.price,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded),
            tooltip: text.removeResponse,
          ),
        ],
      ),
    );
  }
}

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.text});

  final AppText text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFEEE45A)),
        const SizedBox(width: 4),
        const Text(
          '4.5',
          style: TextStyle(fontFamily: _jaldiFont, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 30),
        Text(
          text.profileReviews,
          style: const TextStyle(
            color: _muted,
            fontFamily: _jaldiFont,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ProjectMapCard extends StatelessWidget {
  const ProjectMapCard({
    super.key,
    required this.text,
    required this.message,
    required this.onDelete,
  });

  final AppText text;
  final OutgoingMessage message;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: MiniMapPainter())),
          Positioned(
            top: 12,
            right: 18,
            child: Row(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1683E8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 17,
                      color: _ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: _jaldiFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded, color: _muted),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCompactBox extends StatelessWidget {
  const EmptyCompactBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class ProfileEventBox extends StatelessWidget {
  const ProfileEventBox({
    super.key,
    required this.text,
    required this.onOutgoingMessageAdded,
  });

  final AppText text;
  final ValueChanged<OutgoingMessage> onOutgoingMessageAdded;

  @override
  Widget build(BuildContext context) {
    final suggestedEvents = _events
        .where((event) => event.category == EventCategory.events)
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.profileEventsIntro,
            style: const TextStyle(
              fontFamily: _jaldiFont,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text.profileEventsHint,
            style: const TextStyle(
              color: _muted,
              fontFamily: _jaldiFont,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < suggestedEvents.length; index++) ...[
            ProfileSuggestedEventRow(
              text: text,
              event: suggestedEvents[index],
              onTap: () => _showStaticEventDetails(
                context,
                text: text,
                event: suggestedEvents[index],
                onOutgoingMessageAdded: onOutgoingMessageAdded,
              ),
            ),
            if (index != suggestedEvents.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class ProfileSuggestedEventRow extends StatelessWidget {
  const ProfileSuggestedEventRow({
    super.key,
    required this.text,
    required this.event,
    required this.onTap,
  });

  final AppText text;
  final EventItem event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _paper,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: event.category.accentColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title(text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _jaldiFont,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${event.locationName} • ${text.category(event.category)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: _jaldiFont,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: event.category.accentColor),
                ),
                child: Text(
                  text.details,
                  style: TextStyle(
                    color: event.category.accentColor,
                    fontFamily: _jaldiFont,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPin extends StatelessWidget {
  const MapPin({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: Icon(
        Icons.location_on_rounded,
        size: 56,
        color: color,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class QadamLogoImage extends StatelessWidget {
  const QadamLogoImage({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _qadamLogoAsset,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEFF4F8), BlendMode.src);

    final water = Paint()..color = const Color(0xFFB4DAF4);
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * 0.28, 0)
        ..quadraticBezierTo(
          size.width * 0.18,
          size.height * 0.22,
          0,
          size.height * 0.32,
        )
        ..close(),
      water,
    );

    final park = Paint()..color = const Color(0xFFDDEFCF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.13,
          size.height * 0.04,
          size.width * 0.26,
          size.height * 0.18,
        ),
        const Radius.circular(18),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.78,
          size.width * 0.24,
          size.height * 0.15,
        ),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFE8DDF3),
    );

    final roadShadow = Paint()
      ..color = const Color(0xFFC9CED8)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawRoad(List<Offset> points) {
      final path = Path()
        ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx * size.width, point.dy * size.height);
      }
      canvas.drawPath(path, roadShadow);
      canvas.drawPath(path, road);
    }

    drawRoad(const [
      Offset(-0.12, 0.45),
      Offset(0.16, 0.38),
      Offset(0.36, 0.5),
      Offset(0.68, 0.36),
      Offset(1.1, 0.46),
    ]);
    drawRoad(const [
      Offset(0.22, -0.08),
      Offset(0.34, 0.22),
      Offset(0.29, 0.68),
      Offset(0.36, 1.08),
    ]);
    drawRoad(const [
      Offset(0.76, -0.05),
      Offset(0.71, 0.28),
      Offset(0.78, 0.58),
      Offset(0.72, 1.06),
    ]);

    final smallRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 11; i++) {
      final y = size.height * (0.1 + i * 0.08);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + math.sin(i * 1.7) * 28),
        smallRoad,
      );
    }
    for (var i = 0; i < 7; i++) {
      final x = size.width * (0.08 + i * 0.14);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + math.cos(i * 1.4) * 22, size.height),
        smallRoad,
      );
    }

    final labels = [
      ('Haydar', Offset(0.43, 0.15)),
      ('Charge', Offset(0.49, 0.26)),
      ('BENTBASI', Offset(0.43, 0.47)),
      ('MEGA', Offset(0.72, 0.64)),
    ];
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(
          text: label.$1,
          style: const TextStyle(
            color: Color(0xFF7D8794),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(label.$2.dx * size.width, label.$2.dy * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEAF3FF), BlendMode.src);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * (0.18 + i * 0.18)),
        Offset(size.width, size.height * (0.26 + i * 0.17)),
        road,
      );
    }
    for (var i = 0; i < 4; i++) {
      final x = size.width * (0.15 + i * 0.22);
      canvas.drawLine(Offset(x, 0), Offset(x - 16, size.height), road);
    }
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.34),
      7,
      Paint()..color = const Color(0xFF1683E8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B8E95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    const dash = 7.0;
    const gap = 7.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(24),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CityPatternImage extends ImageProvider<CityPatternImage> {
  const CityPatternImage(this.seed);

  final int seed;

  @override
  Future<CityPatternImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CityPatternImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CityPatternImage key,
    ImageDecoderCallback decode,
  ) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(180, 80);
    final random = math.Random(seed);
    canvas.drawColor(const Color(0xFF658BA3), BlendMode.src);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 28; i++) {
      paint.color = Color.lerp(
        Colors.white,
        const Color(0xFF2F5A72),
        random.nextDouble(),
      )!.withValues(alpha: 0.74);
      final w = 5 + random.nextDouble() * 12;
      final h = 18 + random.nextDouble() * 54;
      canvas.drawRect(
        Rect.fromLTWH(random.nextDouble() * size.width, size.height - h, w, h),
        paint,
      );
    }
    final picture = recorder.endRecording();
    final imageFuture = picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    return OneFrameImageStreamCompleter(
      imageFuture.then((image) => ImageInfo(image: image)),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CityPatternImage && other.seed == seed;
  }

  @override
  int get hashCode => seed.hashCode;
}

class QadamSheetAction<T> {
  const QadamSheetAction({
    required this.value,
    required this.title,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.selected = false,
    this.destructive = false,
  });

  final T value;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final bool selected;
  final bool destructive;
}

class QadamNotification {
  const QadamNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final IconData icon;
  final Color color;
}

List<QadamNotification> _buildNotifications(
  AppText text,
  List<LocalEvent> localEvents,
  List<OutgoingMessage> outgoingMessages,
) {
  final notifications = <QadamNotification>[
    for (final event in localEvents)
      QadamNotification(
        id: 'event-${event.id}',
        title: text.eventPublished,
        body: '${event.title} • ${event.locationName}',
        createdAt: event.createdAt,
        icon: Icons.event_available_rounded,
        color: event.category.color,
      ),
    for (final message in outgoingMessages)
      QadamNotification(
        id: 'message-${message.id}',
        title: text.responseNotification,
        body: '${message.title} • ${message.subtitle}',
        createdAt: message.createdAt,
        icon: Icons.mark_email_unread_outlined,
        color: _ink,
      ),
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return notifications.take(8).toList();
}

Future<T?> _showQadamBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.34),
    builder: (sheetContext) => _QadamSheetFrame(child: builder(sheetContext)),
  );
}

void _showNotificationsSheet(
  BuildContext context, {
  required AppText text,
  required List<QadamNotification> notifications,
  VoidCallback? onMarkRead,
}) {
  onMarkRead?.call();
  _showQadamBottomSheet<void>(
    context,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  text.notifications,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: _jockeyOneFont,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (notifications.isNotEmpty)
                TextButton(
                  onPressed: () {
                    onMarkRead?.call();
                    Navigator.pop(context);
                  },
                  child: Text(
                    text.markAllRead,
                    style: const TextStyle(fontFamily: _jockeyOneFont),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (notifications.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: Text(
                text.noNotifications,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _muted,
                  fontFamily: _jockeyOneFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var index = 0; index < notifications.length; index++)
                      _NotificationRow(
                        text: text,
                        notification: notifications[index],
                        showDivider: index != notifications.length - 1,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.text,
    required this.notification,
    required this.showDivider,
  });

  final AppText text;
  final QadamNotification notification;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontFamily: _jockeyOneFont,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontFamily: _jockeyOneFont,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _relativeTime(text, notification.createdAt),
              style: const TextStyle(
                color: _muted,
                fontFamily: _jockeyOneFont,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> _showQadamActionSheet<T>({
  required BuildContext context,
  required String title,
  required List<QadamSheetAction<T>> actions,
}) {
  return _showQadamBottomSheet<T>(
    context,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontFamily: _montserratFont,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < actions.length; index++) ...[
                    _QadamActionRow(action: actions[index]),
                    if (index != actions.length - 1)
                      Divider(
                        height: 1,
                        indent: 72,
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _QadamSheetFrame extends StatelessWidget {
  const _QadamSheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QadamActionRow<T> extends StatelessWidget {
  const _QadamActionRow({required this.action});

  final QadamSheetAction<T> action;

  @override
  Widget build(BuildContext context) {
    final tint = action.destructive
        ? const Color(0xFFFF3B30)
        : action.iconColor ?? _ink;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.pop(context, action.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: tint, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: action.destructive ? tint : _ink,
                        fontFamily: _montserratFont,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (action.subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        action.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontFamily: _montserratFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (action.selected)
                const Icon(Icons.check_rounded, color: _ink, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: _jockeyOneFont,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}

int _mapEventCountForCategory(
  EventCategory category,
  List<LocalEvent> localEvents,
) {
  return _events.where((event) => event.category == category).length +
      localEvents.where((event) => event.category == category).length;
}

bool _matchesStaticEvent(AppText text, EventItem event, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return true;
  return [
    event.title(text),
    event.description(text),
    event.locationName,
    text.category(event.category),
  ].any((value) => value.toLowerCase().contains(normalized));
}

bool _matchesLocalEvent(AppText text, LocalEvent event, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return true;
  return [
    event.title,
    event.description,
    event.locationName,
    text.category(event.category),
  ].any((value) => value.toLowerCase().contains(normalized));
}

String _eventTargetId(EventItem event) {
  return '${event.category.name}-${event.point.latitude}-${event.point.longitude}';
}

OutgoingMessage? _workEventResponse(
  List<OutgoingMessage> messages,
  EventItem event,
) {
  final targetId = _eventTargetId(event);
  for (final message in messages) {
    if (message.kind == OutgoingMessageKind.workResponse.name &&
        message.targetId == targetId) {
      return message;
    }
  }
  return null;
}

OutgoingMessage? _localWorkEventResponse(
  List<OutgoingMessage> messages,
  LocalEvent event,
) {
  for (final message in messages) {
    if (message.kind == OutgoingMessageKind.workResponse.name &&
        message.targetId == event.id) {
      return message;
    }
  }
  return null;
}

OutgoingMessage _workEventResponseMessage(AppText text, EventItem event) {
  final now = DateTime.now();
  return OutgoingMessage(
    id: 'message-${now.microsecondsSinceEpoch}',
    kind: OutgoingMessageKind.workResponse.name,
    targetId: _eventTargetId(event),
    title: event.title(text),
    subtitle: event.locationName,
    body: text.pick(
      ru: 'Отклик отправлен на активный ивент работы',
      en: 'Response sent to an active work event',
      tr: 'Aktif iş etkinliğine başvuru gönderildi',
    ),
    createdAt: now,
  );
}

OutgoingMessage _localWorkEventResponseMessage(AppText text, LocalEvent event) {
  final now = DateTime.now();
  return OutgoingMessage(
    id: 'message-${now.microsecondsSinceEpoch}',
    kind: OutgoingMessageKind.workResponse.name,
    targetId: event.id,
    title: event.title,
    subtitle: event.locationName,
    body: text.pick(
      ru: 'Отклик отправлен на активный ивент работы',
      en: 'Response sent to an active work event',
      tr: 'Aktif iş etkinliğine başvuru gönderildi',
    ),
    createdAt: now,
  );
}

void _showStaticEventDetails(
  BuildContext context, {
  required AppText text,
  required EventItem event,
  required ValueChanged<OutgoingMessage> onOutgoingMessageAdded,
}) {
  _showQadamBottomSheet<void>(
    context,
    builder: (context) => EventDetailsSheet(
      text: text,
      title: event.title(text),
      description: event.description(text),
      category: event.category,
      locationName: event.locationName,
      point: event.point,
      onMessage: () => _sendEventMessage(
        context,
        text: text,
        targetId: 'static-${event.point.latitude}-${event.point.longitude}',
        title: event.title(text),
        subtitle: event.locationName,
        onOutgoingMessageAdded: onOutgoingMessageAdded,
      ),
    ),
  );
}

void _showLocalEventDetails(
  BuildContext context, {
  required AppText text,
  required LocalEvent event,
  required ValueChanged<LocalEvent> onEventUpdated,
  required ValueChanged<String> onEventDeleted,
  ValueChanged<OutgoingMessage>? onOutgoingMessageAdded,
}) {
  _showQadamBottomSheet<void>(
    context,
    builder: (sheetContext) => EventDetailsSheet(
      text: text,
      title: event.title,
      description: event.description,
      category: event.category,
      locationName: event.locationName,
      point: event.point,
      photoBase64: event.photoBase64,
      onMessage: onOutgoingMessageAdded == null
          ? null
          : () => _sendEventMessage(
              sheetContext,
              text: text,
              targetId: event.id,
              title: event.title,
              subtitle: event.locationName,
              onOutgoingMessageAdded: onOutgoingMessageAdded,
            ),
      onEdit: () {
        Navigator.pop(sheetContext);
        _editLocalEvent(
          context,
          text: text,
          event: event,
          onEventUpdated: onEventUpdated,
        );
      },
      onDelete: () async {
        Navigator.pop(sheetContext);
        await _deleteLocalEvent(
          context,
          text: text,
          event: event,
          onEventDeleted: onEventDeleted,
        );
      },
    ),
  );
}

Future<void> _editLocalEvent(
  BuildContext context, {
  required AppText text,
  required LocalEvent event,
  required ValueChanged<LocalEvent> onEventUpdated,
}) async {
  await _showQadamBottomSheet<void>(
    context,
    isScrollControlled: true,
    builder: (context) => LocalEventEditorSheet(
      text: text,
      event: event,
      onEventUpdated: onEventUpdated,
    ),
  );
}

Future<void> _deleteLocalEvent(
  BuildContext context, {
  required AppText text,
  required LocalEvent event,
  required ValueChanged<String> onEventDeleted,
}) async {
  final confirmed = await _confirmDelete(context, text);
  if (!confirmed || !context.mounted) return;
  onEventDeleted(event.id);
  _showSnack(context, text.eventDeleted);
}

Future<bool> _confirmDelete(BuildContext context, AppText text) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(text.delete),
          content: Text(
            text.pick(
              ru: 'Удалить это событие?',
              en: 'Delete this event?',
              tr: 'Bu etkinlik silinsin mi?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(text.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(text.delete),
            ),
          ],
        ),
      ) ??
      false;
}

void _sendEventMessage(
  BuildContext context, {
  required AppText text,
  required String targetId,
  required String title,
  required String subtitle,
  required ValueChanged<OutgoingMessage> onOutgoingMessageAdded,
}) {
  final now = DateTime.now();
  onOutgoingMessageAdded(
    OutgoingMessage(
      id: 'message-${now.microsecondsSinceEpoch}',
      kind: OutgoingMessageKind.eventContact.name,
      targetId: targetId,
      title: title,
      subtitle: subtitle,
      body: text.pick(
        ru: 'Хочу узнать подробнее об этом событии',
        en: 'I want to know more about this event',
        tr: 'Bu etkinlik hakkında daha fazla bilgi istiyorum',
      ),
      createdAt: now,
    ),
  );
  Navigator.pop(context);
  _showSnack(context, text.messageSent);
}

String _relativeTime(AppText text, DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) {
    return text.pick(ru: 'сейчас', en: 'now', tr: 'şimdi');
  }
  if (diff.inHours < 1) {
    return text.pick(
      ru: '${diff.inMinutes} мин.',
      en: '${diff.inMinutes}m',
      tr: '${diff.inMinutes} dk.',
    );
  }
  if (diff.inDays < 1) {
    return text.pick(
      ru: '${diff.inHours} ч.',
      en: '${diff.inHours}h',
      tr: '${diff.inHours} sa.',
    );
  }
  return text.pick(
    ru: '${diff.inDays} д.',
    en: '${diff.inDays}d',
    tr: '${diff.inDays} g.',
  );
}

Future<String?> _pickImageBase64(BuildContext context, AppText text) async {
  try {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      imageQuality: 82,
    );
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  } catch (_) {
    if (context.mounted) {
      _showSnack(
        context,
        text.pick(
          ru: 'Не удалось выбрать фото',
          en: 'Could not choose a photo',
          tr: 'Fotoğraf seçilemedi',
        ),
      );
    }
    return null;
  }
}

Future<void> _pickProfilePhoto(
  BuildContext context, {
  required AppText text,
  required UserProfile profile,
  required ValueChanged<UserProfile> onProfileChanged,
}) async {
  final photoBase64 = await _pickImageBase64(context, text);
  if (photoBase64 == null || !context.mounted) return;
  onProfileChanged(profile.copyWith(photoBase64: photoBase64));
  _showSnack(context, text.profileUpdated);
}

class EventDetailsSheet extends StatelessWidget {
  const EventDetailsSheet({
    super.key,
    required this.text,
    required this.title,
    required this.description,
    required this.category,
    required this.locationName,
    required this.point,
    this.photoBase64 = '',
    this.onMessage,
    this.onEdit,
    this.onDelete,
  });

  final AppText text;
  final String title;
  final String description;
  final EventCategory category;
  final String locationName;
  final LatLng point;
  final String photoBase64;
  final VoidCallback? onMessage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventPhotoHeader(photoBase64: photoBase64),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: category.color.withValues(alpha: 0.18),
                  child: Icon(Icons.location_on_rounded, color: category.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${text.category(category)} • $locationName',
                        style: const TextStyle(
                          color: _muted,
                          fontFamily: _jockeyOneFont,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: text.edit,
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: text.delete,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.explore_outlined, size: 18, color: _muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${point.latitude.toStringAsFixed(4)}, '
                    '${point.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: _muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (onMessage != null) ...[
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: onMessage,
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(text.writeMessage),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: _ink,
                  side: const BorderSide(color: _ink, width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LocalEventEditorSheet extends StatefulWidget {
  const LocalEventEditorSheet({
    super.key,
    required this.text,
    required this.event,
    required this.onEventUpdated,
  });

  final AppText text;
  final LocalEvent event;
  final ValueChanged<LocalEvent> onEventUpdated;

  @override
  State<LocalEventEditorSheet> createState() => _LocalEventEditorSheetState();
}

class _LocalEventEditorSheetState extends State<LocalEventEditorSheet> {
  late final TextEditingController _descriptionController;
  late EventCategory _category;
  late LocationOption _location;
  late String _photoBase64;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.event.description,
    );
    _category = widget.event.category;
    _location = _locationOptions.firstWhere(
      (location) => location.label == widget.event.locationName,
      orElse: () => LocationOption(
        label: widget.event.locationName,
        point: widget.event.point,
      ),
    );
    _photoBase64 = widget.event.photoBase64;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final selected = await _showQadamActionSheet<EventCategory>(
      context: context,
      title: widget.text.activityType,
      actions: [
        for (final category in EventCategory.values)
          QadamSheetAction(
            value: category,
            title: widget.text.category(category),
            icon: Icons.circle_rounded,
            iconColor: category.color,
            selected: category == _category,
          ),
      ],
    );
    if (selected != null) {
      setState(() => _category = selected);
    }
  }

  Future<void> _pickLocation() async {
    final selected = await _showQadamActionSheet<LocationOption>(
      context: context,
      title: widget.text.location,
      actions: [
        for (final location in _locationOptions)
          QadamSheetAction(
            value: location,
            title: location.label,
            subtitle:
                '${location.point.latitude.toStringAsFixed(4)}, '
                '${location.point.longitude.toStringAsFixed(4)}',
            icon: Icons.location_on_outlined,
            selected: location.label == _location.label,
          ),
      ],
    );
    if (selected != null) {
      setState(() => _location = selected);
    }
  }

  Future<void> _pickPhoto() async {
    final photoBase64 = await _pickImageBase64(context, widget.text);
    if (photoBase64 == null || !mounted) return;
    setState(() => _photoBase64 = photoBase64);
    _showSnack(context, widget.text.eventPhotoAdded);
  }

  void _save() {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      _showSnack(
        context,
        widget.text.pick(
          ru: 'Напишите описание события',
          en: 'Write an event description',
          tr: 'Etkinlik açıklaması yazın',
        ),
      );
      return;
    }
    final updated = widget.event.copyWith(
      title: description.split('\n').first,
      description: description,
      category: _category,
      locationName: _location.label,
      lat: _location.point.latitude,
      lng: _location.point.longitude,
      photoBase64: _photoBase64,
    );
    widget.onEventUpdated(updated);
    Navigator.pop(context);
    _showSnack(context, widget.text.eventUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(22, 0, 22, bottomInset + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text.edit,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            DashedUploadBox(
              photoBase64: _photoBase64,
              changeLabel: widget.text.changePhoto,
              onTap: _pickPhoto,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(
                fontFamily: 'Jaldi',
                fontWeight: FontWeight.w400,
              ),
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: widget.text.writeDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: CircleAvatar(backgroundColor: _category.color),
                  label: Text(widget.text.category(_category)),
                  onPressed: _pickCategory,
                ),
                ActionChip(
                  avatar: const Icon(Icons.location_on_outlined, size: 18),
                  label: Text(
                    _location.label,
                    style: const TextStyle(
                      fontFamily: 'Jaldi',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: _pickLocation,
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: _save, child: Text(widget.text.save)),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, required this.size});

  final UserProfile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (profile.photoBase64.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(profile.photoBase64));
      } catch (_) {
        image = null;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF082032),
        borderRadius: BorderRadius.circular(8),
        image: image == null
            ? null
            : DecorationImage(image: image, fit: BoxFit.cover),
      ),
      child: image == null
          ? const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white70,
                size: 76,
              ),
            )
          : null,
    );
  }
}

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({
    super.key,
    required this.text,
    required this.profile,
    required this.onProfileChanged,
  });

  final AppText text;
  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileChanged;

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _bioController;
  late final TextEditingController _cityController;
  late String _photoBase64;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _roleController = TextEditingController(text: widget.profile.role);
    _bioController = TextEditingController(text: widget.profile.bio);
    _cityController = TextEditingController(text: widget.profile.city);
    _photoBase64 = widget.profile.photoBase64;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final photoBase64 = await _pickImageBase64(context, widget.text);
    if (photoBase64 != null && mounted) {
      setState(() => _photoBase64 = photoBase64);
    }
  }

  void _save() {
    widget.onProfileChanged(
      widget.profile.copyWith(
        name: _nameController.text.trim().isEmpty
            ? widget.profile.name
            : _nameController.text.trim(),
        role: _roleController.text.trim().isEmpty
            ? widget.profile.role
            : _roleController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? widget.profile.bio
            : _bioController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? widget.profile.city
            : _cityController.text.trim(),
        photoBase64: _photoBase64,
      ),
    );
    Navigator.pop(context);
    _showSnack(context, widget.text.profileUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final previewProfile = widget.profile.copyWith(photoBase64: _photoBase64);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(22, 0, 22, bottomInset + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text.edit,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _changePhoto,
                child: Column(
                  children: [
                    ProfileAvatar(profile: previewProfile, size: 110),
                    const SizedBox(height: 8),
                    Text(
                      widget.text.changePhoto,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _ProfileInput(label: widget.text.name, controller: _nameController),
            _ProfileInput(label: widget.text.role, controller: _roleController),
            _ProfileInput(label: widget.text.city, controller: _cityController),
            _ProfileInput(
              label: widget.text.about,
              controller: _bioController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: Text(widget.text.save)),
          ],
        ),
      ),
    );
  }
}

class _ProfileInput extends StatelessWidget {
  const _ProfileInput({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: _jaldiFont,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: _jaldiFont,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

enum EventCategory { meetings, work, startups, events }

class CategoryItem {
  const CategoryItem({
    required this.category,
    required this.count,
    required this.color,
    this.accent,
    this.isDark = false,
  });

  final EventCategory category;
  final int count;
  final Color color;
  final Color? accent;
  final bool isDark;
}

class EventItem {
  const EventItem({
    required this.category,
    required this.point,
    required this.color,
    required this.locationName,
    required this.titleRu,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.descriptionTr,
  });

  final EventCategory category;
  final LatLng point;
  final Color color;
  final String locationName;
  final String titleRu;
  final String titleEn;
  final String titleTr;
  final String descriptionRu;
  final String descriptionEn;
  final String descriptionTr;

  String title(AppText text) =>
      text.pick(ru: titleRu, en: titleEn, tr: titleTr);

  String description(AppText text) {
    return text.pick(ru: descriptionRu, en: descriptionEn, tr: descriptionTr);
  }
}

class WorkRequest {
  const WorkRequest({
    required this.id,
    required this.company,
    required this.price,
    required this.shortDeadline,
    required this.titleRu,
    required this.titleEn,
    required this.titleTr,
  });

  final String id;
  final String company;
  final String price;
  final bool shortDeadline;
  final String titleRu;
  final String titleEn;
  final String titleTr;

  String title(AppText text) {
    return text.pick(ru: titleRu, en: titleEn, tr: titleTr);
  }
}

extension EventCategoryStyle on EventCategory {
  Color get color {
    switch (this) {
      case EventCategory.meetings:
        return const Color(0xFF757992);
      case EventCategory.work:
        return const Color(0xFFEE8B1A);
      case EventCategory.startups:
        return const Color(0xFFA41917);
      case EventCategory.events:
        return const Color(0xFF0E0F15);
    }
  }

  Color get foregroundColor {
    switch (this) {
      case EventCategory.meetings:
        return const Color(0xFFFFEACC);
      case EventCategory.work:
        return const Color(0xFF6B2424);
      case EventCategory.startups:
        return const Color(0xFFEDEB77);
      case EventCategory.events:
        return const Color(0xFFD55151);
    }
  }

  Color get accentColor {
    switch (this) {
      case EventCategory.meetings:
        return const Color(0xFFFFEACC);
      case EventCategory.work:
        return const Color(0xFF6B2424);
      case EventCategory.startups:
        return const Color(0xFFEDEB77);
      case EventCategory.events:
        return const Color(0xFFD55151);
    }
  }

  static EventCategory fromName(String? name) {
    return EventCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => EventCategory.events,
    );
  }
}

class LocationOption {
  const LocationOption({required this.label, required this.point});

  final String label;
  final LatLng point;
}

class LocalEvent {
  const LocalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.createdAt,
    this.photoBase64 = '',
  });

  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final String locationName;
  final double lat;
  final double lng;
  final DateTime createdAt;
  final String photoBase64;

  LatLng get point => LatLng(lat, lng);

  LocalEvent copyWith({
    String? title,
    String? description,
    EventCategory? category,
    String? locationName,
    double? lat,
    double? lng,
    String? photoBase64,
  }) {
    return LocalEvent(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt,
      photoBase64: photoBase64 ?? this.photoBase64,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'locationName': locationName,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt.toIso8601String(),
      'photoBase64': photoBase64,
    };
  }

  factory LocalEvent.fromJson(Map<String, Object?> json) {
    return LocalEvent(
      id:
          json['id'] as String? ??
          'event-${DateTime.now().microsecondsSinceEpoch}',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: EventCategoryStyle.fromName(json['category'] as String?),
      locationName: json['locationName'] as String? ?? 'Almaty',
      lat: (json['lat'] as num?)?.toDouble() ?? 43.238949,
      lng: (json['lng'] as num?)?.toDouble() ?? 76.889709,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      photoBase64: json['photoBase64'] as String? ?? '',
    );
  }
}

enum OutgoingMessageKind { workResponse, eventContact }

class OutgoingMessage {
  const OutgoingMessage({
    required this.id,
    required this.kind,
    required this.targetId,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String kind;
  final String targetId;
  final String title;
  final String subtitle;
  final String body;
  final DateTime createdAt;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'kind': kind,
      'targetId': targetId,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OutgoingMessage.fromJson(Map<String, Object?> json) {
    return OutgoingMessage(
      id:
          json['id'] as String? ??
          'message-${DateTime.now().microsecondsSinceEpoch}',
      kind: json['kind'] as String? ?? OutgoingMessageKind.eventContact.name,
      targetId: json['targetId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.role,
    required this.bio,
    required this.city,
    required this.photoBase64,
  });

  static const defaults = UserProfile(
    name: 'Zhantore Uspanov',
    role: 'UI Designer',
    bio: 'Создаю новые проекты\nи ищу команду',
    city: 'Bandirma',
    photoBase64: '',
  );

  final String name;
  final String role;
  final String bio;
  final String city;
  final String photoBase64;

  UserProfile copyWith({
    String? name,
    String? role,
    String? bio,
    String? city,
    String? photoBase64,
  }) {
    return UserProfile(
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      photoBase64: photoBase64 ?? this.photoBase64,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'role': role,
      'bio': bio,
      'city': city,
      'photoBase64': photoBase64,
    };
  }

  factory UserProfile.fromJson(Map<String, Object?> json) {
    return UserProfile(
      name: json['name'] as String? ?? defaults.name,
      role: json['role'] as String? ?? defaults.role,
      bio: json['bio'] as String? ?? defaults.bio,
      city: json['city'] as String? ?? defaults.city,
      photoBase64: json['photoBase64'] as String? ?? '',
    );
  }
}

class LocalAppData {
  const LocalAppData({
    required this.language,
    required this.events,
    required this.respondedRequestIds,
    required this.outgoingMessages,
    required this.profile,
  });

  final AppLanguage language;
  final List<LocalEvent> events;
  final Set<String> respondedRequestIds;
  final List<OutgoingMessage> outgoingMessages;
  final UserProfile profile;
}

class LocalDataStore {
  static const String _languageKey = 'qadam.language';
  static const String _eventsKey = 'qadam.localEvents';
  static const String _respondedKey = 'qadam.respondedRequestIds';
  static const String _outgoingMessagesKey = 'qadam.outgoingMessages';
  static const String _profileKey = 'qadam.profile';
  static const String _signedInEmailKey = 'qadam.signedInEmail';

  static Future<LocalAppData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final language = AppLanguage.values.firstWhere(
      (item) => item.name == prefs.getString(_languageKey),
      orElse: () => AppLanguage.ru,
    );
    final events = <LocalEvent>[];
    for (final raw in prefs.getStringList(_eventsKey) ?? const <String>[]) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          events.add(LocalEvent.fromJson(Map<String, Object?>.from(decoded)));
        }
      } catch (_) {
        // Ignore corrupted local demo records instead of blocking app startup.
      }
    }
    final respondedRequestIds = (prefs.getStringList(_respondedKey) ?? const [])
        .toSet();
    final outgoingMessages = <OutgoingMessage>[];
    for (final raw
        in prefs.getStringList(_outgoingMessagesKey) ?? const <String>[]) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          outgoingMessages.add(
            OutgoingMessage.fromJson(Map<String, Object?>.from(decoded)),
          );
        }
      } catch (_) {
        // Ignore corrupted local demo records instead of blocking app startup.
      }
    }
    var profile = UserProfile.defaults;
    final rawProfile = prefs.getString(_profileKey);
    if (rawProfile != null) {
      try {
        final decoded = jsonDecode(rawProfile);
        if (decoded is Map) {
          profile = UserProfile.fromJson(Map<String, Object?>.from(decoded));
        }
      } catch (_) {
        profile = UserProfile.defaults;
      }
    }

    return LocalAppData(
      language: language,
      events: events,
      respondedRequestIds: respondedRequestIds,
      outgoingMessages: outgoingMessages,
      profile: profile,
    );
  }

  static Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.name);
  }

  static Future<void> saveEvents(List<LocalEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _eventsKey,
      events.map((event) => jsonEncode(event.toJson())).toList(),
    );
  }

  static Future<void> saveRespondedRequestIds(Set<String> requestIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_respondedKey, requestIds.toList()..sort());
  }

  static Future<void> saveOutgoingMessages(
    List<OutgoingMessage> messages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _outgoingMessagesKey,
      messages.map((message) => jsonEncode(message.toJson())).toList(),
    );
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  static Future<String> loadSignedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_signedInEmailKey) ?? '';
  }

  static Future<void> saveSignedInEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_signedInEmailKey, email);
  }
}

const List<LocationOption> _locationOptions = [
  LocationOption(label: 'Cumhuriyet Meydanı', point: LatLng(40.3512, 27.9771)),
  LocationOption(
    label: 'Bandırma Sahil Parkı',
    point: LatLng(40.3558, 27.9680),
  ),
  LocationOption(label: 'Bandırma AVM', point: LatLng(40.3470, 27.9810)),
  LocationOption(label: 'Kuş Cenneti', point: LatLng(40.3620, 27.9900)),
];

const List<CategoryItem> _categories = [
  CategoryItem(
    category: EventCategory.meetings,
    count: 87,
    color: Color(0xFF757992),
    accent: Color(0xFFFFEACC),
    isDark: true,
  ),
  CategoryItem(
    category: EventCategory.work,
    count: 122,
    color: Color(0xFFEE8B1A),
    accent: Color(0xFF6B2424),
  ),
  CategoryItem(
    category: EventCategory.startups,
    count: 203,
    color: Color(0xFFA41917),
    accent: Color(0xFFEDEB77),
    isDark: true,
  ),
  CategoryItem(
    category: EventCategory.events,
    count: 12,
    color: Color(0xFF0E0F15),
    accent: Color(0xFFD55151),
    isDark: true,
  ),
];

const List<EventItem> _events = [
  EventItem(
    category: EventCategory.events,
    point: LatLng(40.3512, 27.9771),
    color: Color(0xFF1EA0E8),
    locationName: 'Cumhuriyet Meydanı',
    titleRu: 'Вечер дизайна',
    titleEn: 'Design evening',
    titleTr: 'Tasarım akşamı',
    descriptionRu:
        'Открытая встреча дизайнеров и основателей на главной площади.',
    descriptionEn: 'Open meetup for designers and founders at the main square.',
    descriptionTr: 'Ana meydanda tasarımcılar ve kurucular için açık buluşma.',
  ),
  EventItem(
    category: EventCategory.events,
    point: LatLng(40.3558, 27.9680),
    color: Color(0xFF1EA0E8),
    locationName: 'Bandırma Sahil Parkı',
    titleRu: 'Музыкальный вечер',
    titleEn: 'Music evening',
    titleTr: 'Müzik akşamı',
    descriptionRu:
        'Небольшой концерт у моря и знакомство с местными артистами.',
    descriptionEn:
        'A small seafront concert and a chance to meet local artists.',
    descriptionTr: 'Sahilde küçük konser ve yerel sanatçılarla tanışma.',
  ),
  EventItem(
    category: EventCategory.meetings,
    point: LatLng(40.3490, 27.9740),
    color: Color(0xFF22C55E),
    locationName: 'Bandırma Üniversitesi',
    titleRu: 'Прогулка и нетворкинг',
    titleEn: 'Walk and networking',
    titleTr: 'Yürüyüş ve networking',
    descriptionRu:
        'Спокойная встреча для новых знакомств и разговоров о проектах.',
    descriptionEn: 'A calm meetup for new contacts and project conversations.',
    descriptionTr:
        'Yeni bağlantılar ve proje sohbetleri için sakin bir buluşma.',
  ),
  EventItem(
    category: EventCategory.work,
    point: LatLng(40.3470, 27.9810),
    color: Color(0xFF1EA0E8),
    locationName: 'Bandırma AVM',
    titleRu: 'Съемка контента',
    titleEn: 'Content shoot',
    titleTr: 'İçerik çekimi',
    descriptionRu: 'Команде нужен человек для короткой съемки и монтажа.',
    descriptionEn: 'A team needs help with a short shoot and edit.',
    descriptionTr: 'Bir ekip kısa çekim ve kurgu için destek arıyor.',
  ),
  EventItem(
    category: EventCategory.startups,
    point: LatLng(40.3530, 27.9820),
    color: Color(0xFF1EA0E8),
    locationName: 'Bandırma Teknopark',
    titleRu: 'Питч стартапов',
    titleEn: 'Startup pitch',
    titleTr: 'Girişim sunumu',
    descriptionRu:
        'Основатели показывают идеи и ищут первых участников команды.',
    descriptionEn: 'Founders present ideas and look for first teammates.',
    descriptionTr:
        'Kurucular fikirlerini sunar ve ilk ekip arkadaşlarını arar.',
  ),
  EventItem(
    category: EventCategory.events,
    point: LatLng(40.3620, 27.9900),
    color: Color(0xFF1EA0E8),
    locationName: 'Kuş Cenneti',
    titleRu: 'Маркет выходного дня',
    titleEn: 'Weekend market',
    titleTr: 'Hafta sonu pazarı',
    descriptionRu: 'Локальные бренды, еда, музыка у птичьего заповедника.',
    descriptionEn: 'Local brands, food and music near the bird sanctuary.',
    descriptionTr: 'Kuş cenneti yakınında yerel markalar, yemek ve müzik.',
  ),
  EventItem(
    category: EventCategory.events,
    point: LatLng(40.3515, 27.9760),
    color: Color(0xFF07090E),
    locationName: 'Bandırma Kültür Merkezi',
    titleRu: 'Кино под открытым небом',
    titleEn: 'Open-air cinema',
    titleTr: 'Açık hava sineması',
    descriptionRu: 'Вечерний показ фильма и обсуждение после просмотра.',
    descriptionEn: 'Evening movie screening with a discussion afterwards.',
    descriptionTr: 'Akşam film gösterimi ve ardından sohbet.',
  ),
  EventItem(
    category: EventCategory.meetings,
    point: LatLng(40.3500, 27.9800),
    color: Color(0xFF85879E),
    locationName: 'Cumhuriyet Meydanı',
    titleRu: 'Встреча дизайнеров',
    titleEn: 'Designers meetup',
    titleTr: 'Tasarımcı buluşması',
    descriptionRu: 'Открытая встреча для дизайнеров, продактов и основателей.',
    descriptionEn: 'Open meetup for designers, product people and founders.',
    descriptionTr:
        'Tasarımcılar, ürün ekipleri ve kurucular için açık buluşma.',
  ),
  EventItem(
    category: EventCategory.meetings,
    point: LatLng(40.3545, 27.9700),
    color: Color(0xFF85879E),
    locationName: 'Bandırma Sahil Parkı',
    titleRu: 'Кофе с командой',
    titleEn: 'Coffee with a team',
    titleTr: 'Ekiple kahve',
    descriptionRu: 'Короткий формат знакомства с командами и фаундерами.',
    descriptionEn: 'A short format for meeting teams and founders.',
    descriptionTr: 'Ekipler ve kurucularla tanışmak için kısa format.',
  ),
  EventItem(
    category: EventCategory.meetings,
    point: LatLng(40.3480, 27.9750),
    color: Color(0xFF85879E),
    locationName: 'Bandırma Üniversitesi',
    titleRu: 'Вечерний разговор',
    titleEn: 'Evening talk',
    titleTr: 'Akşam sohbeti',
    descriptionRu: 'Неформальная встреча для тех, кто ищет единомышленников.',
    descriptionEn: 'Informal meetup for people looking for like-minded peers.',
    descriptionTr: 'Benzer düşünen insanları arayanlar için samimi buluşma.',
  ),
  EventItem(
    category: EventCategory.work,
    point: LatLng(40.3460, 27.9830),
    color: Color(0xFFFF8A05),
    locationName: 'Bandırma AVM',
    titleRu: 'Помощь на выставке',
    titleEn: 'Expo assistant',
    titleTr: 'Fuar desteği',
    descriptionRu: 'Нужен помощник на городской выставке на один день.',
    descriptionEn: 'One-day assistant needed for a city expo.',
    descriptionTr: 'Şehir fuarı için bir günlük destek gerekiyor.',
  ),
  EventItem(
    category: EventCategory.work,
    point: LatLng(40.3525, 27.9755),
    color: Color(0xFFFF8A05),
    locationName: 'Bandırma Kültür Merkezi',
    titleRu: 'Фото для афиши',
    titleEn: 'Poster photo shoot',
    titleTr: 'Afiş fotoğrafı',
    descriptionRu: 'Нужен фотограф для быстрой съемки афиши мероприятия.',
    descriptionEn: 'Photographer needed for a quick event poster shoot.',
    descriptionTr: 'Etkinlik afişi için hızlı fotoğraf çekimi gerekiyor.',
  ),
  EventItem(
    category: EventCategory.work,
    point: LatLng(40.3610, 27.9890),
    color: Color(0xFFFF8A05),
    locationName: 'Kuş Cenneti',
    titleRu: 'Промо команда',
    titleEn: 'Promo team',
    titleTr: 'Tanıtım ekibi',
    descriptionRu: 'Ищут людей для промо-активности у заповедника.',
    descriptionEn: 'People wanted for a promo activity near the sanctuary.',
    descriptionTr:
        'Doğa parkı yakınında tanıtım aktivitesi için ekip aranıyor.',
  ),
  EventItem(
    category: EventCategory.startups,
    point: LatLng(40.3540, 27.9815),
    color: Color(0xFFB81318),
    locationName: 'Bandırma Teknopark',
    titleRu: 'Идея за 60 минут',
    titleEn: 'Idea in 60 minutes',
    titleTr: '60 dakikada fikir',
    descriptionRu: 'Мини-хакатон для проверки новых продуктовых идей.',
    descriptionEn: 'Mini hackathon for testing new product ideas.',
    descriptionTr: 'Yeni ürün fikirlerini test etmek için mini hackathon.',
  ),
  EventItem(
    category: EventCategory.startups,
    point: LatLng(40.3495, 27.9790),
    color: Color(0xFFB81318),
    locationName: 'Bandırma Üniversitesi',
    titleRu: 'Поиск кофаундера',
    titleEn: 'Cofounder matching',
    titleTr: 'Kurucu ortak eşleşmesi',
    descriptionRu:
        'Встреча для тех, кто ищет технического или бизнес-партнера.',
    descriptionEn: 'Meet people looking for technical or business partners.',
    descriptionTr: 'Teknik veya iş ortağı arayanlar için buluşma.',
  ),
  EventItem(
    category: EventCategory.startups,
    point: LatLng(40.3520, 27.9840),
    color: Color(0xFFB81318),
    locationName: 'Bandırma Teknopark',
    titleRu: 'Demo day',
    titleEn: 'Demo day',
    titleTr: 'Demo günü',
    descriptionRu: 'Команды показывают прототипы и собирают обратную связь.',
    descriptionEn: 'Teams show prototypes and collect feedback.',
    descriptionTr: 'Ekipler prototiplerini gösterip geri bildirim toplar.',
  ),
];

const List<WorkRequest> _workRequests = [
  WorkRequest(
    id: 'video-business',
    company: 'MediaLab',
    price: '10 000₸',
    shortDeadline: false,
    titleRu: 'Съемка короткого видео для бизнеса',
    titleEn: 'Short video shoot for a business',
    titleTr: 'İşletme için kısa video çekimi',
  ),
  WorkRequest(
    id: 'video-background',
    company: 'Phone1',
    price: '2 000₸',
    shortDeadline: true,
    titleRu: 'Удалить фон с видео',
    titleEn: 'Remove background from a video',
    titleTr: 'Videodan arka planı kaldır',
  ),
];
