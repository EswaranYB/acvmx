import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/model/get_product_detail_by_serial_number_model.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../../../core/routes/route_name.dart';
import '../../../profile/controller/serialno_provider.dart';
class ProductDetails extends StatelessWidget {
  final ProductDetailsBySerialNumberResponse? product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      Provider.of<CustomerProfileProductProvider>(context, listen: false)
          .addProduct(product!);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pushNamed(
            RouteName.dashboardScreen,
            pathParameters: {'userType': 'customer'},
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryWhite,
        appBar: commonAppBar(context, title: 'Product Details', showLeading: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                30.height,
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColor.textColor000000.withValues(alpha: 0.2)),
                  ),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.primaryWhite,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: product?.image == null || product!.image!.isEmpty
                          ? Image.asset(
                        'assets/images/coffeemachineimage.png',
                        fit: BoxFit.contain,
                      )
                          : Image.network(
                        product!.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/coffeemachineimage.png',
                            fit: BoxFit.contain,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
                        },
                      ),
                    ),
                  ),
                ),
                15.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Product Details',
                    color: AppColor.grey9D9D9D,
                    fontSize: AppFontSize.s18,
                    fontWeight: AppFontWeight.w800,
                  ),
                ),
                8.height,
                Card(
                  elevation: 2,
                  color: AppColor.primaryWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColor.textColor000000.withValues(alpha: 0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        CustomText(
                          text: product?.masterProductName,
                          fontWeight: AppFontWeight.w600,
                          fontSize: AppFontSize.s18,
                        ),
                        10.height,
                        KeyValueTextRow(label: "Model Name", value: product?.modelName),
                        10.height,
                        KeyValueTextRow(label: 'Serial Number', value: product?.serialNo),
                        10.height,
                        KeyValueTextRow(label: 'Company name', value: product?.companyName),
                        10.height,
                        KeyValueTextRow(label: 'Location Type', value: product?.serviceLocation),
                        10.height,
                        KeyValueTextRow(label: 'Location', value: product?.location),
                        10.height,
                        KeyValueTextRow(label: 'Branch Name', value: product?.branchName),
                        10.height,
                        KeyValueTextRow(label: 'Address', value: product?.address),
                        10.height,
                        KeyValueTextRow(label: 'State Name', value: product?.state),
                        10.height,
                        KeyValueTextRow(label: 'Zip code', value: product?.zipCode),

                      ],
                    ),
                  ),
                ),
                30.height,
                CustomText(
                  text: 'Start recording Video',
                  fontWeight: AppFontWeight.w600,
                  fontSize: AppFontSize.s16,
                  color: AppColor.textColor000000,
                ),
                10.height,
                InkWell(
                  onTap: () {
                    context.pushNamed(
                        RouteName.customerRecordingScreen,
                        extra: product?.location
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    color: AppColor.primaryWhite,
                    child: Image.asset('assets/images/recording.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyValueTextRow extends StatelessWidget {
  final String label;
  final String? value;
  final double? fontSize;
  final int maxLines;

  const KeyValueTextRow({
    super.key,
    required this.label,
    this.value,
    this.fontSize = 16,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: '$label: ',
          fontSize: fontSize,
          fontWeight: AppFontWeight.w500,
          color: AppColor.grey9D9D9D,
        ),
        Expanded(
          child: CustomText(
            text: value ?? '-',
            fontSize: fontSize,
            fontWeight: AppFontWeight.w600,
            color: AppColor.textColor000000,
            maxLines: maxLines,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

