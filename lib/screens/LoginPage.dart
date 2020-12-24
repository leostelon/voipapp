import 'dart:async';

import 'package:app/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phonenocontroller = TextEditingController();
  final _otpcontroller = TextEditingController();
  bool otpVisibility = false;
  bool otpDetecting = false;
  bool isResend = false;
  String verificationId;
  int resendToken;
  int timer = 60;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> checkFirstSeen() async {
    String _token = await secureStorage.getToken();
    await Provider.of<AuthProvider>(context, listen: false).setToken();

    if (_token != null) {
      return Navigator.pushReplacementNamed(context, 'home');
    }
  }

  Future firebaseAuth(String phoneno) async {
    await auth.verifyPhoneNumber(
      forceResendingToken: resendToken,
      phoneNumber: "+91$phoneno",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, 'signup', arguments: phoneno);
        print('verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        print('verification failed');
      },
      codeSent: (String verificationId, int rToken) {
        setState(() {
          otpDetecting = !otpDetecting;
        });
        resendToken = rToken;
        print("code sent");
      },
      codeAutoRetrievalTimeout: (String vId) async {
        verificationId = vId;
        setState(() {
          otpDetecting = false;
          otpVisibility = true;
          timer = 60;
        });
        Timer.periodic(Duration(seconds: 1), (Timer t) {
          if (timer <= 0) {
            setState(() {
              isResend = !isResend;
            });
            return t.cancel();
          }
          setState(() {
            timer = timer - 1;
          });
        });
        print("Code autoretrieve failed");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 88.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.width / 2.8,
                  ),
                ),
              ),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please Sign-In to Continue",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 50.0),
                  child: Text(
                    "Phone Number".toUpperCase(),
                    style: TextStyle(
                      // color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: TextFormField(
                    enabled: !otpVisibility,
                    keyboardType: TextInputType.phone,
                    controller: _phonenocontroller,
                    validator: (value) {
                      if (value.length < 10) {
                        return 'Please Enter Valid Phone Number';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile no*',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              otpVisibility
                  ? AbsorbPointer(
                      absorbing: !isResend,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isResend = false;
                          });
                          await firebaseAuth(_phonenocontroller.value.text);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              const EdgeInsets.only(left: 28.0, bottom: 16.0),
                          child: Text(
                            "Resend($timer)",
                            style: TextStyle(
                              color: isResend ? Colors.blue : Colors.blue[200],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              otpVisibility
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          otpVisibility = !otpVisibility;
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            const EdgeInsets.only(left: 28.0, bottom: 16.0),
                        child: Text(
                          "Change Number",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              otpDetecting
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 28,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Auto Detecting OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CupertinoActivityIndicator(),
                        ],
                      ),
                    )
                  : otpVisibility
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter your OTP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  width: 200,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _otpcontroller,
                                    validator: (value) {
                                      if (value.length < 6) {
                                        return 'Please Enter Valid OTP';
                                      } else {
                                        return null;
                                      }
                                    },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Please enter the otp...',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    AuthCredential credential =
                                        PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _otpcontroller.value.text,
                                    );
                                    UserCredential result;
                                    try {
                                      result = await auth
                                          .signInWithCredential(credential);
                                      Navigator.pushReplacementNamed(
                                        context,
                                        'signuo',
                                        arguments:
                                            _phonenocontroller.value.text,
                                      );
                                    } catch (e) {
                                      return false;
                                    }
                                    print(result);
                                    if (result.user.uid != null) return true;
                                    return false;
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Verify",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: InkWell(
                  onTap: () async {
                    if (!otpVisibility && !otpDetecting) {
                      if (_formKey.currentState.validate()) {
                        print('Firebase otp sent');
                        await firebaseAuth(_phonenocontroller.value.text);
                      }
                    }
                  },
                  child: Card(
                    elevation: 20.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      radius: 35.0,
                      child: Image.asset("assets/larw.ico"),
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
