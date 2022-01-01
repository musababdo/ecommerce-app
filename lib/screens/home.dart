import 'dart:convert';
import 'dart:io';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/provider/cartItem.dart';
import 'package:alfarasha/screens/cartScreen.dart';
import 'package:alfarasha/screens/favorite.dart';
import 'package:alfarasha/screens/myui.dart';
import 'package:alfarasha/screens/catigory.dart';
import 'package:alfarasha/screens/catigoryproduct.dart';
import 'package:alfarasha/screens/myorder.dart';
import 'package:alfarasha/screens/profile/profile_screen.dart';
import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Info {
  //Constructor
  String username;
  String block;

  Info.fromJson(Map json) {
    username = json['username'];
    this.block = json['block'];
  }
}

class home extends StatefulWidget {
  static String id = 'home';
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int selectedIndex = 0;
  String _username,block;
  int value;

  Future getMyValue() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, ProfileScreen.id);
      }else{
        myDialog();
      }
    });
  }

  Future getMyOrder() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, MyOrder.id);
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

  Future getCatigory() async{
    var url = Uri.parse('http://192.168.43.66/alfarasha/display_catigory.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  SharedPreferences preferences;
  Future getProfile() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("phone"));
    });
    var url = Uri.parse('http://192.168.43.66/alfarasha/profile/display_profile.php');
    var response = await http.post(url, body: {
      "id" : preferences.getString("id"),
    });
    var data = json.decode(response.body);
    setState(() {
      final items = (data['login'] as List).map((i) => new Info.fromJson(i));
      for (final item in items) {
        _username = item.username;
        block     = item.block;
      }
      //print(_username);
    });

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getCatigory();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    return WillPopScope(
      onWillPop:(){
        exitDialog();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: yellowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
            ),
            child: SalomonBottomBar(
              unselectedItemColor: Colors.black45,
              itemPadding: const EdgeInsets.all(12),
              margin:
              const EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
              currentIndex: selectedIndex,
              onTap: (int x) {
                setState(() {
                  selectedIndex = x;
                });
              },
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("الرئيسيه",style: GoogleFonts.cairo()),
                  selectedColor: Colors.black,
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: Icon(Icons.favorite),
                  title: GestureDetector(
                      onTap:(){
                        Navigator.pushNamed(context, Favorite.id);
                      },
                      child: Text("المفضله",style: GoogleFonts.cairo())),
                  selectedColor: Colors.black,
                ),

                /// Search
                SalomonBottomBarItem(
                  icon: Icon(Icons.shopping_basket),
                  title: GestureDetector(
                      onTap:(){
                        getMyOrder();
                      },
                      child: Text("الطلبات",style: GoogleFonts.cairo())),
                  selectedColor: Colors.black,
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: GestureDetector(
                      onTap:(){
                        //Navigator.pushNamed(context, ProfileScreen.id);
                        getMyValue();
                      },
                      child: Text("الشخصيه",style: GoogleFonts.cairo())),
                  selectedColor: Colors.black,
                ),
              ],
            ),
          ),
          body: AnimatedDrawer(
            homePageXValue: 170,
            homePageYValue: 80,
            homePageAngle: -0.2,
            homePageSpeed: 250,
            shadowXValue: 122,
            shadowYValue: 110,
            shadowAngle: -0.275,
            shadowSpeed: 550,
            shadowColor: yellowOpenColor.withOpacity(0.7),
            backgroundGradient: LinearGradient(
              colors: [
                yellowColor,
                yellowOpenColor,
              ],
            ),
            openIcon: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                )),
            closeIcon: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            menuPageContent: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _username == null ?
                    Text("",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    ):
                    Text("مرحبا",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    ),
                    _username == null ?
                    Text(
                      "",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ):
                    Text(
                      _username,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 20,
                      ),
                    ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 140,
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    InkWell(
                      onTap: () {
                        //Navigator.pushNamed(context, ProfileScreen.id);
                        getMyValue();
                      },
                      child: Text("الصفحه الشخصيه",style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Favorite.id);
                      },
                      child: Text("المفضله",style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Text("السله",style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        getMyOrder();
                      },
                      child: Text("الطلبات",style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 140,
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      child: Text('تسجيل خروج',style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        ),
                      ),),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                      onPressed: () {
                        preferences.remove("value");
                        SystemNavigator.pop();
                        Fluttertoast.showToast(
                            msg: "تم تسجيل الخروج",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            homePageContent: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    decoration: BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:90),
                                child: Text(
                                    "الفراشه أستور",style: GoogleFonts.cairo(
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),),
                              ),
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart,
                                      color: Colors.black,
                                    ),
                                    onPressed: (){
                                      Navigator.pushNamed(context, CartScreen.id);
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.0,top: 5),
                                    child: CircleAvatar(
                                      radius: 10.0,
                                      child: GestureDetector(
                                        onTap:(){
                                          Navigator.pushNamed(context, CartScreen.id);
                                        },
                                        child: Text(
                                          cproducts.length.toString()
                                          ,
                                          style: TextStyle(fontSize: 15,color: Color(0xFFFFFFFF)),
                                        ),
                                      ),
                                      backgroundColor: Color(0xFFA11B00),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        buildSearchBar(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: 150.0,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(18),
                        bottomRight: const Radius.circular(18),
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                      ),
                      child: Carousel(
                        dotIncreaseSize: 0.8,
                        dotSize: 8,
                        dotColor: appRecentColor,
                        dotBgColor: Colors.transparent,
                        borderRadius: true,
                        boxFit: BoxFit.cover,
                        images: List.generate(
                          slideShowList.length,
                              (index) => Image.asset(slideShowList[index],
                                fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "التصنيفات",style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),),
                        GestureDetector(
                          onTap:(){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => catigory(),),);
                            Navigator.popAndPushNamed(context, catigory.id);
                          },
                          child: Text(
                            ".. عرض المزيد",
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: FutureBuilder(
                      future: getCatigory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        try {
                            return snapshot.hasData ?
                            ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  List list = snapshot.data;
                                  return GestureDetector(
                                    onTap:(){
                                      if(block == "0") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => catigoryproduct(list: list,index: index,),),);
                                      }else if(block == "1"){
                                        blockDialog();
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => catigoryproduct(list: list,index: index,),),);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        elevation: 8,
                                        child:Container(
                                          width: MediaQuery.of(context).size.width * .6,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0)),
                                          ),
                                          child: Column(
                                            //mainAxisAlignment:MainAxisAlignment.start ,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: new BorderRadius.only(
                                                  topLeft: const Radius.circular(20),
                                                  topRight: const Radius.circular(20),
                                                ),
                                                child:FadeInImage.assetNetwork(
                                                  image: list[index]['image'],
                                                  height: MediaQuery.of(context).size.height * 0.2,
                                                  placeholder: 'assets/images/loader.gif',
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/loader.gif',
                                                        height: MediaQuery.of(context).size.height * 0.2,
                                                        fit: BoxFit.contain);
                                                  },
                                                  fit: BoxFit.contain,
                                                ),
