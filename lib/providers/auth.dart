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
    } catch (_) {
      rethrow;
    }
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

  void logout() {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
