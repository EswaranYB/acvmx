import 'package:flutter/cupertino.dart';

import '../../Dashboard/model/get_product_detail_by_serial_number_model.dart';

class CustomerProfileProductProvider with ChangeNotifier {
  // List of products
  List<ProductDetailsBySerialNumberResponse> _selectedProducts = [];

  List<ProductDetailsBySerialNumberResponse> get selectedProducts => _selectedProducts;

  /// Add a product to the list
  void addProduct(ProductDetailsBySerialNumberResponse product) {
    // Prevent duplicates if needed
    if (!_selectedProducts.any((p) => p.serialNo == product.serialNo)) {
      _selectedProducts.add(product);
      notifyListeners();
    }
  }

  /// Remove a product if needed
  void removeProduct(ProductDetailsBySerialNumberResponse product) {
    _selectedProducts.removeWhere((p) => p.serialNo == product.serialNo);
    notifyListeners();
  }

  /// Clear all products
  void clearAllProducts() {
    _selectedProducts.clear();
    notifyListeners();
  }
}