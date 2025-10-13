import 'package:acvmx/core/responsive.dart';
import 'package:flutter/material.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_assets.dart';
import '../../../videorecording/view/screen/job_list_view_video_screen.dart';
import '../../controller/ticket_details_byId_controller.dart';
// import '../../model/raised_ticket_model.dart';

  // final TicketModel ticket = TicketModel(
    //   ticketId: 'TICK_001',
    //   workStatus: 'Completed',
    //   title: 'Coffee Machine not working',
    //   serviceNotes: 'Replaced faulty heating coil and tested successfully.',
    //   technicianRemarks: 'Machine is working fine. Keep it dry while cleaning.',
    //   date: '2025-05-28',
    //   time: '14:30',
    // );
class ViewTicketScreen extends StatefulWidget {
  final String ticketId;
  const ViewTicketScreen({super.key, required this.ticketId});

  @override
  State<ViewTicketScreen> createState() => _ViewTicketScreenState();
}

class _ViewTicketScreenState extends State<ViewTicketScreen> {
  bool _isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isDataFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TicketDetailsController>().newFetchTicketByDetails(widget.ticketId);
      });
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketDetailsController>(
      builder: (context, controller, child) {
        final ticketDetails = controller.ticketDetails;

        return Scaffold(
          backgroundColor: AppColor.primaryWhite,
          appBar: commonAppBar(context, title: ' Ticket ID ${widget.ticketId}'),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ticketDetails == null
                  ? const Center(child: CustomText(text: 'No data available.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.greyF7F7F7,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.textColor000000.withValues(alpha: 0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Current Status',
                            fontSize: AppFontSize.s12,
                            fontWeight: AppFontWeight.w600,
                            color: AppColor.greyABABAB,
                          ),
                          5.height,
                          CustomText(
                            text: ticketDetails.ticket?.ticketStatus?.isEmpty?? false
                                ? 'Not Assigned'
                                : ticketDetails.ticket?.ticketStatus ?? 'Unknown',
                            fontSize: AppFontSize.s16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor000000,
                          ),
                        ],
                      ),
                      // const Icon(Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                ),
                15.height,

                // Problem Title
                CustomText(
                  text: "Problem",
                  fontSize: AppFontSize.s12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.greyE4E4E4,
                ),
                4.height,
                CustomText(
                  text:  ticketDetails.ticket?.problems?.toTitleCase() ?? 'No Title',
                  fontSize: AppFontSize.s15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor000000,
                ),
                30.height,

                // Service Notes
                CustomText(
                  text: "Service Notes",
                  fontSize: AppFontSize.s13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor000000,
                ),
                18.height,
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryWhite,
                    border: Border.all(color: AppColor.greyE4E4E4.withValues(alpha: 0.7), width: 2),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: CustomText(
                    text:  ticketDetails.ticket?.comments ?? 'No service notes available.',
                    fontWeight: AppFontWeight.w500,
                    fontSize: AppFontSize.s13,
                    color: AppColor.grey7C7C7C,
                  ),
                ),
                25.height,

                // Technician Remarks
                CustomText(
                  text: "Technician Remarks",
                  fontSize: AppFontSize.s13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor000000,
                ),
                18.height,
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryWhite,
                    border: Border.all(color: AppColor.greyE4E4E4.withValues(alpha: 0.7), width: 2),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: CustomText(
                    text:(ticketDetails.updates != null &&
                        ticketDetails.updates!.isNotEmpty &&
                        ticketDetails.updates!.last.remarks != null &&
                        ticketDetails.updates!.last.remarks!.isNotEmpty)
                        ? ticketDetails.updates!.last.remarks!
                        : 'No remarks available',
                    fontWeight: AppFontWeight.w500,
                    fontSize: AppFontSize.s13,
                    color: AppColor.grey7C7C7C,
                  ),
                ),

                // Attachments
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Card(
                    color: AppColor.primaryWhite,
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(AppIcons.attachmenticon),
                              onPressed: () {},
                            ),
                            CustomText(
                              text: "Attachments",
                              fontSize: AppFontSize.s13,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),ticketDetails.updates == null?
                        CustomText(
                          text: "No Attachments",
                          fontSize: AppFontSize.s13,
                          fontWeight: FontWeight.w600,
                        ):
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.textColor000000.withValues(alpha: 0.1)),
                          ),
                          color: AppColor.primaryWhite,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                                videoUrl:(ticketDetails.updates != null &&
                                                    ticketDetails.updates!.isNotEmpty &&
                                                    ticketDetails.updates!.last.video != null &&
                                                    ticketDetails.updates!.last.video!.isNotEmpty)
                                                    ? ticketDetails.updates!.last.video!
                                                    : '' ,
                                              )));
                                },
                                child: Card(
                                  child: Image.asset(
                                    'assets/images/coffeemachine.png',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              5.width,
                              Card(
                                elevation: 0,
                                color: AppColor.primaryWhite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text:"Product ID:${ticketDetails.ticket?.productId??'No Product ID'}",
                                      color: AppColor.textColor000000,
                                      fontSize: AppFontSize.s12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    6.height,
                                    CustomText(
                                      text:"Remarks:${(ticketDetails.updates != null &&
                                          ticketDetails.updates!.isNotEmpty &&
                                          ticketDetails.updates!.last.remarks != null &&
                                          ticketDetails.updates!.last.remarks!.isNotEmpty)
                                          ? ticketDetails.updates!.last.remarks!
                                          : 'No remarks available'}" ,
                                      color: AppColor.grey7C7C7C,
                                      fontSize: AppFontSize.s12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset(AppIcons.calendericon),
                                          onPressed: () {},
                                        ),
                                        CustomText(
                                          text:"Date:${(ticketDetails?.updates != null && ticketDetails!.updates!.isNotEmpty)
                                              ? (ticketDetails!.updates!.last.updatedDate?.toString() ?? 'No date')
                                              : 'No date available'}",
                                          color: AppColor.textColor000000,
                                          fontSize: AppFontSize.s10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.height,
                      ],
                    ),
                  ),
                ),
                32.height,
              ],
            ),
          ),
        );
      }
    );
  }
}


