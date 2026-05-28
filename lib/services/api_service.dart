import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUser {
  const MockUser({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MockUser.fromJson(Map<String, dynamic> json) {
    return MockUser(
      name: json['name']?.toString() ?? 'Usuario',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  MockUser copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return MockUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt,
    );
  }
}

class MockCheckIn {
  const MockCheckIn({
    required this.id,
    required this.createdAt,
    required this.mood,
    required this.status,
    required this.questions,
    required this.answers,
    required this.metrics,
  });

  final String id;
  final DateTime createdAt;
  final String mood;
  final String status;
  final List<String> questions;
  final List<String> answers;
  final Map<String, double> metrics;

  Color get color {
    if ((metrics['ansiedade'] ?? 0) >= 55) {
      return const Color(0xFFE8C3C5);
    }
    if ((metrics['cansaco'] ?? 0) >= 55) {
      return const Color(0xFFC6B2B2);
    }
    if ((metrics['sono'] ?? 0) >= 55) {
      return const Color(0xFFE7D1B7);
    }
    return const Color(0xFFECC7AF);
  }

  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    return '$day/$month/${createdAt.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'mood': mood,
      'status': status,
      'questions': questions,
      'answers': answers,
      'metrics': metrics,
    };
  }

  Map<String, dynamic> toLegacyMap() {
    return {
      'id': id,
      'data': formattedDate,
      'status': status,
      'cor': color,
      'humor': mood,
      'perguntas': questions,
      'respostas': answers,
      'dadosGrafico': metrics,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MockCheckIn.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'] as Map? ?? json['dadosGrafico'] as Map?;
    final metrics = <String, double>{};

    for (final entry in (rawMetrics ?? {}).entries) {
      metrics[entry.key.toString()] =
          double.tryParse(entry.value.toString()) ?? 0;
    }

    return MockCheckIn(
      id: json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      mood: json['mood']?.toString() ?? json['humor']?.toString() ?? 'Neutro',
      status: json['status']?.toString() ?? 'Humor estavel',
      questions:
          (json['questions'] as List? ?? json['perguntas'] as List? ?? const [])
              .map((item) => item.toString())
              .toList(),
      answers:
          (json['answers'] as List? ?? json['respostas'] as List? ?? const [])
              .map((item) => item.toString())
              .toList(),
      metrics: {
        'cansaco': metrics['cansaco'] ?? 0,
        'ansiedade': metrics['ansiedade'] ?? 0,
        'sono': metrics['sono'] ?? 0,
        'produtividade': metrics['produtividade'] ?? 0,
      },
    );
  }
}

class MockApiService {
  static const _usersKey = 'mock_users';
  static const _currentUserKey = 'currentUserEmail';
  static const _historyKey = 'mock_checkins';
  static const _nameKey = 'nomeUsuario';
  static const _emailKey = 'emailUsuario';
  static const _lastCheckInKey = 'ultimoQuestionario';
  static const _notificationsKey = 'notificacao';
  static const _darkThemeKey = 'temaEscuro';

  static Future<void> ensureSeedData() async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);

    if (users.isEmpty) {
      const email = 'demo@mindfulyou.com';
      final user = MockUser(
        name: 'Demo Mindful',
        email: email,
        password: '123456',
        createdAt: DateTime.now(),
      );

      users[email] = user;
      await _saveUsers(prefs, users);
    }
  }

  static Future<MockUser?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);

    if (email == null) {
      return null;
    }

    final users = await _loadUsers(prefs);
    return users[email.toLowerCase()];
  }

  static Future<MockUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final cleanedName = name.trim();
    final cleanedEmail = email.trim().toLowerCase();

    if (cleanedName.length < 2) {
      throw Exception('Informe seu nome completo.');
    }
    if (!_isValidEmail(cleanedEmail)) {
      throw Exception('Informe um email valido.');
    }
    if (password.length < 6) {
      throw Exception('A senha precisa ter pelo menos 6 caracteres.');
    }

    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);

    if (users.containsKey(cleanedEmail)) {
      throw Exception('Ja existe uma conta com este email.');
    }

    final user = MockUser(
      name: cleanedName,
      email: cleanedEmail,
      password: password,
      createdAt: DateTime.now(),
    );

    users[cleanedEmail] = user;
    await _saveUsers(prefs, users);
    await _setSession(prefs, user);

    return user;
  }

  static Future<MockUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final cleanedEmail = email.trim().toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);
    final user = users[cleanedEmail];

    if (user == null || user.password != password) {
      throw Exception('Email ou senha invalidos.');
    }

    await _setSession(prefs, user);
    return user;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final cleanedName = name.trim();
    final cleanedEmail = email.trim().toLowerCase();

    if (cleanedName.length < 2) {
      throw Exception('Informe um nome valido.');
    }
    if (!_isValidEmail(cleanedEmail)) {
      throw Exception('Informe um email valido.');
    }

    final prefs = await SharedPreferences.getInstance();
    final current = await currentUser();

    if (current == null) {
      throw Exception('Nenhum usuario logado.');
    }

    final users = await _loadUsers(prefs);
    final emailChanged = current.email.toLowerCase() != cleanedEmail;

    if (emailChanged && users.containsKey(cleanedEmail)) {
      throw Exception('Este email ja esta em uso.');
    }

    users.remove(current.email.toLowerCase());
    final updated = current.copyWith(name: cleanedName, email: cleanedEmail);
    users[cleanedEmail] = updated;

    await _saveUsers(prefs, users);
    await _setSession(prefs, updated);
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 6) {
      throw Exception('A nova senha precisa ter pelo menos 6 caracteres.');
    }

    final prefs = await SharedPreferences.getInstance();
    final current = await currentUser();

    if (current == null || current.password != currentPassword) {
      throw Exception('Senha atual incorreta.');
    }

    final users = await _loadUsers(prefs);
    users[current.email.toLowerCase()] =
        current.copyWith(password: newPassword);
    await _saveUsers(prefs, users);
  }

  static Future<void> savePreferences({
    required bool notifications,
    required bool darkTheme,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, notifications);
    await prefs.setBool(_darkThemeKey, darkTheme);
  }

  static Future<Map<String, bool>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'notifications': prefs.getBool(_notificationsKey) ?? true,
      'darkTheme': prefs.getBool(_darkThemeKey) ?? false,
    };
  }

  static Future<MockCheckIn> saveCheckIn({
    required String mood,
    required List<String> questions,
    required List<String> answers,
    required Map<String, double> metrics,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final checkIn = MockCheckIn(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      mood: mood,
      status: _buildStatus(metrics),
      questions: questions,
      answers: answers,
      metrics: metrics,
    );

    final history = await loadCheckIns();
    history.insert(0, checkIn);
    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(_lastCheckInKey, now.toIso8601String());

    return checkIn;
  }

  static Future<List<MockCheckIn>> loadCheckIns() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((item) => MockCheckIn.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<MockCheckIn?> lastCheckIn() async {
    final history = await loadCheckIns();
    return history.isEmpty ? null : history.first;
  }

  static Future<void> deleteCheckIn(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadCheckIns();
    history.removeWhere((item) => item.id == id);

    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((item) => item.toJson()).toList()),
    );

    if (history.isEmpty) {
      await prefs.remove(_lastCheckInKey);
    } else {
      await prefs.setString(
        _lastCheckInKey,
        history.first.createdAt.toIso8601String(),
      );
    }
  }

  static Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = await currentUser();

    if (current != null) {
      final users = await _loadUsers(prefs);
      users.remove(current.email.toLowerCase());
      await _saveUsers(prefs, users);
    }

    await prefs.remove(_currentUserKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_historyKey);
    await prefs.remove(_lastCheckInKey);
  }

  static Future<String?> requestPasswordReset(String email) async {
    final users = await _loadUsers(await SharedPreferences.getInstance());
    final user = users[email.trim().toLowerCase()];

    if (user == null) {
      return null;
    }

    return user.password;
  }

  static Future<Map<String, MockUser>> _loadUsers(
      SharedPreferences prefs) async {
    final raw = prefs.getString(_usersKey);

    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(
        key,
        MockUser.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  static Future<void> _saveUsers(
    SharedPreferences prefs,
    Map<String, MockUser> users,
  ) async {
    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((key, user) => MapEntry(key, user.toJson()))),
    );
  }

  static Future<void> _setSession(
    SharedPreferences prefs,
    MockUser user,
  ) async {
    await prefs.setString(_currentUserKey, user.email.toLowerCase());
    await prefs.setString(_nameKey, user.name);
    await prefs.setString(_emailKey, user.email);
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static String _buildStatus(Map<String, double> metrics) {
    final anxiety = metrics['ansiedade'] ?? 0;
    final tiredness = metrics['cansaco'] ?? 0;
    final sleep = metrics['sono'] ?? 0;
    final productivity = metrics['produtividade'] ?? 0;

    if (anxiety >= 65) {
      return 'Ansiedade elevada';
    }
    if (tiredness >= 65) {
      return 'Cansaco emocional';
    }
    if (sleep >= 65) {
      return 'Sono em atencao';
    }
    if (productivity >= 60) {
      return 'Boa estabilidade';
    }
    return 'Humor estavel';
  }
}
