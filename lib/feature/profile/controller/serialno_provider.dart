import 'package:acvmx/Network/api_manager.dart';
import 'package:flutter/cupertino.dart';

import '../../../Network/api_service.dart';
import '../../Dashboard/model/get_product_detail_by_serial_number_model.dart';

class CustomerProfileProductProvider with ChangeNotifier {
  // List of products
  List<ProductDetailsBySerialNumberResponse> _selectedProducts = [];

  List<ProductDetailsBySerialNumberResponse> get selectedProducts =>
      _selectedProducts;
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  CustomerProfileProductProvider() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
Future<void> getUserProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiServices.getUserProducts();

      debugPrint("========= FULL API RESPONSE =========");
      debugPrint("STATUS: ${response.status}");
      debugPrint("MESSAGE: ${response.message}");
      debugPrint("RAW DATA: ${response.data}");
      debugPrint("LIST DATA: ${response.listData}");

      if (response.status == 200 && response.listData != null) {
        _selectedProducts = List<ProductDetailsBySerialNumberResponse>.from(
          response.listData!.map(
            (item) => ProductDetailsBySerialNumberResponse.fromJson(item),
          ),
        );
        debugPrint("✅ Products fetched: ${_selectedProducts.length}");
      } else {
        debugPrint("⚠️ Failed to fetch products. Message: ${response.message}");
        _selectedProducts = [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching user products: $e");
      _selectedProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
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
