import 'dart:convert';
import 'package:alfarasha/constants.dart';
import 'package:alfarasha/models/order.dart';
import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/screens/myorder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  static String id='orderdetails';

  final List list;
  final int index;
  OrderDetails({this.list,this.index});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  String location,marklocation,price,id,date,name,quantity;
  List product=[];
  List<Order> orderList=[];
  var data,image;
  final formatter = new NumberFormat("###,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location     = widget.list[widget.index]['location'];
    marklocation = widget.list[widget.index]['mydescribe'];
    price        = widget.list[widget.index]['price'];
    date         = widget.list[widget.index]['time'];
    //product.add(widget.list[widget.index]['product']);
    //widget.list[widget.index]['product']=product.map((e) => jsonEncode(e.toJson())).toList().toString();
    //print(widget.list[widget.index]['product']);
    //print(product.length);
    data = json.decode(widget.list[widget.index]['products']);
    product = data.map((j) => Product.fromJson(j)).toList();
    for (final item in product) {
      orderList.add(Order(item.id, item.name, item.image, item.quantity));
      //id = item.id;
      //name = item.name;
      //image=item.image;
      //quantity=item.quantity.toString();
    }
    /*final items = (data as List).map((i) => new Product.fromJson(i));
              for (final item in items) {
                id = item.id;
                name = item.name;
                image=item.image;
                quantity=item.quantity.toString();
                print(item.id);
              }*/
    //print(product.length);
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: yellowColor,
            elevation: 0,
            title: Text(
              'تفاصيل الطلب',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                  color:Colors.black,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                //Navigator.pop(context);
                Navigator.popAndPushNamed(context, MyOrder.id);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'SDG ${formatter.format(int.parse(price.toString()))}',
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
                  Text(
                    date,
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color:Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'السله',
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 20,
                          color:Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: screenHeight * .15,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 8,
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      bottomLeft: const Radius.circular(20),
                                    ),
                                    child:FadeInImage.assetNetwork(
                                      image: orderList[index].image,
                                      placeholder: 'assets/images/loader.gif',
                                      width: MediaQuery.of(context).size.width / 3,
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/loader.gif',
                                            fit: BoxFit.contain);
                                      },
                                      fit: BoxFit.contain,
                                    ),
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
                                                (orderList[index].name),
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      color:Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                ('${orderList[index].quantity.toString()}  :  الكميه'),
                                                style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      color:Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //color: kSecondaryColor,
                          ),
                        );
                      },
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
  placeImage(){
    return Image.asset("assets/images/place.png",
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.contain,
    );
  }
}