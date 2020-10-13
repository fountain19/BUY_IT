import 'models/product.dart';

List<Product> getProductByCategory(String kJackets, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == kJackets) {
        products.add(product);
      }
    }
  } on Error catch (ex) {
    print(ex);
  }
  return products;
}
List<Product> getProductByCategoryTrousers(String KTrousers, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KTrousers) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}
List<Product> getProductByCategoryTshirt(String KTshirts, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KTshirts) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}
List<Product> getProductByCategoryShoes(String KShoes, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KShoes) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}