import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmobi_passenger/providers/auth_provider.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({Key? key}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  late AuthProvider _authProvider;
  late TextEditingController numberController;
  late TextEditingController codeController;

  int _authProcess = -1;

  @override
  void initState() {
    numberController = TextEditingController();
    codeController = TextEditingController();
  }

  @override
  void dispose() {
    numberController.dispose();
    codeController.dispose();
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '전화번호',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: TextFormField(
              style: TextStyle(
                color: _authProcess == -1 || _authProcess == 2 ? Colors.black : Colors.grey.shade500,
              ),
              enabled: _authProcess == -1 || _authProcess == 2,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: numberController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if(_authProcess == 2)
            Text(
              '올바른 전화번호를 입력해 주세요.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          SizedBox(
            height: 20,
          ),
          LayoutBuilder(
            builder: (context, c) {
              if (_authProcess == -1 || _authProcess == 2) {
                return Container();
              } else {
                return Column(
                  children: [
                    Text(
                      '인증번호',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: codeController,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          LayoutBuilder(
            builder: (context, c) {
              if (_authProvider.authResult == 0) {
                return Text(
                  '인증 실패',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 10,
                  ),
                );
              } else if (_authProvider.authResult == 1) {
                return Text(
                  '인증 성공',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 10,
                  ),
                );
              } else if (_authProvider.authResult == 2) {
                return Text(
                  '문자가 오지 않는 경우 재전송 요청하세요',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 10,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  if(numberController.text.length == 11) {
                    _authProcess = 1;
                    authPhone(numberController.text);
                  } else {
                    _authProcess = 2;
                  }
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  child: Text(_authProcess == 1 ? '인증번호 재발송' : '인증번호 발송'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  print('인증번호 확인 버튼 클릭 !!');
                  verifyCode(codeController.text);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  child: Text('인증번호 확인'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '인증번호가 오지 않는 경우 스팸 수신함을 확인하거나 국제번호 발신번호 제한을 해제해 주세요.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  authPhone(String number) async {
    String start = number.substring(0, 3);
    String middle = number.substring(3, 7);
    String end = number.substring(7, 11);

    print('+82 $start $middle $end');

    await FirebaseAuth.instance.verifyPhoneNumber(
      // phoneNumber: '+82 $start $middle $end',
      phoneNumber: '+82 010 1234 5678',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('authResult : verificationCompleted !!');

        _authProvider.updateAuthResult(1);

        // Sign the user in (or link) with the auto-generated credential
        // await FirebaseAuth.instance.signInWithCredential(credential);
        // _authProcess = AUTH_NONE;
        setState(() {});
      },
      verificationFailed: (FirebaseAuthException e) {
        print('authResult : verificationFailed !!');

        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          _authProvider.updateAuthResult(0);
        }

        // Handle other errors
        // _authProcess = AUTH_NONE;
        setState(() {});
      },
      codeSent: (String verificationId, int? resendToken) {
        print('authResult : codeSent');
        print('authResult : verificationId : $verificationId, resendToken : $resendToken');

        _authProvider.updateVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('authResult : codeAutoRetrievalTimeout');
        // _authProcess = AUTH_NONE;
        _authProvider.updateAuthResult(2);
        setState(() {});
      },
    );
  }

  verifyCode(String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _authProvider.verificationId, smsCode: code);

    UserCredential userInfo =
        await FirebaseAuth.instance.signInWithCredential(credential);
    _authProvider.initUserInfo(userInfo);
  }
}
