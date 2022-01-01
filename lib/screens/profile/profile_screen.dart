import 'package:alfarasha/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alfarasha/screens/profile/body.dart';
import 'package:alfarasha/screens/home.dart';

class ProfileScreen extends StatelessWidget {
  static String id = "profile";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.pushNamed(context, home.id);
        return Future.value(false);
      },
      child: WillPopScope(
        onWillPop:(){
          Navigator.popAndPushNamed(context, home.id);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: yellowColor,
              elevation: 0,
              title: Text(
                'الصفحه الشخصيه',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, home.id);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: Body(),
          ),
        ),
      ),
    );
  }
}
