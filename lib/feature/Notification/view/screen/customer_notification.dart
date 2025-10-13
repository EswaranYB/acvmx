import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/appbutton.dart';
import '../../../../core/custom_text.dart';
import '../../../Dashboard/view/widgets/appbar.dart';
import '../../controller/notification_controller.dart';

class CustomerNotification extends StatefulWidget {
  const CustomerNotification({super.key});

  @override
  State<CustomerNotification> createState() => _CustomerNotificationState();
}

class _CustomerNotificationState extends State<CustomerNotification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
      Provider.of<NotificationController>(context, listen: false);
      if (controller.notifications.isEmpty) {
        controller.fetchNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, controller, child) {
        final notifications = controller.notifications;

        return Scaffold(
          appBar: commonAppBar(
            context,
            title: 'Notifications',
            showLeading: false,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16),
            child: notifications.isEmpty
                ? const Center(
              child: Text('No notifications found'),
            )
                : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];

                // Status icon mapping
                String iconPath;
                if (notification.status == 1) {
                  iconPath = AppIcons.notificationcheck;
                } else if (notification.status == 0) {
                  iconPath = AppIcons.notificationAssigned;
                } else {
                  iconPath = AppIcons.notificationhour;
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primaryWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.greyE4E4E4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(iconPath),
                        onPressed: () {},
                        iconSize: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: notification.notificationType,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 7),
                            CustomText(
                              text: "Ticket id: ${notification.ticketId}",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor000000,
                            ),
                            const SizedBox(height: 7),
                            CustomText(
                              text: "Ticket id: ${notification.message}",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor000000,
                            ),
                          ],
                        ),
                      ),
                      // AppButton(
                      //   text: 'View',
                      //   textColor: AppColor.primaryColor,
                      //   color: AppColor.statusBlue.withValues(alpha: 0.05),
                      //   onPressed: () {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text('Message: ${notification.message}'),
                      //         behavior: SnackBarBehavior.floating,
                      //         backgroundColor: AppColor.primaryColor,
                      //         duration: const Duration(seconds: 2),
                      //       ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}