class ProfileModel {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String productName;
  final String model;
  final String serialNumber;
  final String purchaseDate;
  final String warrantyStatus;

  ProfileModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.productName,
    required this.model,
    required this.serialNumber,
    required this.purchaseDate,
    required this.warrantyStatus,
  });

  // Sample Data
  static List<ProfileModel> profileData = [
    ProfileModel(
      name: "Arom Williams",
      phone: "+233 55 123 4567",
      email: "Aronwilliam@gmail.com",
      address: "Accra, Ghana",
      productName: "Smart Coffee Vending Machine",
      model: "ACVMX 3000 Basic (GB-3000B)",
      serialNumber: "120001V00",
      purchaseDate: "January 15, 2025",
      warrantyStatus: "Active (Valid until Jan 15, 2027)",
    ),
  ];
}
