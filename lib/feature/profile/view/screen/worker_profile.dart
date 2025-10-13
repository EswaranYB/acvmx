import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:acvmx/feature/profile/controller/worker_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../../../core/sharedpreferences/sharedpreferences_services.dart';
import 'customer_profile_screen.dart';

class WorkerProfile extends StatelessWidget {


   const WorkerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkerProfileController>(
      builder: (context, provider, child) {
        final profileData = provider.workerDetailsByIdResponse;
        return Scaffold(
          appBar: commonAppBar(context, title: 'Profile', showLeading: false,actions: [
            IconButton(
              icon: Icon(
                Icons.logout_outlined,
                color: AppColor.primaryWhite,
              ),
              onPressed: () =>showLogoutDialog(context),
            ),]),
          body: provider.isLoading? const Center(child: CircularProgressIndicator())
              :profileData == null
              ? const Center(child: CustomText(text: 'No data available.'))
              : Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                30.height,
                Container(
                  padding: const EdgeInsets.all(15),
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
                      profileInfo("Name", "${profileData.firstName?.toTitleCase()} ${profileData.lastName?.toTitleCase()}"),
                      profileInfo("Phone", profileData.phoneNumber ?? "N/A"),
                      profileInfo("Email", profileData.email ?? "N/A"),
                      profileInfo("Address", profileData.address!.isEmpty
                          ? "Not Yet Updated"
                          : profileData.address.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
Widget profileInfo(String title, String value) {
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.greyF7F7F7,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: value,
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

