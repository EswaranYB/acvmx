import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/controller/get_product_detail_controller.dart';
import 'package:acvmx/feature/profile/controller/get_user_details_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/appbutton.dart';
import '../../../../core/helper/app_log.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/sharedpreferences/sharedpreferences_services.dart';
import '../../../Ticket/controller/raised_ticket_by_customerid_controller.dart';

class CustomerHomeScreen extends StatelessWidget {
   CustomerHomeScreen({super.key});
  final TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userId = SharedPrefService().getUserId();
   final raisedTicketController=context.read<RaisedTicketsController>();
   final getUserDetail = context.read<GetUserDetailsProvider>();
    final productController = context.read<ProductDetailProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId != null) {
        print("================$userId");
        raisedTicketController.fetchTicketsByCustomerId(userId);
        getUserDetail.getUserDetailsApiCall(userId);
      }
    });


    return PopScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                SizedBox(
                  height: size.height * 0.33,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Selector<GetUserDetailsProvider, String?>(
                                  selector: (_, provider) => provider.userDetailsByIdResponse?.image,
                                  builder: (context, imageUrl, child) {
                                    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

                                    return CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColor.primaryColor,
                                      child: ClipOval(
                                        child: hasImage
                                            ? Image.network(
                                          imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    AppColor.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return SvgPicture.asset(
                                              AppIcons.profile,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                            : SvgPicture.asset(
                                          AppIcons.profile,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                20.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Hello,',
                                        fontSize: AppFontSize.s18,
                                        color: AppColor.primaryWhite,
                                      ),
                                      Selector<GetUserDetailsProvider, String?>(
                                        selector: (_, provider) => provider.userDetailsByIdResponse?.username,
                                        builder: (_, username, __) {
                                          return CustomText(
                                            text: username ?? 'User',
                                            fontSize: AppFontSize.s22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primaryWhite,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        top: size.height * 0.1,
                        left: 20,
                        right: 20,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 69,
                            child: Card(
                              elevation: 5,
                              color: AppColor.primaryWhite,
                              shadowColor: AppColor.blackColor,
                              child: ListTile(
                                leading:
                                    SvgPicture.asset(AppIcons.documentsearch),
                                title: CustomText(
                                  text: 'Ticket Raised',
                                  fontSize: AppFontSize.s16,
                                  fontWeight: AppFontWeight.w500,
                                ),
                                trailing: CircleAvatar(
                                  backgroundColor: AppColor.primaryWhite,
                                  child: Consumer<RaisedTicketsController>(
                                    builder: (context,controller, child) {
                                      return CustomText(
                                        text: controller.ticketCount.toString(),
                                        fontSize: AppFontSize.s24,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.w900,
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'Raise a Ticket',
                          fontSize: AppFontSize.s16,
                          fontWeight: AppFontWeight.w600,
                        ),
                      ),
                      20.height,
                      AppButton(
                        text: 'Scan Barcode',
                        onPressed: () =>
                            context.pushNamed(RouteName.barcodeScannerScreen),
                        height: 50,
                      ),
                      15.height,
                      CustomText(
                        text: 'Or',
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSize.s14,
                      ),
                      20.height,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColor.primaryWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.grey7C7C7C.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: codeController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Code',
                          ),
                          style: TextStyle(
                            color: AppColor.textColor000000,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      20.height,
                      AppButton(
                        text: 'Submit',
                        // onPressed: ()=> FirebaseCrashlytics.instance.crash(),
                        onPressed: () => _handleCodeSubmit(
                          context,
                          codeController,
                          productController,
                        ),
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle code submission
  static Future<void>  _handleCodeSubmit(
    BuildContext context,
    TextEditingController codeController,
    ProductDetailProvider productController,
  ) async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      showSnackBar(context,'Please enter the Serial Number.');
    }else{

    try {
      await productController.handleSerialNumberScan(context, code);
      // Clear the field after successful submission
      codeController.clear();
    } catch (e) {

      showSnackBar(context,'Error: ${e.toString()}');
      AppLog.d('Error in handleCodeSubmit: $e');
    }
  }}
}
