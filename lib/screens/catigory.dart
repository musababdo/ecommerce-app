
import 'dart:convert';

import 'package:alfarasha/constants.dart';
import 'package:alfarasha/screens/catigoryproduct.dart';
import 'package:alfarasha/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info {
  //Constructor
  String block;

  Info.fromJson(Map json) {
    this.block = json['block'];
  }
}

class catigory extends StatefulWidget {
  static String id = 'catigory';
  @override
  _catigoryState createState() => _catigoryState();
}

class _catigoryState extends State<catigory> {

  String block;

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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop:(){
        Navigator.popAndPushNamed(context, home.id);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: yellowColor,
            title: Text(
              'التصنيفات',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.popAndPushNamed(context, home.id);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => home(),),);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body:FutureBuilder(
            future: getCatigory(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              try {
                if(snapshot.data.length > 0 ){
                  return snapshot.hasData ?
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: screenHeight * .18,
                            child: GestureDetector(
                              onTap:(){
                                if(block == "0") {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => catigoryproduct(list: list,index: index,),),);
                                }else if(block == "1"){
                                  blockDialog();
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => catigoryproduct(list: list,index: index,),),);
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                elevation: 8,
                                child:Row(
                                  //mainAxisAlignment:MainAxisAlignment.start ,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        bottomLeft: const Radius.circular(20),
                                      ),
                                      child:FadeInImage.assetNetwork(
                                        image: list[index]['image'],
                                        placeholder: 'assets/images/loader.gif',
                                        width: MediaQuery.of(context).size.width / 3,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/loader.gif',
                                              width: MediaQuery.of(context).size.width / 3,
                                              fit: BoxFit.contain);
                                        },
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Padding(padding: const EdgeInsets.only(left:10)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        list[index]['name'],
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black
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

