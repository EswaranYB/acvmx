import 'package:acvmx/core/appbutton.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/auth/controller/auth_controller.dart';
import 'package:acvmx/feature/profile/controller/get_user_details_controller.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../../Dashboard/model/get_product_detail_by_serial_number_model.dart';
import '../../controller/serialno_provider.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  bool isMachineDetailsOpened = false;
  String? selectedMachine;
  List<ProductDetailsBySerialNumberResponse> machines = []; // Not used, kept

  Map<String, bool> machineExpandedState = {};
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: Provider.of<CustomerProfileProductProvider>(context),
            ),
          ],
          child: Consumer2<GetUserDetailsProvider,CustomerProfileProductProvider>(
            builder: (context, controller,productProvider, child) {
              final profileData = controller.userDetailsByIdResponse;
              final products = productProvider.selectedProducts ?? [];

              return Scaffold(
                backgroundColor: AppColor.primaryWhite,
                appBar: commonAppBar(
                    context, title: 'Profile', showLeading: false, actions: [
                  IconButton(
                    icon: Icon(
                      Icons.logout_outlined,
                      color: AppColor.primaryWhite,
                    ),
                    onPressed: () => showLogoutDialog(context),
                  ),
                ]),
                body: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : profileData == null
                    ? const Center(child: CustomText(text: 'No data available.'))
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.height,
                      Row(
                        children: [
                          10.height,
                          CustomText(
                            text: 'Profile',
                            fontSize: AppFontSize.s16,
                            fontWeight: AppFontWeight.w600,
                            color: AppColor.textColor000000,
                          ),
                        ],
                      ),
                      10.height,
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.primaryWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grey7C7C7C,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileInfo("Name",
                                "${profileData.firstName ?? ''} ${profileData
                                    .lastName ?? ''}"),

                            profileInfo("Phone", profileData.phoneNumber ?? ''),
                            profileInfo("Email", profileData.email ?? ''),

                            profileInfo("Address", profileData.address ?? ''),
                            CustomText(
                              text: "Machine Details",
                              fontSize: AppFontSize.s18,
                              fontWeight: AppFontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                            for (var selectedProduct in products) ...[

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColor.primaryWhite),
                                    color: AppColor.primaryWhite),
                                child: Column(
                                  spacing: 6,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          final key = selectedProduct.serialNo ?? '';
                                          machineExpandedState[key] =
                                          !(machineExpandedState[key] ?? false);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8,),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColor.primaryWhite),
                                            color: AppColor.primaryWhite
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(selectedProduct.modelName ?? "Select Machine",
                                                style: TextStyle(
                                                    fontSize: AppFontSize.s14,
                                                    fontWeight: AppFontWeight.w600,
                                                    color: AppColor.textColor000000)),
                                            Icon(
                                                machineExpandedState[selectedProduct.serialNo ?? ''] ?? false
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                color: AppColor.textColor000000),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (machineExpandedState[selectedProduct.serialNo ?? ''] ?? false) ...[
                                      10.height,
                                      productInfo("", selectedProduct.masterProductName),
                                      productInfo("", selectedProduct.companyName),
                                      productInfo("Serial Number:", selectedProduct.serialNo ?? "N/A"),
                                      productInfo("Purchase Date:", selectedProduct.uniqueId ?? "N/A"),
                                      productInfo("Warranty Status:", selectedProduct.varrantyDetails ?? "N/A"),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      30.height
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget profileInfo(String? title, String? value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomText(
                text: title,
                fontSize: AppFontSize.s12,
                fontWeight: AppFontWeight.w400,
                color: AppColor.grey7C7C7C,
              ),
            ),
            5.width,
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.greyF7F7F7,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  text: value ?? '',
                  fontSize: AppFontSize.s14,
                  fontWeight: AppFontWeight.w600,
                  color: AppColor.textColor000000,
                ),
              ),
            ),
          ],
        ),
        15.height,
      ],
    );
  }
  Widget productInfo(String? title, String? value) {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title ?? '',
          fontSize: AppFontSize.s16,
          fontWeight: AppFontWeight.w600,
          color: AppColor.grey7C7C7C,
        ),
        CustomText(
          text: value ?? '',
          fontSize: AppFontSize.s16,
          fontWeight: AppFontWeight.w600,
          color: AppColor.textColor000000,
        ),
        15.height,
      ],
    );
  }
}
  Future<void> showLogoutDialog(BuildContext context) async {
    final logout=Provider.of<AuthController>(context,listen: false);
    final size=MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.primaryWhite,
          title: const CustomText(text: 'Logout'),
          content: const CustomText(text: 'Are you sure you want to logout?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  width: size.width*.3,
                  color: AppColor.primaryWhite,
                  child: const CustomText(text: 'Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
                3.width,
                AppButton(
                  width: size.width*.3,
                  child: CustomText(text: "Logout",color: AppColor.primaryWhite,),
                  onPressed: () {
                    Navigator.of(context).pop();
                    logout.logout(context);
                  },
                ),
              ],
            ),

          ],
        );
      },
    );
  }


