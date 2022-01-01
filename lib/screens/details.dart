import 'package:alfarasha/constants.dart';
import 'package:alfarasha/models/product.dart';
import 'package:alfarasha/provider/cartItem.dart';
import 'package:alfarasha/screens/cartScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class details extends StatefulWidget {
  static String id = 'details';

  final List list;
  final int index;
  details({this.list,this.index});
  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {

  String id,image,name,price,isfavorite;
  int _quantity = 1;
  final formatter = new NumberFormat("###,###");

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    id         =  widget.list[widget.index]['id'];
//    image      =  widget.list[widget.index]['image'];
//    name       =  widget.list[widget.index]['name'];
//    price      =  widget.list[widget.index]['price'];
//    isfavorite =  widget.list[widget.index]['isfavorite'];
//  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: 300.0,
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            child:Image.network(product.image,fit:BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: new Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          elevation: 9,
                          color: Colors.white,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .3,
                            width:  MediaQuery.of(context).size.width ,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Text(
                                        product.name,
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 80,
                                      width : MediaQuery.of(context).size.width * 0.2,
//                                        height: 80,
//                                        width: 80,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: const Radius.circular(20),
                                          bottomLeft: const Radius.circular(20),
                                        ),
                                      ),
                                      child: product.favorite == "0" ?
                                      Icon(Icons.favorite_border,
                                        color: Colors.black,
                                        size: 40,
                                      ):
                                      Icon(Icons.favorite,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    )
                                  ],
                                ),
//                                SizedBox(
//                                  height: 5,
//                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(
                                    'SDG ${formatter.format(int.parse(product.price))} سعر القطعه'.toString(),
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
//                          SizedBox(
//                            height: 7,
//                          ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipOval(
                                      child: Material(
                                        color: yellowColor,
                                        child: GestureDetector(
                                          onTap: add,
                                          child: SizedBox(
                                            child: Icon(Icons.add,size: 30),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _quantity.toString(),
                                      style: TextStyle(fontSize: 40),
                                    ),
                                    ClipOval(
                                      child: Material(
                                        color: yellowColor,
                                        child: GestureDetector(
                                          onTap: subtract,
                                          child: SizedBox(
                                            child: Icon(Icons.remove,size: 30,),
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.shopping_cart,size: 35,),
                                style: ElevatedButton.styleFrom(
                                  primary: yellowColor,
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                              ),
                              onPressed: () {
                                CartItem cartItem=Provider.of<CartItem>(context,listen: false);
                                product.quantity = _quantity;
                                bool exist = false;
                                var productsInCart = cartItem.products;
                                for (var productInCart in productsInCart) {
                                  if (productInCart.name == product.name) {
                                    exist = true;
                                  }
                                }
                                if (exist) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('هذا العنصر موجود في السله',style: GoogleFonts.cairo(),),
                                  ));
                                } else {
//                          setState(() {
//                            visibilityCount = true ;
//                          });
                                  cartItem.addProduct(product,product.quantity);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('تمت الاضافه الي السله',style: GoogleFonts.cairo(),),
                                  ));
                                }
                              },
                              label: Padding(
                                padding: const EdgeInsets.only(top: 15,bottom: 15,right: 35,left: 35),
                                child: Text(
                                  'أضف الي السله'.toUpperCase(),
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
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Icon(Icons.arrow_back,color: Colors.black),
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.pushNamed(context, CartScreen.id);
                        },
                        child: ClipOval(
                          child: Material(
                            color: Colors.white,
                            child: Stack(
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
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
    });
  }
}
