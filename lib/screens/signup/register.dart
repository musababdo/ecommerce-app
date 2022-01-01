import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/screens/myui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_otp/flutter_otp.dart';

class Register extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;

  TextEditingController _username = TextEditingController();
  TextEditingController _phone    = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController  myotp    = new TextEditingController();

  FlutterOtp otp = FlutterOtp();
  //String phoneNumber = "966252978"; //enter your 10 digit number
  int minNumber = 1000;
  int maxNumber = 6000;
  String countryCode ="+249";
  var rndnumber="";

  Generate(var number){
    var rnd= new Random();
    for (var i = 0; i < 6; i++) {
      number = number + rnd.nextInt(9).toString();
    }
  }
  
  Future register() async{
    //var url = Uri.parse('http://10.0.2.2/medicalcare/register.php');
    var url = Uri.parse('http://192.168.43.66/alfarasha/register.php');
    //var url = Uri.parse('https://medicalcareservices.000webhostapp.com/medicalcare/register.php');
    var response=await http.post(url, body: {
      "username" : _username.text.trim(),
      "password" : _password.text.trim(),
      "phone"    : _phone.text.trim(),
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  bool _validate = false;
  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String _errorMessage(String hint) {
    if(hint=="أسم المستخدم"){
      return 'الرجاء ادخال اسم المستخدم';
    }else if(hint=="رقم الهاتف"){
      return 'الرجاء ادخال رقم الهاتف';
    }else if(hint=="كلمه المرور"){
      return 'الرجاء ادخال كلمه المرور';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _username,
                inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                cursorColor: Colors.black,
                validator:(value) {
                  if (value.isEmpty) {
                    return _errorMessage("أسم المستخدم");
                    // ignore: missing_return
                  }
                },
                decoration: InputDecoration(
                  hintText: 'أسم المستخدم',
                  icon: Icon(Icons.person,color:Colors.black),
                  hintStyle: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: blueOpenColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                controller: _phone,
                keyboardType:TextInputType.number,
                inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                validator:(value) {
                  if (value.isEmpty) {
                    return _errorMessage("رقم الهاتف");
                    // ignore: missing_return
                  }
                },
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  icon: Icon(Icons.phone,color:Colors.black),
                  hintStyle: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: blueOpenColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: _secureText,
                cursorColor: Colors.black,
                controller: _password,
                validator:(value) {
                  if (value.isEmpty) {
                    return _errorMessage("كلمه المرور");
                    // ignore: missing_return
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(_secureText
                        ? Icons.visibility_off
                        : Icons.visibility,color:Colors.black),
                  ),
                  hintText: 'كلمه المرور',
                  icon: Icon(Icons.lock,color:Colors.black),
                  hintStyle: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: blueOpenColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),

            SizedBox(
              height: 24,
            ),

            GestureDetector(
              onTap:(){
                if (_state == 0) {
                  animateButton();
                }

                if (_globalKey.currentState.validate()){
                  _globalKey.currentState.save();
                  try{
                    otp.sendOtp(_phone.text.trim(),Generate(rndnumber),minNumber, maxNumber, countryCode);
                    phoneDialog();
                  }on PlatformException catch(e){

                  }
                }else{
                  setState(() {
                    _state = 0;
                  });
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF3D657).withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child:  Center(
                  child: setUpButtonChild(),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "أنشاء الحساب",
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: yellowColor,
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(yellowColor),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
  phoneDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("قم بادخال رقم الرقم التاكيدي",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Padding(
                      padding: const EdgeInsets.only(right: 15,left: 15),
                      child: TextField(
                        controller: myotp,
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "الرقم التاكيدي"
                        ),
                      ),
                    ),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('الغاء',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                if (myotp.text.isEmpty){
                                  Fluttertoast.showToast(
                                      msg: "الرجاء أدخال الرقم التاكيدي",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }else {
                                  register();
                                  _username.text='';
                                  _phone.text='';
                                  _password.text='';
                                  Fluttertoast.showToast(
                                      msg: "تم الحفظ بنجاح",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  Navigator.of(context).pop();
//                                  Navigator.pushNamed(context, Home.id).then((_){
//                                    Navigator.of(context).pop();
//                                  });
                                }
                              });
                            },
                            child: Text('حفظ',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    },
      isScrollControlled: true,
    );
  }
}