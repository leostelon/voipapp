import 'package:app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/raised_button.dart';

class SignUp extends StatefulWidget {
  final phone;
  SignUp({@required this.phone});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _usernameController =
      TextEditingController(text: "nethaji");
  var file;

  void _login(AuthProvider authProvider) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      print(_usernameController.value.text);
      var response = await authProvider.login(
        username: _usernameController.value.text,
        phone: this.widget.phone,
      );
      print(response["statusCode"]);
      if (response["statusCode"] == 201) {
        Navigator.pushReplacementNamed(context, 'home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
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
                "Setup your account",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              //Profile Picture
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/default-profile-icon.jpg'),
                    radius: 50,
                  )
                ],
              ),
              SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () async {
              //     // Uploading To Cloudaniry bucket
              //     file =
              //         await ImagePicker().getImage(source: ImageSource.gallery);
              //     if (file == null) return;
              //     List formats = ['jpg', 'jpeg', 'png'];
              //     if (!formats.contains(file.path.split(".").last)) return null;

              //     // String fileName = userProvider.user.id +
              //     //     DateTime.now().millisecond.toString() +
              //     //     "." +
              //     //     file.path.split(".").last;
              //     // var utf8 = await file.readAsBytes();
              //     // await userProvider.uploadImage(
              //     //   base64Encode(utf8),
              //     //   fileName,
              //     // );
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Change Image '),
              //       Icon(
              //         Icons.add_photo_alternate,
              //         size: 24,
              //         color: Colors.grey,
              //       ),
              //     ],
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: Container(
                    //  width: MediaQuery.of(context).size.width/2,
                    child: TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter UserName';
                        } else {
                          return null;
                        }
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: MyRaisedButton(
                  onPressed: (context) => _login(authProvider),
                  title: "Proceed",
                  buttonColor: AppColors.colorBlue,
                  textColor: AppColors.colorWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
