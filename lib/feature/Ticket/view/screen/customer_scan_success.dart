import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/appbutton.dart';
import '../../../../core/routes/route_name.dart';


class CustomerScanSuccess extends StatelessWidget {
  const CustomerScanSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.primaryWhite,
      body: Column(
        children: [
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
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(AppIcons.menuIcon),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: CustomText(
                              text: 'ACVMX',
                              color: AppColor.primaryWhite,
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(AppIcons.searchIcon),
                            onPressed: () {
                              },
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColor.primaryColor,
                            child: SvgPicture.asset(
                              height: 60,
                              fit: BoxFit.cover,
                              AppIcons.profile,
                            ),
                          ),
                          20.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Hello,',
                                fontSize: AppFontSize.s18,
                                color: AppColor.primaryWhite,
                              ),
                              CustomText(
                                text: 'Kodiyarasan',
                                fontSize: AppFontSize.s22,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryWhite,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Positioned.fill(
                  top: size.height * 0.1,
                  // Adjust this value to align the container below the blue container
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
                          leading: SvgPicture.asset(AppIcons.documentsearch),
                          title: CustomText(
                            text: 'Ticket Raised',
                            fontSize: AppFontSize.s16,
                            fontWeight: FontWeight.w500,
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: AppColor.primaryWhite,
                            child: CustomText(
                              text: '6',
                              fontSize: AppFontSize.s24,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w900,
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
          15.height,
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
                  onPressed: () {},
                  height: 50,
                ),
                300.height,
                AppButton(
                  height: 40,
                  width: 200,
                  text: 'Ticket Raised Successfully',
                  onPressed: () {
                    context.pushNamed(
                      RouteName.dashboardScreen,
                      pathParameters: {
                        'userType': 'customer', // or 'admin', etc.
                      },
                      queryParameters: {
                        'tab': '1', // Optional, defaults to 0
                      },
                    );
                  },
                  color: AppColor.ticketraisedbutton,
                  textColor: AppColor.blue3E39FE,
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
