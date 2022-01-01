import 'dart:convert';
import 'package:alfarasha/screens/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:alfarasha/screens/home.dart';
import '../constants.dart';

class MyOrder extends StatefulWidget {
  static String id = 'myorder';
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  final formatter = new NumberFormat("###,###");

  String id;

  Future cancelOrder(String id,String status) async{
    var url = Uri.parse('http://192.168.43.66/alfarasha/cancel_order.php');
    var response=await http.post(url, body: {
      "id"         : id,
      "status"     : status,
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  SharedPreferences preferences;
  Future getOrder() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://192.168.43.66/alfarasha/display_order.php');
    var response = await http.post(url, body: {
      "id": preferences.getString("id"),
    });
    var data = json.decode(response.body);

    return data;
  }

  Stream orders() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds : 1));
      yield await getOrder();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: yellowColor,
          elevation: 0,
          title: Text(
            'طلباتي',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                color: Colors.black,
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
        body: StreamBuilder(
          stream: orders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            try {
              if(snapshot.data.length > 0 ){
                return snapshot.hasData ?
                ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      id = list[index]['id'];
                      //print(list);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            elevation: 8,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment:MainAxisAlignment.center ,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'SDG ${formatter.format(int.parse(list[index]['price']))}',
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              color:Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '  : السعر',
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              color:Colors.black,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                       GestureDetector(
                                          onTap:(){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(list: list,index: index,),),);                                      },
                                          child: Text(
                                            'تفاصيل الطلب',
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                fontSize: 18,
                                                color:blueColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Text(
                                        list[index]['time'],
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            color:Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  ButtonTheme(
                                    minWidth: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * .08,
                                    child: Builder(
                                      builder: (context) => Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32)
                                        ),
                                        elevation: 8,
                                        child: ElevatedButton.icon(
                                          icon: Icon(Icons.cancel,color: Colors.black,size: 35,),
                                          style: ElevatedButton.styleFrom(
                                            primary: yellowColor,
                                            onPrimary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(32.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            cancelDialog();
                                          },
                                          label: Padding(
                                            padding: const EdgeInsets.only(top: 8,bottom: 8,right: 35,left: 35),
                                            child: Text(
                                              'الغاء الطلب',
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
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
                        ),
                      );
                    })
                    : new Center(
                  child: new CircularProgressIndicator(),
                );
              }else{
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('لايوجد طلبات',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                );
              }
            }catch(e){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
  cancelDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("تنبيه",style: GoogleFonts.cairo(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),),
            content: Text('هل تود الغاء طلبا نهائيا ',style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 18,
              ),
            ),),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("لا",style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),)
              ),
              FlatButton(
                  onPressed: (){
                    cancelOrder(id, "1");
                    Fluttertoast.showToast(
                        msg: "تم الغاء طلبك",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("نعم",style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),)
              ),
            ],
          );
        }
    );
  }
}