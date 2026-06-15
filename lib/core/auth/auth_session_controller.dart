import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservamobile/core/models/app_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionState {
  const AuthSessionState({required this.isLoading, required this.user});

  final bool isLoading;
  final AppUser? user;

  bool get isLoggedIn => user != null;

  AuthSessionState copyWith({
    bool? isLoading,
    AppUser? user,
    bool clearUser = false,
  }) {
    return AuthSessionState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
    );
  }
}

class AuthSessionController extends StateNotifier<AuthSessionState> {
  AuthSessionController()
    : super(const AuthSessionState(isLoading: true, user: null)) {
    initialize();
  }

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userRaw = prefs.getString(_userKey);
    if (userRaw == null || userRaw.isEmpty) {
      state = state.copyWith(isLoading: false, clearUser: true);
      return;
    }
    final map = jsonDecode(userRaw) as Map<String, dynamic>;
    final user = AppUser(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? 'Guest',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
    );
    state = state.copyWith(isLoading: false, user: user);
  }

  Future<void> login({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final user = AppUser(
      id: 'u-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
    );
    await _persistUser(prefs, user);
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final AppUser? current = state.user;
    if (current == null) return;
    final AppUser updated = current.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    final prefs = await SharedPreferences.getInstance();
    await _persistUser(prefs, updated);
    state = state.copyWith(user: updated);
  }

  Future<void> _persistUser(SharedPreferences prefs, AppUser user) async {
    await prefs.setString(
      _userKey,
      jsonEncode({
        'id': user.id,
        'fullName': user.fullName,
        'email': user.email,
        'phone': user.phone,
      }),
    );
    await prefs.setString(_tokenKey, 'mock-token-${user.id}');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    state = state.copyWith(clearUser: true, isLoading: false);
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionController, AuthSessionState>(
      (ref) => AuthSessionController(),
    );
