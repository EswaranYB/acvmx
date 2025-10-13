import 'package:flutter/material.dart';
import '../model/stock_inventory_model.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';
import '../../../Network/api_response.dart';
import '../../../core/helper/app_log.dart';

class StockInventoryController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  StockInventoryController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  StockInventoryResponse? _stockInventoryModel;
  StockInventoryResponse? get stockInventoryModel => _stockInventoryModel;


  List<Map<String, dynamic>> tableRows = [
    {'stock': null, 'qtyController': TextEditingController()}
  ];

  void addTableRow() {
    tableRows.add({'stock': null, 'qtyController': TextEditingController()});
    notifyListeners();
  }


  void removeTableRow(int index) {
    tableRows.removeAt(index);
    notifyListeners();
  }
  void clearTableRows() {
    tableRows.clear();
    notifyListeners();
  }


  Future<void> stockInventory() async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiServices.getStockDetails();

      debugPrint("Raw API Response: ${response.data}");

      if (response.status == 200 && response.data != null) {
        if (response.data!['stocks'] != null) {
          _stockInventoryModel = StockInventoryResponse(
            status: response.status,
            message: response.data!['message'] ?? 'Success',
            data: StockData.fromJson({'stocks': response.data!['stocks']}),
          );
        } else {
          // response.data contains full JSON
          _stockInventoryModel = StockInventoryResponse.fromJson(response.data!);
        }

        AppLog.d('Stocks Fetched: ${_stockInventoryModel?.data?.stocks}');
      } else {
        AppLog.d('Failed to fetch details. Status: ${response.status}');
        _stockInventoryModel = StockInventoryResponse(data: StockData(stocks: []));
      }
    } catch (e) {
      debugPrint("Exception in getStockInventory: $e");
      _stockInventoryModel = StockInventoryResponse(data: StockData(stocks: []));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateRow() {
    notifyListeners();
  }
}