import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyRaisedButton extends StatelessWidget {
  MyRaisedButton(
      {@required this.onPressed,
      @required this.title,
      this.width,
      this.loading = false,
      this.textColor = Colors.brown,
      this.buttonColor = AppColors.primaryColor});

  final double width;
  final Function(BuildContext context) onPressed;
  final String title;
  final Color textColor;
  final Color buttonColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: MediaQuery.of(context).size.height / 13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: <BoxShadow>[
          BoxShadow(color: loading ? Colors.grey : buttonColor, blurRadius: 5)
        ],
      ),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        disabledColor: Colors.grey,
        disabledElevation: 0,
        animationDuration: Duration(seconds: 1),
        color: buttonColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        onPressed: loading
            ? null
            : () {
                onPressed(context);
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10.0,
            ),
            Visibility(
              visible: loading,
              child: SizedBox(
                  height: 20.0,
                  width: 100.0,
                  child: SpinKitThreeBounce(color: Colors.white)

                  // CircularProgressIndicator(
                  //   value: null,
                  //   strokeWidth: 2,
                  //   backgroundColor: Colors.white,
                  //   valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  // ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
