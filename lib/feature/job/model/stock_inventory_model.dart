import 'dart:convert';

StockInventoryResponse stockInventoryResponseFromJson(String str) =>
    StockInventoryResponse.fromJson(json.decode(str));

String stockInventoryResponseToJson(StockInventoryResponse data) =>
    json.encode(data.toJson());

class StockInventoryResponse {
  int? status;
  String? message;
  StockData? data;

  StockInventoryResponse({this.status, this.message, this.data});

  factory StockInventoryResponse.fromJson(Map<String, dynamic> json) =>
      StockInventoryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? StockData(stocks: []) : StockData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class StockData {
  List<StockInventoryModel> stocks;

  StockData({required this.stocks});

  factory StockData.fromJson(Map<String, dynamic> json) => StockData(
    stocks: json["stocks"] == null
        ? []
        : List<StockInventoryModel>.from(
        json["stocks"].map((x) => StockInventoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stocks": List<dynamic>.from(stocks.map((x) => x.toJson())),
  };
}

class StockInventoryModel {
  int? id;
  String? itemName;
  int? availableStock;
  String? measureName;
  String? stockUniqueId;

  StockInventoryModel({
    this.id,
    this.itemName,
    this.availableStock,
    this.measureName,
    this.stockUniqueId,
  });

  factory StockInventoryModel.fromJson(Map<String, dynamic> json) =>
      StockInventoryModel(
        id: json["stock_id"],
        itemName: json["item_name"],
        availableStock: json["available_stock"],
        measureName: json["unit_measure_name"],
        stockUniqueId: json["employee_stock_unique_id"],
      );

  Map<String, dynamic> toJson() => {
    "stock_id": id,
    "item_name": itemName,
    "available_stock": availableStock,
    "unit_measure_name": measureName,
    "employee_stock_unique_id": stockUniqueId,
  };
}