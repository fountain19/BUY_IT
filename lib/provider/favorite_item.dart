

import 'package:flutter/cupertino.dart';
import 'package:store_app/models/product.dart';

class FavoriteItem extends ChangeNotifier{
  List<Product> products=[];
  addProduct(Product product)
  {
    products.add(product);
    notifyListeners();
  }
  deleteProduct(Product product)
  {
    products.remove(product);
    notifyListeners();
  }
}
