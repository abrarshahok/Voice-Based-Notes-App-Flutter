import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class Auth with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_token != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate({
    required String email,
    required String password,
    required String operation,
  }) async {
    const apiKey = 'AIzaSyDNVXhhz0mi6sq_j-s39ODD_fg3IiD3hLs';
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$operation?key=$apiKey';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      email: email,
      password: password,
      operation: 'signUp',
    );
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      email: email,
      password: password,
      operation: 'signInWithPassword',
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    final toBeExpiredDate = DateTime.parse(userData['expiryDate']);
    if (toBeExpiredDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = toBeExpiredDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
