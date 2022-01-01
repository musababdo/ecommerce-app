import 'package:alfarasha/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier{

  List<Product> products=[];
  int qua;

  addProduct(Product product,int qu){
    products.add(product);
    qua=qu;
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }

  deleteAll(){
    products.clear();
    notifyListeners();
  }

}