import 'dart:convert';

import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/provider/cartItem.dart';
import 'package:alfarasha/screens/cartScreen.dart';
import 'package:alfarasha/screens/done.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alfarasha/widgets/customTextView.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:alfarasha/widgets/searchDialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonInfo extends StatefulWidget {
  static String id='personinf';
  List<Product> products;
  @override
  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String id;
  int price;

  DateTime currentdate=new DateTime.now();
  String formatdate;
  final formatter = new NumberFormat("###,###");

  TextEditingController _location   =new TextEditingController();
  TextEditingController _describe   =new TextEditingController();
  TextEditingController editingController=new TextEditingController();

  Future orderNow() async{
    var url = Uri.parse('http://192.168.43.66/alfarasha/save_order.php');
    var response=await http.post(url, body: {
      "user_id"      : id,
      "location"     : _location.text,
      "describe"     : _describe.text,
      "product"      : widget.products.map((e) => jsonEncode(e.toJson())).toList().toString(),
      "price"        : price.toString(),
      "date"         : formatdate
    });
    json.decode(response.body);
  }

  SharedPreferences preferences;
  Future getData() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      price    = preferences.getInt("price");
      id       = preferences.getString("id");
    });
  }

  int _radioValue = 0;

    _handleRadioValueChange(int value){
      setState(() {
      _radioValue = value;
      if (_radioValue == 0){
      }else if (_radioValue == 1){
      }
      print(_radioValue);
      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    widget.products=Provider.of<CartItem>(context).products;
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    return Form(
      key: _globalKey,
      child: WillPopScope(
        onWillPop:(){
          //Navigator.pushNamed(context, CartScreen.id);
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,top: 80),
              child: ListView(
                children: <Widget>[
                  Spacer(
                    flex: 5,
                  ),
                  Center(
                    child: Text(
                      'الرجاء ملء بياناتك وتكمله الطلب',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    myfun: (){
                      locationDialog();
                    },
                    controller: _location,
                    onClick: (value) {
                      _location = value;
                    },
                    hint: 'الموقع',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _describe,
                    onClick: (value) {
                      _describe = value;
                    },
                    hint: 'معلم بارز',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 20),
//                    Padding(
//                      padding: const EdgeInsets.only(right: 30),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.end,
//                        children: [
//                          Text(
//                              'أختر طريقه الدفع',
//                              style: GoogleFonts.cairo(
//                                textStyle: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 20,
//                                    fontWeight: FontWeight.bold
//                                ),
//                              )
//                          ),
//                        ],
//                      ),
//                    ),
//                    const SizedBox(height: 10),
//                    Padding(
//                      padding: const EdgeInsets.only(right: 30),
//                      child: Column(
//                        children: [
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            children: [
//                              new Radio(
//                                value: 0,
//                                groupValue: _radioValue,
//                                onChanged: _handleRadioValueChange,
//                              ),
//                              new Text(
//                                'كاش',
//                                style: GoogleFonts.cairo(
//                                  textStyle: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 20
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            children: [
//                              new Radio(
//                                value: 1,
//                                groupValue: _radioValue,
//                                onChanged: _handleRadioValueChange,
//                              ),
//                              new Text(
//                                'PayPal',
//                                style: GoogleFonts.cairo(
//                                  textStyle: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 20
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap:(){
//                        if (_globalKey.currentState.validate()){
//                          _globalKey.currentState.save();
//                          try{
//                            orderNow();
//                         widget.products.clear();
//                          Navigator.pushNamed(context, Done.id);
//                          }on PlatformException catch(e){
//
//                          }
//                        }
                      if(_location.text.isEmpty && _describe.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "الرجاء ملء بياناتك",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        orderNow();
                        widget.products.clear();
                        Navigator.pushNamed(context, Done.id);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
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
                          child: Text(
                            "أطلب الأن",
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF3D657),
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  locationDialog(){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("اختر عنوان السكن",style: GoogleFonts.cairo()),
            content:MyDialog(mlocation: _location,),
          );
        }
    );
  }
}



