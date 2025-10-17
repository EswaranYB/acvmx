import 'dart:io';

import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/core/routes/route_name.dart';
import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
import 'package:acvmx/feature/job/controller/stock_inventory_controller.dart';
import 'package:acvmx/feature/videorecording/controller/technician_recording_provider.dart';
import 'package:acvmx/feature/videorecording/view/screen/job_list_view_video_screen.dart';
import 'package:acvmx/feature/videorecording/view/screen/technician_recordingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/appbutton.dart';
import '../../../../core/custom_text.dart';
import '../../../Dashboard/view/widgets/appbar.dart';
import '../../../Ticket/controller/ticket_details_byId_controller.dart';
import '../../../Ticket/model/update_ticket_by_technician_model.dart';
import '../../model/stock_inventory_model.dart';

class JobDetailsScreen extends StatefulWidget {
  final String ticketId;
  final String jobUniqueId;
  const JobDetailsScreen({super.key, required this.ticketId, required this.jobUniqueId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final ValueNotifier<String> _statusNotifier = ValueNotifier<String>('Scheduled');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController usedQtyController = TextEditingController();
  StockInventoryModel? selectedStock;
  final ValueNotifier<String> _techRemarksNotifier = ValueNotifier<String>('');

  bool isCompleted = false;
  bool isResolved = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     final stockController= context.read<StockInventoryController>();
     stockController.clearTableRows();
     stockController.stockInventory();
    });
    print("======================================================ticketId${widget.ticketId}");
    print("======================================================ticketId${widget.jobUniqueId}");
    Future.microtask(() {
      final controller = Provider.of<TicketDetailsController>(context, listen: false);
      controller.newFetchTicketByDetails(widget.ticketId).then((_) {
        final status = controller.ticketDetails?.ticket?.ticketStatus ?? 'Scheduled';
        setState(() {
          isCompleted = status == 'Completed';
          isResolved = status == 'Unresolved';
          if (isCompleted || isResolved ) {

            _techRemarksNotifier.value = controller.ticketDetails?.updates!.last.remarks ?? '';
            _statusNotifier.value = status;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoController = Provider.of<TechnicianCameraProvider>(context, listen: false);
    // context.read<TicketDetailsController>().fetchTicketDetails(ticketId);
    // print('Fetching ticket details for ID: $ticketId');
    // final video = context.read<TechnicianCameraProvider>().recordedVideoPath;
    print('JobDetailsScreen initialized with ticketId: ${widget.ticketId} and jobUniqueId: ${widget.jobUniqueId}');
    // final controller = Provider.of<TicketDetailsController>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (controller.ticketDetails == null || controller.ticketDetails?.ticket?.ticketId != widget.ticketId) {
    //     controller.fetchTicketDetails(widget.ticketId);
    //   }
    // });

    return Consumer2<TicketDetailsController,StockInventoryController>(
        builder: (context, controller,controller1 ,child) {
          print('ticketDetails Fetched.....----${controller.isLoading}');
          final ticketDetails = controller.ticketDetails;
          print('ticketDetails Fetched...... $ticketDetails');

          return PopScope(
            onPopInvokedWithResult: (did, result) {
              if (did) {
                controller.setVideoPath('');
              }
            },
            child: Scaffold(
              backgroundColor: AppColor.primaryWhite,
              appBar: commonAppBar(
                context,
                showLeading: true,
                onBack: () {
                  controller.setVideoPath('');
                  context.pop();

                },
                title: 'Job id ${ticketDetails?.ticket?.jobId ??""}',
              ),
              body: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ticketDetails == null
                  ? const Center(child: CustomText(text: 'No data available.'))
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              final uniqueId = ticketDetails.userDetails?.uniqueId;

                              if (uniqueId != null && uniqueId.isNotEmpty) {
                                context.pushNamed(
                                  RouteName.reportedIssueScreen,
                                  pathParameters: {'uniqueId': ticketDetails.userDetails?.uniqueId ?? ''},
                                  extra: {
                                    "username": ticketDetails.userDetails?.username ?? '',
                                    "address": ticketDetails.userDetails?.address ?? '',
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Unique ID not found")),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                              decoration: BoxDecoration(
                                color:AppColor.greyE4E4E4,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomText(
                                text: ticketDetails.userDetails?.username.toString().toTitleCase()?? '',
                                fontSize: AppFontSize.s20,
                                fontWeight: AppFontWeight.w600,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                          10.width,
                          CustomText(
                            text: ticketDetails.userDetails?.createdDate.toString() ?? '',
                            color: AppColor.grey7C7C7C,
                            fontWeight: AppFontWeight.w600,
                            fontSize: AppFontSize.s12,
                          ),
                        ],
                      ),
                      10.height,
                      CustomText(
                        text: ticketDetails.userDetails?.address != null?ticketDetails.userDetails?.city?.toTitleCase():"",
                        fontSize: AppFontSize.s12,
                        color: AppColor.textColor000000,
                        fontWeight: AppFontWeight.w500,
                      ),
                      20.height,

                      /// STATUS DROPDOWN


                      ValueListenableBuilder(
                          valueListenable: _statusNotifier,
                          builder: (context,value, child) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColor.greyF7F7F7,
                                  boxShadow: greyBoxShadow()
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: 'Current Status',),
                                  // DropDown Button
                                  DropdownButton(
                                    value: value,
                                    underline: Container(),
                                    isExpanded: true,
                                    items: ['Scheduled','Completed', 'Unresolved'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: CustomText(
                                          text: value,
                                          fontSize: AppFontSize.s17,
                                          fontWeight: AppFontWeight.w600,
                                          color: AppColor.blackColor,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _statusNotifier.value = value;
                                      }


                                    },)
                                ],
                              ),
                            );
                          }
                      ),
                      20.height,

                      /// Job Card
                      Card(
                        color: AppColor.primaryWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: CustomText(
                                text:
                                'Job id ${ticketDetails.ticket?.jobId}',
                                fontWeight: AppFontWeight.w700,
                                fontSize: AppFontSize.s14,
                                color: AppColor.whiteE5EFFF,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: 'Work Type',
                                              color: AppColor.grey9D9D9D,
                                              fontWeight: AppFontWeight.w600,
                                              fontSize: AppFontSize.s12,
                                            ),
                                            5.height,
                                            CustomText(
                                              text: 'Repair',
                                              color: AppColor.textColor000000,
                                              fontWeight: AppFontWeight.w600,
                                              fontSize: AppFontSize.s14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()async{
                                          final userLocation = await controller.fetchLocation();
                                          print("=====================location$userLocation");
                                          print("===============================$ticketDetails" );
                                          print(ticketDetails.ticket!.locationLongitude  );
                                          if(ticketDetails.userDetails?.lotitude!=null && ticketDetails.userDetails?.langitude != null){
                                            context.pushNamed(
                                              RouteName.customerLocationView,
                                              extra: {
                                                'customerLong':double.parse(ticketDetails.userDetails!.lotitude.toString()),
                                                'customerLat':double.parse(ticketDetails.userDetails!.langitude.toString()),
                                                "employLong":userLocation.longitude,
                                                "employLat":userLocation.latitude
                                              },
                                            );
                                          }else{
                                            showSnackBar(context, "Location No Assign");
                                          }
                                        },
                                        child: Icon(
                                          Icons.location_on,
                                          color: AppColor.primaryColor,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  10.height,
                                  CustomText(
                                    text: 'Work Request',
                                    color: AppColor.grey9D9D9D,
                                    fontWeight: AppFontWeight.w600,
                                    fontSize: AppFontSize.s12,
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text: ticketDetails.ticket?.problems?.toString() ?? 'No issues reported',
                                          color: AppColor.textColor000000,
                                          fontWeight: AppFontWeight.w600,
                                          fontSize: AppFontSize.s15,
                                          maxLines: 2,
                                          textOverflow: TextOverflow.visible,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerScreen(
                                                        videoUrl: ticketDetails
                                                            .ticket
                                                            ?.video?.trim() ??
                                                            '',
                                                      )));
                                        },
                                        child: CustomText(
                                          text: 'View video',
                                          color: AppColor.blue3E39FE,
                                          fontSize: AppFontSize.s14,
                                          fontWeight: AppFontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      20.height,
                      CustomText(
                        text: 'Service Notes',
                        fontSize: AppFontSize.s12,
                        fontWeight: AppFontWeight.w600,
                        color: AppColor.textColor000000,
                      ),
                      10.height,
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primaryWhite,
                          border: Border.all(
                            color:
                            AppColor.greyE4E4E4.withValues(alpha: 0.7),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomText(
                            text: ticketDetails.ticket?.comments?.toString() ?? 'No comments available',
                            fontWeight: AppFontWeight.w500,
                            fontSize: AppFontSize.s13,
                            color: AppColor.grey7C7C7C,
                          ),
                        ),

                      ),

                      20.height,
                      if (!isCompleted && !isResolved)
                      Consumer<StockInventoryController>(
                        builder: (context, controller, _) {
                          if (controller.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final stocks = controller.stockInventoryModel?.data?.stocks ?? [];
                          if (stocks.isEmpty) {
                            return const Text("No stock available");
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Table Header
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  spacing: 15,
                                  children: [
                                    Expanded(flex: 3, child: CustomText(
                                      maxLines: 2,
                                        softWrap: false,
                                        text:"Item Name", fontWeight:AppFontWeight.w500,fontSize: AppFontSize.s10)),
                                    Expanded(flex: 3, child: CustomText(
                                        maxLines: 1,
                                        softWrap: false,
                                        text:"Quantity", fontWeight:AppFontWeight.w500,fontSize: AppFontSize.s10)),
                                    Expanded(flex: 3, child: CustomText(
                                      maxLines: 1,
                                      softWrap: false,
                                        text:"Measure", fontWeight:AppFontWeight.w500,fontSize: AppFontSize.s10)),
                                    Expanded(flex: 2, child: CustomText(
                                        maxLines: 2,
                                        softWrap: false,
                                        text:"Used Qty", fontWeight:AppFontWeight.w500,fontSize: AppFontSize.s10)),
                                    Expanded(flex: 2, child: CustomText(
                                      maxLines: 1,
                                        softWrap: false,
                                        text:"Action", fontWeight:AppFontWeight.w500,fontSize: AppFontSize.s10)),
                                  ],
                                ),
                              ),

                              /// Table Rows
                              ...controller.tableRows.asMap().entries.map((entry) {
                                int index = entry.key;
                                var row = entry.value;

                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          // Item Name Dropdown
                                          Expanded(
                                            flex: 3,
                                            child: DropdownButtonFormField<StockInventoryModel>(
                                              value: row['stock'],
                                              hint: const Text(
                                                maxLines: 1,
                                                  softWrap: false,
                                                  "Select Item", style: TextStyle(fontSize: 9)),
                                              isExpanded: true,
                                              items: stocks
                                                  .where((s) => !controller.tableRows.any((r) => r['stock']?.itemName == s.itemName && r != row))
                                                  .map((stock) => DropdownMenuItem(
                                                value: stock,
                                                child: CustomText(
                                                  maxLines: 1,
                                                  text:stock.itemName ?? "",fontSize: AppFontSize.s8,),
                                              ))
                                                  .toList(),
                                              onChanged: (val) {
                                                row['stock'] = val;
                                                row['qtyController'].clear();
                                                controller.updateRow();
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                              ),
                                            ),
                                          ),

                                          20.width,

                                          // Available Quantity
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(text:row['stock'] != null ? "${row['stock']!.availableStock}" : "-"),
                                          ),



                                          // Measure
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              maxLines: 1,
                                                softWrap: false,
                                                text:row['stock'] != null ? row['stock']!.measureName ?? "-" : "-"),
                                          ),


                                          // Used Quantity
                                          Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: row['qtyController'],
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                                hintText: "Qty",
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: IconButton(
                                              icon:  Icon(Icons.close, color: Colors.red),
                                              onPressed: () {
                                                controller.removeTableRow(index);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Row Buttons

                                  ],
                                );
                              }).toList(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.addTableRow();
                                    },
                                    child:  CustomText(text:"Add more"),
                                    style: ElevatedButton.styleFrom(minimumSize: const Size(40, 20)),
                                  ),
                                ],
                              ),

                             5.height,

                            ],
                          );
                        },
                      ),
                      if (!isCompleted && !isResolved)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.primaryWhite,
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'Title', fontWeight: AppFontWeight.w600),
                              TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: 'Enter title',
                                ),
                              ),
                            ],
                          ),
                        ),
                      10.height,

                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: 'Technician Remarks',
                              fontSize: AppFontSize.s12,
                              fontWeight: AppFontWeight.w600,
                              color: AppColor.textColor000000,
                            ),
                          ),
                          if (!isCompleted && !isResolved)
                          InkWell(
                            onTap: () => _showRemarksBottomSheet(context),
                            child: CustomText(
                              text: '+ Add notes',
                              fontSize: AppFontSize.s14,
                              fontWeight: AppFontWeight.w600,
                              color: AppColor.blue18338E,
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _techRemarksNotifier,
                        builder: (_, remarks, __) {
                          if (remarks.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primaryWhite,
                              border: Border.all(
                                color: AppColor.greyE4E4E4
                                    .withValues(alpha: 0.7),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomText(
                                text: remarks,
                                fontWeight: AppFontWeight.w500,
                                fontSize: AppFontSize.s13,
                                color: AppColor.grey7C7C7C,
                              ),
                            ),
                          );
                        },
                      ),



                      30.height,
                      Row(
                        mainAxisAlignment:controller.videoPath==null||controller.videoPath!.isEmpty? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                        children: [
                          if(controller.videoPath!=null && controller.videoPath!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Video attached',
                                  fontSize: AppFontSize.s12,
                                  fontWeight: AppFontWeight.w600,
                                  color: AppColor.textColor000000,
                                ),
                                5.height,
                                CustomText(
                                  text: controller.videoPath.toString().split('/').last,
                                  fontSize: AppFontSize.s10,
                                  fontWeight: AppFontWeight.w500,
                                  color: AppColor.grey7C7C7C,
                                ),
                              ],
                            ),
                          if (!isCompleted && !isResolved)
                          InkWell(
                            onTap: () {
                              // context.pushNamed(
                              //     RouteName.technicianRecordingScreen);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => TechnicianRecordingScreen(),
                              ));
                            },
                            child: CustomText(
                              text: 'Add Attachments',
                              fontSize: AppFontSize.s12,
                              fontWeight: AppFontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if ((isCompleted || isResolved) &&
                          ((controller.videoPath != null && controller.videoPath!.isNotEmpty) ||
                              (ticketDetails.updates != null &&
                                  ticketDetails.updates!.isNotEmpty &&
                                  ticketDetails.updates!.last.video != null &&
                                  ticketDetails.updates!.last.video!.isNotEmpty)))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.height,
                            CustomText(
                              text: 'Attached video',
                              fontSize: AppFontSize.s12,
                              fontWeight: AppFontWeight.w600,
                              color: AppColor.textColor000000,
                            ),
                            5.height,
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
                                          text:"Date:${(ticketDetails.updates != null && ticketDetails.updates!.isNotEmpty)
                                              ? (ticketDetails.updates!.last.updatedDate?.toString() ?? 'No date')
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
                            // CustomText(
                            //   text: controller.videoPath != null && controller.videoPath!.isNotEmpty
                            //       ? controller.videoPath!.split('/').last
                            //       : ticketDetails.updates!.last.video!.split('/').last,
                            //   fontSize: AppFontSize.s10,
                            //   fontWeight: AppFontWeight.w500,
                            //   color: AppColor.grey7C7C7C,
                            // ),
                          ],
                        ),


                     20.height,
                      if (!isCompleted && !isResolved)
                      Column(
                        children: [
                          AppButton(
                            text: 'Close Ticket',
                            height: 45,
                            color: AppColor.primaryColor,
                            fontSize: AppFontSize.s18,
                            onPressed: isCompleted
                                ? null
                                : () async {
                              List<String> employeeStockUniqueIds = [];
                              List<String> usedItemQty = [];
                              bool hasError = false;

                              for (var row in controller1.tableRows) {
                                final stock = row['stock'] as StockInventoryModel?;
                                final qtyText = row['qtyController'].text.trim();

                                if (stock == null || qtyText.isEmpty) {
                                  hasError = true;
                                  break;
                                }
                                final qtyInt = int.tryParse(qtyText);

                                if (qtyInt == null || qtyInt <= 0) {
                                  hasError = true;
                                  break;
                                }

                                if (qtyInt > (stock.availableStock ?? 0)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Invalid quantity for ${stock.itemName}. Available: ${stock.availableStock}",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                employeeStockUniqueIds.add(stock.stockUniqueId ?? '');
                                usedItemQty.add(qtyText);
                              }

                              if (hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select item and enter valid quantity for all rows",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final videoPath = controller.videoPath;
                              final userId = SharedPrefService().getUserId();

                              // Validation checks
                              if (_statusNotifier.value == 'Scheduled') {
                                showSnackBar(context, 'Please select Status');
                                return;
                              } else if (_techRemarksNotifier.value.isEmpty) {
                                showSnackBar(context, 'Please add Technician Remarks');
                                return;
                              } else if (videoPath == null || videoPath.isEmpty) {
                                showSnackBar(context, 'Please record a video');
                                return;
                              } else if (userId == null) {
                                showSnackBar(context, 'User ID not found');
                                return;
                              }

                              try {
                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                );

                                // API call
                                await controller.updateTicketByTechnician(
                                  TicketStatusUpdateRequest(
                                    ticketId: ticketDetails.ticket?.uniqueId.toString() ?? '',
                                    jobId: widget.jobUniqueId,
                                    employeeStockUniqueIds: employeeStockUniqueIds,
                                    usedItemQty: usedItemQty,
                                    remark: _techRemarksNotifier.value.toString(),
                                    ticketStatus: _statusNotifier.value.toString(),
                                    userId: userId.toString(),
                                    video: File(videoPath),
                                    title: _titleController.text.trim(),
                                  ),
                                );
                                print('================================================================================Request Payload: ${({
                                  'ticketId': ticketDetails.ticket?.uniqueId ?? '',
                                  'jobId': widget.jobUniqueId,
                                  'employeeStockUniqueIds': employeeStockUniqueIds,
                                  'usedItemQty': usedItemQty,
                                  'remark': _techRemarksNotifier.value,
                                  'ticketStatus': _statusNotifier.value,
                                  'userId': userId,
                                  'title': _titleController.text.trim(),
                                })}');

                                // Clear video + cache
                                controller.setVideoPath('');
                                await videoController.clearCache();

                                // Close dialogs
                                if (context.mounted) {
                                  Navigator.of(context).pop(); // close loader
                                  // Send back the updated ticket info
                                  Navigator.of(context).pop({
                                    'ticketId': widget.ticketId,
                                    'status': _statusNotifier.value,
                                  });
                                }

                                // Show success
                                if (context.mounted) {
                                  showSnackBar(context, 'Ticket Closed Successfully');
                                }

                                // Navigate to dashboard
                                if (context.mounted) {
                                  context.pushReplacementNamed(
                                    RouteName.dashboardScreen,
                                    pathParameters: {'userType': 'worker'},
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) Navigator.of(context).pop();
                                if (context.mounted) {
                                  showSnackBar(context, 'Error closing ticket: ${e.toString()}');
                                }
                                debugPrint('Error closing ticket: $e');
                              }
                            },
                          )
                        ],
                      ),
                      20.height
                    ],

                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showRemarksBottomSheet(BuildContext context) {
    final TextEditingController remarksController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: AppColor.primaryWhite,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  text: 'Technician Remark',
                  fontWeight: AppFontWeight.w700,
                  fontSize: AppFontSize.s16,
                  color: AppColor.textColor000000,
                ),
              ),
              15.height,
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your remark here',
                  filled: true,
                  fillColor: AppColor.greyF7F7F7,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: AppColor.textColor000000.withValues(alpha: 0.2)),
                  ),
                ),
              ),
              20.height,
              ValueListenableBuilder(
                  valueListenable: _techRemarksNotifier,
                  builder: (context,value,child) {
                    return Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Cancel',
                            height: 45,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        10.width,
                        Expanded(
                          child: AppButton(
                            text: 'Save',
                            height: 45,
                            onPressed: () {
                              if (remarksController.text.trim().isNotEmpty) {
                                _techRemarksNotifier.value =
                                    remarksController.text.trim();
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ],
          ),
        );
      },
    );
  }
}