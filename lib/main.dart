import 'package:alfarasha/screens/done.dart';
import 'package:alfarasha/screens/favorite.dart';
import 'package:alfarasha/screens/orderdetails.dart';
import 'package:alfarasha/screens/cartScreen.dart';
import 'package:alfarasha/screens/catigoryproduct.dart';
import 'package:alfarasha/screens/details.dart';
import 'package:alfarasha/screens/myorder.dart';
import 'package:alfarasha/screens/myui.dart';
import 'package:alfarasha/screens/personInfo.dart';
import 'package:alfarasha/screens/profile/profile_screen.dart';
import 'package:alfarasha/screens/spalshscreen.dart';
import 'package:flutter/material.dart';
import 'package:alfarasha/screens/home.dart';
import 'package:alfarasha/screens/catigory.dart';
import 'package:alfarasha/provider/cartItem.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartItem>(
          create: (context) => CartItem(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //initialRoute: isUserLoggedIn ? SplashScreen.id : login.id,
        initialRoute: home.id,
        routes: {
          myui.id: (context) => myui(),
          home.id: (context) => home(),
          catigory.id: (context) => catigory(),
          catigoryproduct.id: (context) => catigoryproduct(),
          details.id: (context) => details(),
          CartScreen.id: (context) => CartScreen(),
          SplashScreen.id: (context) => SplashScreen(),
          PersonInfo.id: (context) => PersonInfo(),
          MyOrder.id: (context) => MyOrder(),
          OrderDetails.id: (context) => OrderDetails(),
          ProfileScreen.id: (context) => ProfileScreen(),
          Done.id: (context) => Done(),
          Favorite.id: (context) => Favorite(),
        },
      ),
    );
  }
}
