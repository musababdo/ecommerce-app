
import 'dart:convert';

import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/screens/myui.dart';
import 'package:alfarasha/screens/personInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alfarasha/constants.dart';
import 'package:intl/intl.dart';
import 'package:alfarasha/provider/cartItem.dart';

class CartScreen extends StatefulWidget {
  static String id='cartScreen';
  List<Product> products;
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  String name,phone;
  int price,value;
  DateTime currentdate=new DateTime.now();
  String formatdate;
  final formatter = new NumberFormat("###,###");

  SharedPreferences preferences;
  Future getValue() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, PersonInfo.id);
      }else{
        myDialog();
      }
    });
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
                    Text("تنبيه",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('ليس لديك حساب قم بعمل حساب الأن ',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
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
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushNamed(context, myui.id).then((_){
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                            child: Text('موافق',
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
    });
  }

  Future getData() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString("name");
      phone=preferences.getString("phone") ;
      price=preferences.getInt("price");
    });
  }

  saveData(int price ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("price", price);
      preferences.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    widget.products=Provider.of<CartItem>(context).products;
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: yellowColor,
          elevation: 0,
          title: Text(
            'السله',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                color:Colors.black
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete,
                color: Colors.black,
              ),
              onPressed: (){
                deleteDialog();
              },
            )
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        persistentFooterButtons: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('SDG ${formatter.format(getTotallPrice(widget.products))}',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Text('المبلغ الكلي',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) => ButtonTheme(
              minWidth: screenWidth,
              height: screenHeight * .08,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                onPressed: () {
                  if(widget.products.map((e) => jsonEncode(e.toJson())).toList().isEmpty){
                    Fluttertoast.showToast(
                        msg: "عذرا,السله فارغه",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else {
                    getValue();
                    //widget.products.clear();
                  }
                },
                child: Text('اطلب',
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                color: yellowColor,
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              LayoutBuilder(builder: (context, constrains) {
                if (widget.products.isNotEmpty) {
                  return Container(
                    height: screenHeight -
                        statusBarHeight -
                        appBarHeight -
                        (screenHeight * .08),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        /*for(var i = 0; i < products.length; i++){
                              mylist.add(products[i]);
                            }
                            print(mylist.length);*/
                        saveData(getTotallPrice(widget.products));
                        return Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 10,right: 0,left:0),
                          child: SafeArea(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 8,
                              child: Container(
                                height: screenHeight * .17,
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        bottomLeft: const Radius.circular(20),
                                      ),
                                      child:Image.network(widget.products[index].image),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  widget.products[index].name,
                                                  style: GoogleFonts.cairo(
                                                    textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:1,
                                                ),
                                                Text(
                                                  'SDG ${formatter.format(int.parse(widget.products[index].price))}',
                                                  style: GoogleFonts.cairo(
                                                    textStyle: TextStyle(
                                                      fontWeight:FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    ClipOval(
                                                      child: Material(
                                                        color: yellowColor,
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              widget.products[index].quantity++;
                                                            });
                                                          },
                                                          child: SizedBox(
                                                            child: Icon(Icons.add),
                                                            height: 32,
                                                            width: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.products[index].quantity.toString(),
                                                      style: TextStyle(fontSize: 30),
                                                    ),
                                                    ClipOval(
                                                      child: Material(
                                                        color: yellowColor,
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              if (widget.products[index].quantity > 1) {
                                                                widget.products[index].quantity--;
                                                              }
                                                            });
                                                          },
                                                          child: SizedBox(
                                                            child: Icon(Icons.remove),
                                                            height: 32,
                                                            width: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(bottom:85),
                                              child: GestureDetector(
                                                  onTap: (){
                                                    Provider.of<CartItem>(context, listen: false)
                                                        .deleteProduct(widget.products[index]);
                                                  },
                                                  child: Icon((Icons.cancel)
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                //color: kSecondaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.products.length,
                    ),
                  );
                } else {
                  return Container(
                    height: screenHeight -
                        (screenHeight * .08) -
                        appBarHeight -
                        statusBarHeight,
                    child: Center(
                      child: Text('السله فارغه',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              ),
            ],
          ),
        ),

      ),
    );
  }
//  deleteDialog(){
//    showDialog(context: context,
//        builder: (context){
//          return AlertDialog(
//            title: Text("تنبيه",style: GoogleFonts.cairo(),),
//            content: Text('هل تود حذف السله نهائيا ',style: GoogleFonts.cairo(),),
//            actions: <Widget>[
//              TextButton(
//                  onPressed: (){
//                    Navigator.of(context).pop();
//                  },
//                  child: Text("لا",style: GoogleFonts.cairo(),)
//              ),
//              TextButton(
//                  onPressed: (){
//                    Provider.of<CartItem>(context, listen: false).deleteAll();
//                    Navigator.of(context).pop();
//                  },
//                  child: Text("نعم",style: GoogleFonts.cairo(),)
//              ),
//            ],
//          );
//        }
//    );
//  }

  deleteDialog(){
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
                    Text("تنبيه",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('هل تود حذف السله نهائيا',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
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
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                 Provider.of<CartItem>(context, listen: false).deleteAll();
                                  Navigator.of(context).pop();
                                });
                            },
                            child: Text('موافق',
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
    });
  }

getTotallPrice(List<Product> products) {
  var price = 0;
  for (var product in products) {
    price += product.quantity * int.parse(product.price);
  }
  return price;
}
}
