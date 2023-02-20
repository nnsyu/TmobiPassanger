import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:tmobi_passenger/providers/auth_provider.dart';
import 'package:tmobi_passenger/screens/login/widget/verify_code.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AUTH_NONE = 0;
  final AUTH_READY = 1;
  final AUTH_GOOGLE = 2;
  final AUTH_PHONE = 3;

  late int _authProcess;

  late AuthProvider _authProvider;

  @override
  void initState() {
    _authProcess = AUTH_NONE;
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/tmap_logo.png',
                  width: 80,
                  height: 80,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraint) {
                  if (_authProcess == AUTH_NONE) {
                    return Column(
                      children: [
                        SignInButton(
                          Buttons.GoogleDark,
                          text: 'Google 계정으로 로그인',
                          onPressed: SignInGoogle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: SignInPhone,
                          child: Container(
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    color: Colors.grey.shade100,
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.grey.shade900,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 11,
                                  ),
                                  Text(
                                    '전화번호로 로그인',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                    return CircularProgressIndicator();
                  } else if (_authProcess == AUTH_PHONE) {
                    return VerifyCode();
                  } else if (_authProcess == AUTH_GOOGLE) {
                    return CircularProgressIndicator();
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SignInGoogle() {
    print('SignInGoogle !!');
    _authProcess = AUTH_GOOGLE;
    setState(() {});
  }

  SignInPhone() async {
    print('SignInPhone !!');
    _authProcess = AUTH_PHONE;
    setState(() {});
  }
}
