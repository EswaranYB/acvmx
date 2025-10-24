import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/appbutton.dart';
import '../../../../core/routes/route_name.dart';
import '../../../Ticket/controller/get_ticket_by_technician_controller.dart';
import '../../controller/ticket_status_update_controller.dart';
import '../../model/ticket_status_update_model.dart';
import 'jobdetails.dart';

class RecentJobs extends StatefulWidget {
  const RecentJobs({super.key});

  @override
  State<RecentJobs> createState() => _RecentJobsState();
}

class _RecentJobsState extends State<RecentJobs> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<bool?> jobAcceptStatus = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final statusController = context.read<TicketStatusUpdateController>();
      await Future.delayed(const Duration(milliseconds: 300)); // wait for prefs load
      _initializeJobStatusFromAPI();
    });
  }

  Future<void> _initializeJobStatusFromAPI() async {
    final provider = context.read<GetTicketByTechnicianController>();
    final statusController = context.read<TicketStatusUpdateController>();

    if (provider.ticketByTechnician.isNotEmpty) {
      // Initialize all jobs to null first
      jobAcceptStatus = List<bool?>.filled(provider.ticketByTechnician.length, null);

      for (int i = 0; i < provider.ticketByTechnician.length; i++) {
        final job = provider.ticketByTechnician[i];
        final lastStatus = statusController.getSavedJobStatus(job.uniqueId);

        if (lastStatus != null) {
          if (lastStatus.toLowerCase() == "accept") jobAcceptStatus[i] = true;
          else if (lastStatus.toLowerCase() == "reject") jobAcceptStatus[i] = false;
          else jobAcceptStatus[i] = null; // scheduled or unknown
        }
      }

      if (mounted) setState(() {}); // Refresh UI
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.pushNamed(
          RouteName.dashboardScreen,
          pathParameters: {'userType': 'worker'},
          queryParameters: {'tab': '0'},
        );
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColor.primaryWhite,
          appBar: commonAppBar(
            title: 'Recent Job',
            context,
            showLeading: false,
            actions: [
              IconButton(
                onPressed: () => _showFilterSheet(context),
                icon: SvgPicture.asset(
                  AppIcons.filtericon,
                  colorFilter: ColorFilter.mode(
                    AppColor.primaryWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          body: Consumer<GetTicketByTechnicianController>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
              } else {
                if (provider.ticketByTechnician.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No Jobs Found',
                      fontSize: AppFontSize.s16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                if (jobAcceptStatus.length != provider.ticketByTechnician.length) {
                  jobAcceptStatus = List<bool?>.filled(provider.ticketByTechnician.length, null);
                }

                return ListView.builder(
                  itemCount: provider.ticketByTechnician.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemBuilder: (context, index) {
                    final job = provider.ticketByTechnician[index];

                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Card(
                          color: AppColor.primaryWhite,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: AppColor.textColor000000.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_bag_outlined),
                                    8.width,
                                    f14(text: 'Job ID ${job.jobId}'),
                                    const Spacer(),
                                    AppButton(
                                      text: job.ticketStatus.toLowerCase() == 'scheduled' ? 'Service' : 'View',
                                      color: job.ticketStatus.toLowerCase() == 'scheduled'
                                          ? AppColor.ticketraisedbutton
                                          : AppColor.greyE4E4E4,
                                      textColor: job.ticketStatus.toLowerCase() == 'scheduled'
                                          ? AppColor.service
                                          : AppColor.textColor000000,
                                      onPressed: () async {
                                        // Navigate to JobDetailsScreen for all ticket types
                                        provider.setTicketId(job.uniqueId, job.jobUniqueId.toString());
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailsScreen(
                                              ticketId: job.uniqueId,
                                              jobUniqueId: job.jobUniqueId.toString(),
                                            ),
                                          ),
                                        );
                                        if (result != null && result['ticketId'] == job.uniqueId) {
                                          setState(() {
                                            job.ticketStatus = result['status']; // 'Completed' or the status returned
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                8.height,
                                f16(text: job.problems.toTitleCase()),
                                10.height,
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: job.ticketStatus == 'Completed'
                                            ? AppColor.statusGreen
                                            : job.ticketStatus == 'Scheduled'
                                            ? AppColor.statusBlue
                                            : AppColor.statusRed,
                                      ),
                                    ),
                                    5.width,
                                    f14(text: job.ticketStatus),
                                    5.width,
                                    f14(
                                      text: DateFormat('MMM dd, yyyy').format(
                                        DateTime.parse(job.createdDate),
                                      ),
                                    ),
                                    10.width,
                                    f14(
                                      text: DateFormat('hh:mm a').format(
                                        DateTime.parse(job.createdDate),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text: job.ticketStatus,
                                      fontSize: AppFontSize.s14,
                                      color: AppColor.customerStatus,
                                    ),
                                    Spacer(),
                                    if (job.ticketStatus.toLowerCase() == 'scheduled')
                                        Row(
                                          spacing: 8,
                                          children: [
                                            if (jobAcceptStatus[index] != true) ...[
                                              // Reject button
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() => jobAcceptStatus[index] = false);
                                                  final request = TicketUpdateRequest(
                                                    ticketId: job.ticketId,
                                                    status: "Reject", uniqueId:job.uniqueId,
                                                  );
                                                  try {
                                                    await context
                                                        .read<TicketStatusUpdateController>()
                                                        .updateTicketStatus(request);
                                                    showSnackBar(context, "Job Rejected Successfully");
                                                  } catch (e) {
                                                    setState(() => jobAcceptStatus[index] = null);
                                                    showSnackBar(context, "Failed to update status");
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: jobAcceptStatus[index] == false
                                                        ? Colors.red
                                                        : Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                    child: CustomText(
                                                      text: "Reject",
                                                      color: AppColor.blackColor,
                                                      fontSize: AppFontSize.s10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() => jobAcceptStatus[index] = null);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: jobAcceptStatus[index] == null
                                                        ? Colors.blue
                                                        : Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: CustomText(
                                                    text: "Scheduled",
                                                    color: AppColor.blackColor,
                                                    fontSize: AppFontSize.s10,
                                                  ),
                                                ),
                                              ),
                                            ],

                                            /// Accept button always shows (or you can hide if already accepted)
                                            if (jobAcceptStatus[index] != true)
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() => jobAcceptStatus[index] = true);
                                                  final request = TicketUpdateRequest(
                                                    ticketId: job.ticketId,
                                                    status: "Accept", uniqueId: job.uniqueId,
                                                  );
                                                  try {
                                                    await context
                                                        .read<TicketStatusUpdateController>()
                                                        .updateTicketStatus(request);
                                                    showSnackBar(context, "Job Accepted Successfully");
                                                  } catch (e) {
                                                    setState(() => jobAcceptStatus[index] = null);
                                                    showSnackBar(context, "Failed to update status");
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: CustomText(
                                                    text: "Accept",
                                                    color: AppColor.blackColor,
                                                    fontSize: AppFontSize.s10,
                                                  ),
                                                ),
                                              ),

                                            /// If job is accepted, you can optionally just show a green label
                                            if (jobAcceptStatus[index] == true)
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: CustomText(
                                                  text: "Accepted",
                                                  color: AppColor.primaryWhite,
                                                  fontSize: AppFontSize.s10,
                                                ),
                                              ),
                                          ],
                                        ),
                                  ],
                                ),
                                Row(
                                  children: [

                                           CustomText(
                                            text: 'Service Notes',
                                            fontSize: AppFontSize.s14,
                                            color: AppColor.statusBlue,

                                          ),
                                    10.width,
                          CustomText(
                                            text: 'Technician Remarks',
                                            fontSize: AppFontSize.s14,
                                            color: AppColor.statusBlue,

                                          ),],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

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
          child: Consumer<GetTicketByTechnicianController>(
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
                      f16(text: "Filter Jobs", fontWeight: FontWeight.w600),
                    ],
                  ),
                  30.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "Job Status",
                      fontSize: AppFontSize.s16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.height,
                  Row(
                    children: ['Scheduled', 'Completed', 'Unresolved'].map((status) {
                      final isSelected = controller.tempStatus == status;

                      Color getStatusColor(String status) {
                        switch (status) {
                          case 'Completed':
                            return Colors.green;
                          case 'Scheduled':
                            return Colors.blue;
                          case 'Unresolved':
                            return Colors.red;
                          default:
                            return AppColor.textColor000000;
                        }
                      }

                      final baseColor = getStatusColor(status);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setTempStatus(status),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: baseColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? baseColor : Colors.transparent,
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
                          onPressed: () => controller.setTempSortOrder('desc'),
                          color: controller.tempSortOrder == 'desc'
                              ? AppColor.primaryColor
                              : AppColor.greyE4E4E4,
                          child: Center(
                            child: CustomText(
                              text: 'Newest First',
                              fontWeight: FontWeight.w500,
                              color: controller.tempSortOrder == 'desc'
                                  ? AppColor.primaryWhite
                                  : AppColor.textColor000000,
                            ),
                          ),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: AppButton(
                          height: 37,
                          onPressed: () => controller.setTempSortOrder('asc'),
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
}