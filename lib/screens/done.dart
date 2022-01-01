import 'package:alfarasha/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alfarasha/screens/home.dart';

class Done extends StatelessWidget {
  static String id = 'done';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(
                  flex: 5,
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: SvgPicture.asset("assets/icons/order_accepted_icon.svg")),
                //SvgPicture.asset("assets/icons/order_accepted_icon.svg"),
                Spacer(
                  flex: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "تم أرسال طلبك بنجاح",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                  ),
                  elevation: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: yellowColor,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, home.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15,bottom: 15,right: 35,left: 35),
                      child: Text(
                        'الرجوع للرئيسيه'.toUpperCase(),
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                  ),
                  elevation: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: blueColor,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15,bottom: 15,right: 35,left: 35),
                      child: Text(
                        'الخروج من التطبيق'.toUpperCase(),
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
