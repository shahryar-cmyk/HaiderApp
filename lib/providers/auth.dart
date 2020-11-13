import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmailAuth with ChangeNotifier {
  String _token;
  String _schoolName;
  String _message;
  bool _status;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      print(_token);
      return _token;
    }
    return null;
  }

  String get schoolName {
    return _schoolName;
  }

  String get schoolId {
    return _token;
  }

  Future<void> authethicate(
    String schoolName,
    String password,
  ) async {
    try {
      final url =
          'https://rpi.t4top.com/api/login.php?school_name=$schoolName&password=$password';
      final response = await http.post(
        url,
      );
      print(
        json.decode(response.body),
      );
      final responseData = json.decode(response.body);
      // if (responseData['message'] != null) {
      //   throw HttpException(responseData['message']);
      // }
      print('This is the Data response.$responseData');
      _token = responseData['Tekon'];
      print('This is the Token I am getting $_token');
      _schoolName = responseData['School_name'];
      _message = responseData['message'];
      _status = responseData['status'];

      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'schoolName': _schoolName,
        'message': _message,
        'status': _status,
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> signIn(String schoolName, String password) async {
  //   await authethicate(schoolName, password);
  // }

  Future<void> logOut() async {
    _schoolName = null;
    _token = null;
    _message = null;
    _status = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    print('Auto Login Runining');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print(_token);
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _schoolName = extractedUserData['schoolName'];
    _status = extractedUserData['status'];
    _message = extractedUserData['message'];
    notifyListeners();
    print(_token);
    return true;
  }

  Future<void> deleteMessages(
    String messageId,
    String userTokenId,
  ) async {
    try {
      final url =
          'https://rpi.t4top.com/api/deleted.php?sms_id=$messageId&school_name_id=$userTokenId';
      final response = await http.get(
        url,
      );
      print(
        json.decode(response.body),
      );
      final responseData = json.decode(response.body);
      print('The message is deleted : $responseData');
    } catch (error) {
      throw (error);
    }
  }
}
