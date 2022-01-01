
import 'package:alfarasha/constants.dart';
import 'package:alfarasha/screens/cartScreen.dart';
import 'package:alfarasha/screens/signin/login_option.dart';
import 'package:alfarasha/screens/signin/login.dart';
import 'package:alfarasha/screens/signup/register.dart';
import 'package:alfarasha/screens/signup/register_option.dart';
import 'package:flutter/material.dart';

class myui extends StatefulWidget {
  static String id = 'myui';
  @override
  _myuiState createState() => _myuiState();
}

class _myuiState extends State<myui> {

  bool login = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          //Navigator.popAndPushNamed(context, CartScreen.id);
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: blueColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  onTap: () {
                    setState(() {
                      login = true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    height: login ? MediaQuery.of(context).size.height * 0.6 : MediaQuery.of(context).size.height * 0.4,
                    child: CustomPaint(
                      painter: CurvePainter(login),
                      child: Container(
                        padding: EdgeInsets.only(bottom: login ? 0 : 55),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              child: login
                                  ? Login()
                                  : LoginOption(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      login = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    height: login ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.6,
                    child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: login ? 55 : 0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              child: !login
                                  ? Register()
                                  : RegisterOption(),
                            ),
                          ),
                        )
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {

  bool outterCurve;

  CurvePainter(this.outterCurve);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = yellowColor;
    paint.style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, outterCurve ? size.height + 110 : size.height - 110, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}