import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/raised_button.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Profile extends StatefulWidget {
  final phoneNumber;

  Profile({this.phoneNumber});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _login(context) async {
      if (_formkey.currentState.validate()) {
        _formkey.currentState.save();
      }
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Complete Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 88.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[300],
                    child: Center(
                        child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 40.0,
                    )),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                "Upload Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 18.0, left: 24.0, right: 24.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter UserName';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "UserName",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 18.0, left: 24.0, right: 24.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter UserName';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Email-Id",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 18.0, left: 24.0, right: 24.0),
              child: TextFormField(
                validator: Validators.compose([
                  Validators.required('Password is required'),
                  Validators.patternString(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                      'Invalid Password\n Example Password: Test@123')
                ]),
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: MyRaisedButton(
                onPressed: _login,
                title: "Continue",
                buttonColor: AppColors.colorBlue,
                textColor: AppColors.colorWhite,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
