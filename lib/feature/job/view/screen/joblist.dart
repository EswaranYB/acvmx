
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/core/routes/route_name.dart';
import 'package:acvmx/feature/job/model/joblistmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/sharedpreferences/sharedpreferences_services.dart';
import '../../../Dashboard/view/widgets/appbar.dart';
import '../../../Ticket/controller/get_ticket_by_technician_controller.dart';
import '../../controller/joblist_provider.dart';
import '../../model/job_model.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobListProvider>(context);
    final ticketController = Provider.of<GetTicketByTechnicianController>(context,listen: false);
    final userId = SharedPrefService().getUserId();


    ticketController.getTicketByTechnicianApiCall(context,userId!);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pushNamed(
            RouteName.dashboardScreen,
            pathParameters: {'userType': 'worker'},
            queryParameters: {'tab': '0'},
          );
        }
      },

      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColor.primaryWhite,
          appBar: commonAppBar(context, title: "Job List", showLeading: true),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: jobProvider.selectedDate,
                  selectedDayPredicate: (day) => isSameDay(jobProvider.selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    jobProvider.setSelectedDate(selectedDay);
                  },
                  eventLoader: (day) {
                    final normalized = DateTime(day.year, day.month, day.day);
                    return jobProvider.jobsByDate[normalized] ?? [];
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor000000,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: AppColor.primaryColor),
                    rightChevronIcon: Icon(Icons.chevron_right, color: AppColor.primaryColor),
                  ),
                  calendarFormat: CalendarFormat.month,
                  availableGestures: AvailableGestures.all,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    markersAlignment: Alignment.bottomCenter,
                    markerSize: 5.0,
                    weekendTextStyle: TextStyle(
                      color: AppColor.statusRed,
                    ),
                  ),
                ),
                10.height,
                Divider(height: 5),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "${jobProvider.selectedDate.day}",
                              fontSize: AppFontSize.s24,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text: _monthName(jobProvider.selectedDate.month),
                              fontSize: AppFontSize.s16,
                              fontWeight: FontWeight.bold,
                            ),
                            f14(
                              text: _weekDayName(jobProvider.selectedDate.weekday),
                              color: AppColor.grey7C7C7C,
                            ),
                          ],
                        ),
                      ),
                      5.width,
                      Expanded(
                        child: jobProvider.jobsForSelectedDate.isEmpty
                            ? Center(
                          child: f14(
                            text: "No jobs found",
                            color: AppColor.grey7C7C7C,
                          ),
                        )
                            : ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: jobProvider.jobsForSelectedDate.length,
                          itemBuilder: (context, index) {
                            final job = jobProvider.jobsForSelectedDate[index];
                            return _jobCard(context, job);
                          },
                        ),
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

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _weekDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  Widget _jobCard(BuildContext context, JobModel job) {
    return Card(
      color: AppColor.primaryWhite,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColor.primaryColor, width: 5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work_outline, size: 20),
                      5.width,
                      f14(text: "Job ID ${job.jobId}", fontWeight: FontWeight.w500),
                    ],
                  ),
                  f14(text: job.time, fontWeight: FontWeight.bold),
                ],
              ),
              6.height,
              f16(fontWeight: FontWeight.bold, text: job.jobTitle),
              4.height,
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: AppColor.blackColor),
                  8.width,
                  Expanded(
                    child: f14(text: job.address, color: AppColor.grey7C7C7C),
                  ),
                ],
              ),
              5.height,
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    context.pushNamed(
                      RouteName.jobDetailsScreen,
                      pathParameters: {},
                      extra: job,
                    );
                  },
                  child: f14(text: "View Details", color: AppColor.blue3E39FE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}