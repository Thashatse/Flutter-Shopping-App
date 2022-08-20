import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//Static Consts
import '../consts/system_consts.dart';
//models
import '../models/Exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token = null;
  DateTime? _expieryDate = null;
  String? _userId = null;
  String? _userName = null;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null && _expieryDate != null) {
      if (_token!.isNotEmpty && _expieryDate!.isAfter(DateTime.now())) {
        return _token;
      }
    }
    return null;
  }

  String? get userID {
    if (isAuth) {
      return _userId;
    }
    return null;
  }

  String? get userName {
    if (isAuth) {
      return _userName;
    }
    return null;
  }

  Future<void> _authenticate(String call, String email, String password) async {
    Uri uri = Uri.parse(
        '${SystemConsts_Fierbase.authBaseURL}:${call}?key=${SystemConsts_Fierbase.WebApiKey}');
    try {
      return await http
          .post(
        uri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      )
          .then(
        (response) async {
          final responseData = json.decode(response.body);
          if (response.statusCode == 400) {
            if (responseData['error'] != null) {
              var error = responseData['error']['message'] as String;

              if (error.contains('EMAIL_EXISTS')) {
                error = 'The email provided already exists';
              } else if (error.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
                error = 'Maximum attempts exceeded. Please try again later.';
              } else if (error.contains('EMAIL_NOT_FOUND')) {
                error = 'The email provided could not be found';
              } else if (error.contains('INVALID_PASSWORD')) {
                error = 'Password invalid';
              } else if (error.contains('USER_DISABLED')) {
                error =
                    'This user account has been disabled by the administrator ';
              } else {
                error = 'please try again latter';
              }

              throw HTTPException(
                message: error,
              );
            }
          } else if (response.statusCode == 200) {
            _token = responseData['idToken'];
            _userId = responseData['localId'];
            var expiresIn = int.parse(responseData['expiresIn']);
            _expieryDate = DateTime.now().add(Duration(seconds: expiresIn));
            _userName = email.toLowerCase();

            _autoLogout();
            notifyListeners();

            //Store User Data Localy
            final prefs = await SharedPreferences.getInstance();
            final userData = json.encode({
              'token': _token,
              'userId': _userId,
              'expieryDate': _expieryDate!.toIso8601String(),
              'userName': _userName,
            });
            prefs.setString('userData', userData);

            return Future<void>.value();
          } else {
            throw Exception('Server did not return an ok respons');
          }
        },
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(SystemConsts_Fierbase.signUp, email, password);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(SystemConsts_Fierbase.signIn, email, password);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      final expieryDate = DateTime.parse(extractedUserData['expieryDate']);
      if (expieryDate.isBefore(DateTime.now())) return false;

      _userId = extractedUserData['userId'] as String;
      _token = extractedUserData['token'] as String;
      _userName = extractedUserData['userName'] as String;
      _expieryDate = expieryDate;

      _autoLogout();
      notifyListeners();

      return true;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expieryDate = null;

    notifyListeners();

    cancelAuthTime();

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
    }
  }

  void _autoLogout() {
    cancelAuthTime();

    final timeToExpiry =
        _expieryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  void cancelAuthTime() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
  }
}
