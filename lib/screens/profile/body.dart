import 'dart:convert';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/widgets/profileheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:alfarasha/screens/home.dart';

class proInfo {
  //Constructor
  String username;
  String password;
  String phone;

  proInfo.fromJson(Map json) {
    username = json['username'];
    password = json['password'];
    phone    = json['phone'];
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String _username,_phone,_password;

  TextEditingController  username = new TextEditingController();
  TextEditingController  phone    = new TextEditingController();
  TextEditingController  password = new TextEditingController();

  Future editUserProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    try{
      var url = Uri.parse('http://192.168.43.66/alfarasha/profile/edit_user_profile.php');
      var response=await http.post(url, body: {
        'id'       : preferences.getString("id"),
        'username' : username.text,
      });
      json.decode(response.body);
    }catch(e){

    }
  }

  Future editPhoneProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    try{
      var url = Uri.parse('http://192.168.43.66/alfarasha/profile/edit_phone_profile.php');
      var response=await http.post(url, body: {
        'id'    : preferences.getString("id"),
        'phone' : phone.text,
      });
      json.decode(response.body);
    }catch(e){

    }
  }

  Future editPasswordProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    try{
      var url = Uri.parse('http://192.168.43.66/alfarasha/profile/edit_password_profile.php');
      var response=await http.post(url, body: {
        'id'       : preferences.getString("id"),
        'password' : password.text,
      });
      json.decode(response.body);
    }catch(e){

    }
  }

  Future deleteProfile() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://192.168.43.66/alfarasha/profile/delete_profile.php');
    http.post(url,body: {
      'id' : preferences.getString("id"),
    });
    setState(() {
      Fluttertoast.showToast(
          msg: "تم حذف الملف الشخصي",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        preferences.remove("value");
        preferences.remove("id");
        SystemNavigator.pop();
      });
    });
    SystemNavigator.pop();
  }

  SharedPreferences preferences;
  Future getProfile() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://192.168.43.66/alfarasha/profile/display_profile.php');
    var response = await http.post(url, body: {
      "id" : preferences.getString("id"),
    });
    var data = json.decode(response.body);
    setState(() {
      final items = (data['login'] as List).map((i) => new proInfo.fromJson(i));
      for (final item in items) {
        username.text = item.username;
        phone.text    = item.phone;
        password.text = item.password;

        _username = item.username;
        _phone    = item.phone;
        _password = item.password;
      }
    });

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
//    setState(() {
//      _username=username.text;
//      _phone=phone.text;
//      _password=password.text;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          painter: ProfileHeader(),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 20),
                        _username == null ?
                        Expanded(child: Text("Waiting...",style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ):
                        Expanded(child: Text(_username,style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ),
                        GestureDetector(
                            onTap:(){
                              nameDialog();
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 20),
                        _phone == null ?
                        Expanded(child: Text("Waiting...",style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ):
                        Expanded(child: Text(_phone,style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ),
                        GestureDetector(
                            onTap:(){
                              phoneDialog();
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 20),
                        _password == null ?
                        Expanded(child: Text("Waiting...",style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ):
                        Expanded(child: Text(_password,style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),)
                        ),
                        GestureDetector(
                            onTap:(){
                              passwordDialog();
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                ),
                elevation: 8,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.delete,size: 35,),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    myDialog();
                  },
                  label: Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15,right: 45,left: 45),
                    child: Text(
                      'حذف الحساب'.toUpperCase(),
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
            ],
          ),
        ),
      ],
    );
  }
  myDialog(){
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
                    Text("تحذير",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('هل تود حذف حسابك ؟',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),),
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
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                deleteProfile();
                              });
                            },
                            child: Text('موافق',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
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
    });
  }
  nameDialog(){
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
                    Text("قم بادخال أسمك",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Padding(
                      padding: const EdgeInsets.only(right: 15,left: 15),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.blue),
                            hintText: "أسم المستخدم"
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
                                if (username.text.isEmpty){
                                  Fluttertoast.showToast(
                                      msg: "الرجاء أدخال أسمك",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }else {
                                  editUserProfile();
                                  Fluttertoast.showToast(
                                      msg: "تم تعديل الملف الشخصي",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: yellowColor,
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                  Navigator.pushNamed(context, home.id);
                                  Navigator.of(context).pop();
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
                    Text("قم بادخال رقم الهاتف",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Padding(
                      padding: const EdgeInsets.only(right: 15,left: 15),
                      child: TextField(
                        controller: phone,
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.blue),
                            hintText: "رقم الهاتف"
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
                                if (phone.text.isEmpty){
                                  Fluttertoast.showToast(
                                      msg: "الرجاء أدخال رقم الهاتف",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }else {
                                  editPhoneProfile();
                                  Fluttertoast.showToast(
                                      msg: "تم تعديل الملف الشخصي",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: yellowColor,
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                  Navigator.pushNamed(context, home.id);
                                  Navigator.of(context).pop();
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
  passwordDialog(){
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
                    Text("قم بادخال كلمه السر",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Padding(
                      padding: const EdgeInsets.only(right: 15,left: 15),
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.blue),
                            hintText: "كلمه السر"
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
                                if (password.text.isEmpty){
                                  Fluttertoast.showToast(
                                      msg: "الرجاء أدخال كلمه المرور",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }else {
                                  editPasswordProfile();
                                  Fluttertoast.showToast(
                                      msg: "تم تعديل الملف الشخصي",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: yellowColor,
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                  Navigator.pushNamed(context, home.id);
                                  Navigator.of(context).pop();
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