//                                                child:Image.network(list[index]['image'],
//                                                  height: MediaQuery.of(context).size.height * 0.2,
//                                                  fit: BoxFit.contain,
//                                                ),
                                              ),
                                              Padding(padding: const EdgeInsets.only(top:1)),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: Text(
                                                  list[index]['name'],
                                                    style: GoogleFonts.cairo(
                                                      textStyle: TextStyle(
                                                        fontSize: 18,
                                                        color:Colors.black,
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
                        }catch(e){
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        }
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
    return Image.asset("images/loader.gif",
        height: MediaQuery.of(context).size.height * 0.2,
        fit: BoxFit.contain,
    );
  }
  exitDialog(){
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
                    Text("الخروج من التطبيق",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('هل تود الخروج من التطبيق ',style: GoogleFonts.cairo(
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
                                SystemNavigator.pop();
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
  blockDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('عذرا,لايمكنك التصفح لقد تم حظرك',style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 17,
              ),
            ),),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا",style: GoogleFonts.cairo(
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
buildSearchBar() {
  return Container(
    decoration: BoxDecoration(
      color: appRecentColor,
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
    child: TextFormField(
      controller: new TextEditingController(),
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF98A0A6),
            size: 20,
          ),
          hintText: "أبحث هنا",
          hintStyle: GoogleFonts.cairo(
            textStyle: TextStyle(
                color:Color(0xFF98A0A6),
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10),
          border: InputBorder.none,
          enabledBorder: InputBorder.none),
    ),
  );
}




