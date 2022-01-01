import 'dart:convert';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/provider/cartItem.dart';
import 'package:alfarasha/screens/personInfo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/customdialog.dart';

class confirm extends StatefulWidget {
  static String id='confirm';
  List<Product> products;
  @override
  _confirmState createState() => _confirmState();
}

class _confirmState extends State<confirm> {

  String username,phone,location,describe;
  int price,payment,_currentStep = 0;

  DateTime currentdate=new DateTime.now();
  String formatdate;
  final formatter = new NumberFormat("###,###");

  SharedPreferences preferences;
  Future getMydata() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      phone    = preferences.getString("phone") ;
      location = preferences.getString("location") ;
      describe = preferences.getString("describe") ;
      price    = preferences.getInt("price");
      if (payment == preferences.getInt("cash")){
        print("cash");
      } else if (payment == preferences.getInt("paypal")){
        print("paypal");
      }
    });
//    print(username);
//    print(phone);
//    print(price);
//    print(location);
//    print(describe);
  }

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    getMydata();
  }

  Future orderNow() async{
    var url = Uri.parse('http://10.0.2.2/alfarasha/save_order.php');
    var response=await http.post(url, body: {
      "name"         : username,
      "phone"        : phone,
      "location"     : location,
      "describe"     : describe,
      "product"      : widget.products.map((e) => jsonEncode(e.toJson())).toList().toString(),
      "price"        : price.toString(),
      "date"         : formatdate
    });
    json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    widget.products=Provider.of<CartItem>(context).products;
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop:(){
        Navigator.popAndPushNamed(context, PersonInfo.id);
        return Future.value(false);
      },
      child: SafeArea(
          child:Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(right: 15,left: 15,top: 20),
                child: Column(
                  children: [
                    Stepper(
                        steps: _mySteps(),
                        currentStep: this._currentStep,
                        onStepTapped: (step){
                          setState(() {
                            this._currentStep = step;
                          });
                         },
                         onStepContinue: (){
                          setState(() {
                           if(this._currentStep < this._mySteps().length -1){
                             this._currentStep = this._currentStep + 1;
                           }else{
                             this._currentStep = _currentStep;
                           }
                          });
                      },
                      onStepCancel: (){
                          setState(() {
                            if(this._currentStep > 0){
                              this._currentStep = this._currentStep - 1;
                            }else{
                              this._currentStep = 0;
                            }
                          });
                      },
                    ),
                    SizedBox(height: height * .05),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .08,
                        child: Builder(
                          builder: (context) => Card(
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
                                orderNow();
                                orderDialog();
                                Provider.of<CartItem>(context, listen: false).deleteAll();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15,bottom: 15,right: 35,left: 35),
                                child: Text(
                                  'تأكيد الطلب'.toUpperCase(),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
  List<Step> _mySteps(){
    List<Step> _steps=[
      Step(
          title: Text("معلومات حسابك",style: GoogleFonts.cairo(
            textStyle: TextStyle(
                fontSize: 22,
                color:Colors.black
            ),
          )),
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    username,
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                  ),
                  Text(
                    '  : أسم المستخدم',
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    phone,
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                  ),
                  Text(
                    '  : رقم الهاتف',
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          isActive: _currentStep >= 0,
      ),
      Step(
        title: Text("بيانات موقعك",style: GoogleFonts.cairo(
          textStyle: TextStyle(
              fontSize: 22,
              color:Colors.black
          ),
        )),
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  location,
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(
                  '  :  الموقع',
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  describe,
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(
                  '  :  معلم بارز',
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text("المبلغ الكلي",style: GoogleFonts.cairo(
          textStyle: TextStyle(
              fontSize: 22,
              color:Colors.black
          ),
        )),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'SDG ${formatter.format(int.parse(price.toString()))}',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),
              ),
            ),
            Text(
              '  :  المبلغ الكلي',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 20
                ),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text("طريقه الدفع",style: GoogleFonts.cairo(
          textStyle: TextStyle(
              fontSize: 22,
              color:Colors.black
          ),
        )),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'SDG ${formatter.format(int.parse(price.toString()))}',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),
              ),
            ),
            Text(
              '  :   طريقه الدفع',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 20
                ),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }
  orderDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog()
    );
  }
}
