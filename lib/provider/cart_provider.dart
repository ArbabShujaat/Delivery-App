import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    notifyListeners();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(CartModel cart) {
    _cartList.remove(cart);
    _amount = _amount - (cart.discountedPrice * cart.quantity);
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  bool isExistInCart(int productID) {
    List<int> _idList = [];
    _cartList.forEach((cart) => _idList.add(cart.productId));
    return _idList.contains(productID);
  }

}
