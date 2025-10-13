// To parse this JSON data, do
//
//     final productDetailsBySerialNumberRespnse = productDetailsBySerialNumberRespnseFromJson(jsonString);

import 'dart:convert';



class ProductDetailsBySerialNumberResponse {
  int? id;
  String? uniqueId;
  String? productId;
  String? productName;
  String? serialNo;
  String? varrantyDetails;
  DateTime? manufacturedDate;
  String? manufacturedBy;
  String? serviceLocation;
  String? modelName;
  String? address;
  String? location;
  String? state;
  String? price;
  String? image;
  DateTime? createdDate;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? updatedDate;
  int? deletedStatus;
  String? barCode;
  String? masterProductName;
  int? companyId;
  int? branchId;
  String? productStatus;
  String? createdType;
  String? updatedType;
  String? companyName;
  String? branchName;
  String? zipCode;

  ProductDetailsBySerialNumberResponse({
    this.id,
    this.uniqueId,
    this.productId,
    this.productName,
    this.serialNo,
    this.varrantyDetails,
    this.manufacturedDate,
    this.manufacturedBy,
    this.serviceLocation,
    this.modelName,
    this.price,
    this.image,
    this.createdDate,
    this.createdBy,
    this.updatedBy,
    this.updatedDate,
    this.deletedStatus,
    this.barCode,
    this.masterProductName,
    this.companyId,
    this.branchId,
    this.productStatus,
    this.createdType,
    this.updatedType,
    this.companyName,
    this.branchName,
    this.zipCode,
    this.address,
    this.location,
    this.state,
  });

  factory ProductDetailsBySerialNumberResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsBySerialNumberResponse(
      id: json["id"],
      uniqueId: json["unique_id"],
      productId: json["product_id"],
      productName: json["product_name"],
      serialNo: json["serial_no"],
      varrantyDetails: json["varranty_details"],
      manufacturedDate: json["manufactured_date"] == null ? null : DateTime.tryParse(json["manufactured_date"]),
      manufacturedBy: json["manufactured_by"],
      serviceLocation: json["servicelocation"],
      modelName: json["model_name"],
      price: json["price"],
      image: json["image"],
      createdDate: json["created_date"] == null ? null : DateTime.tryParse(json["created_date"]),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      updatedDate: json["updated_date"] == null ? null : DateTime.tryParse(json["updated_date"]),
      deletedStatus: json["deleted_status"],
      barCode: json["bar_code"],
      masterProductName: json["master_product_name"],
      companyId: json["company_id"],
      branchId: json["branch_id"],
      productStatus: json["product_status"],
      createdType: json["created_type"],
      updatedType: json["updated_type"],
      companyName: json["company_name"],
      branchName: json["branch_name"],
      zipCode: json["zip_code"],
      address: json["address"],
      location: json["location"],
      state: json["state_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "product_id": productId,
    "product_name": productName,
    "serial_no": serialNo,
    "varranty_details": varrantyDetails,
    "manufactured_date": manufacturedDate?.toIso8601String(),
    "manufactured_by": manufacturedBy,
    "servicelocation": serviceLocation,
    "model_name": modelName,
    "price": price,
    "image": image,
    "created_date": createdDate?.toIso8601String(),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "updated_date": updatedDate?.toIso8601String(),
    "deleted_status": deletedStatus,
    "bar_code": barCode,
    "master_product_name": masterProductName,
    "company_id": companyId,
    "branch_id": branchId,
    "product_status": productStatus,
    "created_type": createdType,
    "updated_type": updatedType,
    "company_name": companyName,
    "branch_name": branchName,
    "zip_code": zipCode,
    "address": address,
    "location": location,
    "state_name": state,
  };
}
