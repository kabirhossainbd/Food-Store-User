import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/utill/images.dart';


class Category{
  const Category({
    @required this.name,
    @required this.products,
  });
  final String name;
  final  List<Product> products;
}

class Product{
  const Product({
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.image,
});
  final String name;
  final String description;
  final double price;
  final String image;
}

const rappiCategories = [
  Category(
    name: 'Order Align',
    products: [
      Product(name: 'Order Pizza', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Order Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Order Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),
  Category(
    name: 'Pizza Food',
    products: [
      Product(name: ' Pizza Food Demo', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Pizza Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Pizza Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),
  Category(
    name: 'First Food',
    products: [
      Product(name: 'First Pizza', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'First Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Order Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'First Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),
  Category(
    name: 'Beef Food',
    products: [
      Product(name: 'Beef Food Demo', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Beef Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Beef Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),

  Category(
    name: 'Fuska',
    products: [
      Product(name: 'Fuska Pizza', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Fuska Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Fuska Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),
  Category(
    name: 'Chicken',
    products: [
      Product(name: 'Chicken Food Demo', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Chicken Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Pizza Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),

  Category(
    name: 'Beef Birani',
    products: [
      Product(name: 'Beef Food Demo', description: 'description', price: 120.0, image: Images.placeholder_image),
      Product(name: 'Order Beef Fuska', description: 'description', price: 110.0, image: Images.placeholder_image),
      Product(name: 'Panda Beef Cook', description: 'description', price: 100.0, image: Images.placeholder_image),
      Product(name: 'Hungry Chicken', description: 'description', price: 120.0, image: Images.placeholder_image),
    ],
  ),
];