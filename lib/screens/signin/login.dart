import 'dart:async';
import 'dart:convert';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class DataInfo {
  //Constructor
  String id;
  String username;
  String phone;

  DataInfo.fromJson(Map json) {
    this.id       = json['id'];
    this.username = json['username'];
    this.phone    = json['phone'];
  }
}

class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future login() async {
    var url = Uri.parse('http://192.168.43.66/alfarasha/login.php');
    try {
      var response = await http.post(url, body: {
        "username": _username.text.trim(),
        "password": _password.text.trim(),
      });
      var data = json.decode(response.body);
        String success = data['success'];
        if (success == "1") {
          setState(() {
            final items = (data['login'] as List).map((i) => new DataInfo.fromJson(i));
            for (final item in items) {
              savePref(item.id);
            }
          });
          Navigator.pushNamed(context, home.id);
        } else {
          Fluttertoast.showToast(
              msg: "هنالك خطاء ما",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
    }catch(e){
      setState(() {
        _state = 0;
      });
      errorDialog();
    }
  }

  errorDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('اسم المستخدم او كلمه المرور خطاء',style: GoogleFonts.cairo(),),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا",style: GoogleFonts.cairo(),)
              ),
            ],
          );
        }
    );
  }

  savePref(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("id", id);
//      preferences.setString("username", username);
//      preferences.setString("phone", phone);
      preferences.commit();
    });
  }

  SharedPreferences preferences;
  saveValue(int value) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
    });
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
                controller: _username,
                inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                validator:(value) {
                  if (value.isEmpty) {
                    return _errorMessage("أسم المستخدم");
                    // ignore: missing_return
                  }
                },
                decoration: InputDecoration(
                  hintText: 'أسم المستخدم',
                  icon: Icon(Icons.person),
                  hintStyle: GoogleFonts.cairo(
                  textStyle: TextStyle(
                  fontSize: 16,
                    fontWeight: FontWeight.bold
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
                  fillColor: yellowOpenColor,
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
                controller: _password,
                obscureText: _secureText,
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
                        : Icons.visibility),
                  ),
                  errorText: _validate ? 'الرجاء ادخال كلمه المرور' : null,
                  hintText: 'كلمه المرور',
                  icon: Icon(Icons.lock),
                  hintStyle: GoogleFonts.cairo(
                  textStyle: TextStyle(
                  fontSize: 16,
                    fontWeight: FontWeight.bold
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
                  fillColor: yellowOpenColor,
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
                    saveValue(1);
                    login();
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
                  color: Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1C1C1C).withOpacity(0.2),
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
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "تسجيل دخول",
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
}