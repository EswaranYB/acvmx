import 'package:acvmx/core/app_dimensions.dart';
import 'package:acvmx/core/appbutton.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/core/routes/route_name.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../controller/raised_ticket_by_customerid_controller.dart';

class TicketRaisedScreen extends StatelessWidget {
  const TicketRaisedScreen({super.key});

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.primaryWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Consumer<RaisedTicketsController>(
            builder: (context, controller, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColor.greyE4E4E4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColor.textColor000000),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(AppIcons.filtericon),
                      ),
                      f16(text: "Filter Tickets", fontWeight: FontWeight.w600),
                    ],
                  ),
                  30.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "Ticket Status",
                      fontSize: AppFontSize.s16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.height,
                  Row(
                    children: ['Completed', 'Not Completed', 'Scheduled'].map((status) {
                      final isSelected = controller.tempStatus == status;

                      Color getStatusColor(String status) {
                        switch (status) {
                          case 'Completed':
                            return Colors.green;
                          case 'Scheduled':
                            return Colors.blue;
                          case 'Not Completed':
                            return Colors.red;
                          default:
                            return AppColor.textColor000000;
                        }
                      }

                      final baseColor = getStatusColor(status);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.setTempStatus(status);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: baseColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? baseColor : baseColor.withValues(alpha: 0.0),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: CustomText(
                                text: status,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: baseColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  30.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "Sort By",
                      fontSize: AppFontSize.s16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  16.height,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 37,
                          onPressed: () {
                            controller.setTempSortOrder('desc');
                          },
                          color: controller.tempSortOrder == 'desc'
                              ? AppColor.primaryColor
                              : AppColor.greyE4E4E4,
                          child: Center(
                            child: CustomText(
                              text: 'Newest First',
                              fontWeight: FontWeight.w500,
                              color: controller.tempSortOrder == 'desc'
                                  ?AppColor.primaryWhite
                                  : AppColor.textColor000000,
                            ),
                          ),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: AppButton(
                          height: 37,
                          onPressed: () {
                            controller.setTempSortOrder('asc');
                          },
                            color: controller.tempSortOrder == 'asc'
                                ? AppColor.primaryColor
                                : AppColor.greyE4E4E4,
                          child: Center(
                            child: CustomText(
                              text: 'Oldest First',
                              fontWeight: FontWeight.w500,
                              color: controller.tempSortOrder == 'asc'
                                  ? AppColor.primaryWhite
                                  : AppColor.textColor000000,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  30.height,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 44,
                          text: "Clear Filters",
                          color: AppColor.greyE4E4E4,
                          textColor: AppColor.textColor000000,
                          onPressed: () {
                            controller.clearFilters();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: AppButton(
                          height: 44,
                          text: "Apply Filter",
                          onPressed: () {
                            controller.applyFilters();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Consumer<RaisedTicketsController>(
            builder: (context, controller, child) {
              return Scaffold(
                backgroundColor: AppColor.primaryWhite,
                appBar: commonAppBar(context,
                    title: 'Raised Ticket', showLeading: false),
                body: Column(
                  children: [
                    10.height,
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => _showFilterSheet(context),
                        icon: SvgPicture.asset(AppIcons.ticketfilter),
                      ),
                    ),
                    controller.isLoading
                        ? Expanded(child: Center(child: const CircularProgressIndicator()))
                        : controller.tickets.isEmpty
                        ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CustomText(
                            text: 'No tickets raised yet.',
                            fontSize: AppFontSize.s16,
                            color: AppColor.textColor000000,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        : Expanded(
                      child: ListView.separated(
                        separatorBuilder: (_, __) => 15.height,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: controller.tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = controller.tickets[index];


                          final formattedDate = ticket.createdDate != null
                              ? DateFormat('dd-MM-yyyy').format(ticket.createdDate!.toLocal())
                              : 'N/A';
                          return Card(
                            elevation: 1,
                            color: AppColor.primaryWhite,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColor.greyE4E4E4
                                    .withValues(alpha: 0.2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.shopping_bag_outlined,
                                          color: AppColor.blackColor),
                                      8.width,
                                      Expanded(
                                        child: CustomText(
                                          text:
                                          'Ticket ID ${ticket.ticketId}',
                                          fontSize: AppFontSize.s14,
                                          color: AppColor.textColor000000,
                                          fontWeight: AppFontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  8.height,
                                  CustomText(
                                    text: ticket.problems?.toTitleCase() ??
                                        'No issue mentioned',
                                    fontSize: AppFontSize.s16,
                                    color: AppColor.textColor000000,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ticket.ticketStatus ==
                                              'Completed'
                                              ? AppColor.statusGreen
                                              : ticket.ticketStatus ==
                                              'Scheduled'
                                              ? AppColor.statusBlue
                                              : AppColor.statusRed,
                                        ),
                                      ),
                                      8.width,
                                      CustomText(
                                        text:
                                        '${ticket.ticketStatus} -  $formattedDate',
                                        fontSize: AppFontSize.s14,
                                        color: AppColor.textColor000000,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  8.height,
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AppButton(
                                      height: 24,
                                      width: context.screenWidth * 0.2,
                                      text: 'View',
                                      fontSize: Rem.rem(AppFontSize.s14),
                                      color: AppColor.ticketraisedbutton,
                                      textColor: AppColor.service,
                                      onPressed: () {
                                       context.pushNamed(RouteName.viewTicketScreen,
                                          extra: ticket.uniqueId
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}