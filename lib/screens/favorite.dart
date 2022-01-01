import 'dart:convert';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Favorite extends StatefulWidget {
  static String id = 'favorite';
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  String id,name;
  final formatter = new NumberFormat("###,###");
  int _quantity = 1;
  List<Product> myproducts = [];

  Future editFavorite(String id,String isfavorite) async{
    var url = Uri.parse('http://192.168.43.66/alfarasha/edit_favorite.php');
    var response=await http.post(url, body: {
      "id"         : id,
      "isfavorite" : isfavorite,
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  Future getFavorite() async {
    var url = Uri.parse('http://192.168.43.66/alfarasha/display_favorite.php');
    var response = await http.get(url);
    var data=json.decode(response.body);
    return data;
  }

  Stream products() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield await getFavorite();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: yellowColor,
            title: Text(
              "المفضله",
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                //Navigator.popAndPushNamed(context, home.id);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => home(),),);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body:StreamBuilder(
            stream: products(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              try {
                if(snapshot.data.length > 0 ){
                  return snapshot.hasData ?
                  GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .8,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        myproducts.add(Product(
                            list[index]['id'],
                            list[index]['name'],
                            list[index]['image'],
                            list[index]['price'],
                            list[index]['isfavorite'],
                            _quantity
                        ));
                        return GestureDetector(
                          onTap:(){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => details(list: list,index: index,),),);
                            Navigator.pushNamed(context, details.id,arguments: myproducts[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 8,
                              child:Column(
                                //mainAxisAlignment:MainAxisAlignment.start ,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      image: list[index]['image'],
                                      height: MediaQuery.of(context).size.height / 5.6,
                                      //width: MediaQuery.of(context).size.width ,
                                      placeholder: 'assets/images/loader.gif',
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/loader.gif',
                                            height: MediaQuery.of(context).size.height / 5.6,
                                            fit: BoxFit.contain);
                                      },
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:3.5)),
                                  Text(
                                    'SDG ${formatter.format(int.parse(list[index]['price']))} سعر القطعه'.toString(),
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top:3)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal:10),
                                        child: Text(
                                          list[index]['name'],
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        width : MediaQuery.of(context).size.width * 0.2,
//                                        height: 80,
//                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(20),
                                            bottomRight: const Radius.circular(20),
                                          ),
                                        ),
                                        child: list[index]['isfavorite']=="0" ?
                                        GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              editFavorite(list[index]['id'], "1");
                                            });
                                            Fluttertoast.showToast(
                                                msg: "تمت الأضافه الي المفضله",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          },
                                          child: Icon(Icons.favorite_border,
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                        ):
                                        GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              editFavorite(list[index]['id'], "0");
                                            });
                                            Fluttertoast.showToast(
                                                msg: "تم الحذف من المفضله",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          },
                                          child: Icon(Icons.favorite,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
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
                      child: Text('لايوجد',
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 30,
                          ),
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
      ),
    );
  }
  placeImage(){
    return Image.asset("images/place.png",
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.contain,
    );
  }
}
