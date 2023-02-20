import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  late UserCredential _userInfo;
  UserCredential get userInfo => _userInfo;

  String _verificationId = '';
  String get verificationId => _verificationId;

  int _authResult = -1;
  int get authResult => _authResult;

  initUserInfo(UserCredential credential) {
    _userInfo = credential;
    print('AuthProvider initUserInfo !! credential : $_userInfo');

    notifyListeners();
  }
  
  updateVerificationId(String id) {
    print('AuthProvider updateVerificationId !! id : $id');
    _verificationId = id;

    notifyListeners();
  }

  updateAuthResult(int result) {
    print('AuthProvider updateAuthResult !! result : $result');
    _authResult = result;

    notifyListeners();
  }
}