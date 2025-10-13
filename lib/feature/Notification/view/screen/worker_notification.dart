import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/appbutton.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:flutter/material.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../controller/notification_controller.dart';


class WorkerNotification extends StatefulWidget {
  const WorkerNotification({super.key});

  @override
  State<WorkerNotification> createState() => _WorkerNotificationState();
}

class _WorkerNotificationState extends State<WorkerNotification> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications after first frame
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

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (did, result) {
            if (did) {
              Navigator.pop(context);
            }
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
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
                  separatorBuilder: (_, __) => 12.height,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primaryWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColor.greyE4E4E4),
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              notification.status == 'Completed'
                                  ? AppIcons.notificationcheck
                                  : notification.status ==
                                  'Unresolved'
                                  ? AppIcons
                                  .notificationhour
                                  : AppIcons
                                  .notificationAssigned,
                            ),
                            onPressed: () {},
                            iconSize: 24,
                          ),
                          10.height,
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: notification.notificationType,
                                  fontSize: AppFontSize.s14,
                                  fontWeight:
                                  AppFontWeight.w600,
                                ),
                                7.height,
                                CustomText(
                                  text:
                                  "Ticket id: ${notification.ticketId}",
                                  fontSize: AppFontSize.s14,
                                  fontWeight:
                                  AppFontWeight.w400,
                                  color:
                                  AppColor.textColor000000,
                                ),
                                7.height,
                                CustomText(
                                  text:
                                  "Message: ${notification.message}",
                                  fontSize: AppFontSize.s14,
                                  fontWeight:
                                  AppFontWeight.w500,
                                  color:
                                  AppColor.primaryColor,
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
            ),
          ),
        );
      },
    );
  }
}