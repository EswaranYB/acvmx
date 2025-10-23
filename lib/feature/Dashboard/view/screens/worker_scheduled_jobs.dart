import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/appbutton.dart';
import '../../../../core/routes/route_name.dart';
import '../../../Ticket/controller/get_ticket_by_technician_controller.dart';
import '../../../job/controller/ticket_status_update_controller.dart';
import '../../../job/model/ticket_status_update_model.dart';
import '../../../job/view/screen/jobdetails.dart';

class WorkerScheduledJobs extends StatefulWidget {
  final String title;
  const WorkerScheduledJobs({super.key, required this.title});

  @override
  State<WorkerScheduledJobs> createState() => _WorkerScheduledJobsState();
}

class _WorkerScheduledJobsState extends State<WorkerScheduledJobs>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  /// Tracks accept/reject status of jobs by index; null means undecided
  List<bool?> jobAcceptStatus = [];

  @override
  void initState() {
    super.initState();

    // Setup animations
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
      await _fetchAndInitializeJobs();
    });
  }

Future<void> _fetchAndInitializeJobs() async {
  final ticketController = Provider.of<GetTicketByTechnicianController>(context, listen: false);
  final statusController = Provider.of<TicketStatusUpdateController>(context, listen: false);

  String type ='';
  switch (widget.title.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'),' ').trim()) {
    case 'Work allocated':
      type ='today';
      break;
    case 'Upcoming jobs':
      type = 'upcoming';
      break;
    case 'Overdue jobs':
      type = 'past';
      break;
    case 'Waiting for submission':
      type = 'waiting';
      break;
    default:
  }

  // Fetch scheduled jobs (past)
  await ticketController.fetchScheduledJobs(context, '6842b74489a8c', type);

  // ✅ Use parsed data from workerSheduledJobs instead of raw scheduledJobs
  final scheduledJobs = ticketController.workerSheduledJobs;

  // Initialize jobAcceptStatus with null values for all jobs
  jobAcceptStatus = List<bool?>.filled(scheduledJobs.length, null);

  for (int i = 0; i < scheduledJobs.length; i++) {
    final job = scheduledJobs[i];
    final savedStatus = statusController.getSavedJobStatus(job.uniqueId);

    if (savedStatus != null) {
      final statusLower = savedStatus.toLowerCase();
      if (statusLower == "accept") {
        jobAcceptStatus[i] = true;
      } else if (statusLower == "reject") {
        jobAcceptStatus[i] = false;
      } else {
        jobAcceptStatus[i] = null;
      }
    }
  }

  if (mounted) setState(() {});
}

  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to dashboard on back press
        context.pushNamed(
          RouteName.dashboardScreen,
          pathParameters: {'userType': 'worker'},
          queryParameters: {'tab': '0'},
        );
        return false; // prevent default back navigation
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColor.primaryWhite,
          appBar: commonAppBar(
            title: widget.title,
            context,
            showLeading: true,
          ),
          body: Consumer<GetTicketByTechnicianController>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

            final tickets = provider.workerSheduledJobs;


              if (tickets.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No Jobs Found',
                    fontSize: AppFontSize.s16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              // Make sure jobAcceptStatus list matches tickets length
              if (jobAcceptStatus.length != tickets.length) {
                jobAcceptStatus = List<bool?>.filled(tickets.length, null);
              }

              return ListView.builder(
                itemCount: tickets.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) {
                  final job = tickets[index];

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
                            color: AppColor.textColor000000.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job header with ID and button
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag_outlined),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Job ID ${job.jobId}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const Spacer(),
                                  AppButton(
                                    text: job.ticketStatus.toLowerCase() == 'scheduled'
                                        ? 'Service'
                                        : 'View',
                                    color: job.ticketStatus.toLowerCase() == 'scheduled'
                                        ? AppColor.ticketraisedbutton
                                        : AppColor.greyE4E4E4,
                                    textColor: job.ticketStatus.toLowerCase() == 'scheduled'
                                        ? AppColor.service
                                        : AppColor.textColor000000,
                                    onPressed: () async {
                                      provider.setTicketId(
                                          job.uniqueId, job.jobUniqueId.toString());
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => JobDetailsScreen(
                                            ticketId: job.uniqueId,
                                            jobUniqueId: job.jobUniqueId.toString(),
                                          ),
                                        ),
                                      );

                                      // Update ticket status locally if changed in details
                                      if (result != null &&
                                          result['ticketId'] == job.uniqueId) {
                                        setState(() {
                                          job.ticketStatus = result['status'];
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),

                              8.height,

                              // Job problem description
                              f16(text: job.problems.toTitleCase()),

                              10.height,

                              // Status indicator row
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

                              // Accept/Reject buttons for scheduled jobs
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
                              // Service Notes and Technician Remarks labels
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
            },
          ),
        ),
      ),
    );
  }
}
