// import 'package:acvmx/core/app_decoration.dart';
// import 'package:acvmx/core/responsive.dart';
// import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
// import 'package:acvmx/feature/profile/controller/get_user_details_controller.dart';
// import 'package:acvmx/feature/profile/model/reported_issue_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// // import 'package:go_router/go_router.dart';
// import '../../../../core/app_colors.dart';
// import '../../../../core/appbutton.dart';
// import '../../../../core/custom_text.dart';
//
// class ReportedIssue extends StatelessWidget {
//   final String userId;
//
//   ReportedIssue({super.key, required this.userId});
//
//   final List<ReportedIssueModel> reportlist = [
//     ReportedIssueModel(
//       ticketId: '221334',
//       title: 'Installation and Maintenance',
//       date: '22 Aug 21',
//       time: '12:00 PM ',
//       workStatus: 'Scheduled',
//     ),
//     ReportedIssueModel(
//       ticketId: '221334',
//       title: 'Installation and Maintenance',
//       date: '22 Aug 21',
//       time: '12:00 PM ',
//       workStatus: 'Completed',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//       final controller =
//           Provider.of<GetUserDetailsProvider>(context, listen: false);
//       if (userId.isNotEmpty) {
//         controller.getUserDetailsApiCall(userId);
//       }
//     });
//     // print('User ID: $userId'); // Debugging line to check userId
//     return Consumer<GetUserDetailsProvider>(
//       builder: (context, controller, child) {
//         final userDetails = controller.userDetailsByIdResponse;
//         return PopScope(
//           canPop: true, // This disables back navigation
//           child: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
//             child: Scaffold(
//               backgroundColor: AppColor.primaryWhite,
//               appBar: commonAppBar(context,
//                   showLeading: true, title: 'Customer Profile'),
//               body: controller.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : userDetails == null
//                   ? const Center(child: CustomText(text: 'No data available.'))
//                   : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: "Customer's Profile",
//                         fontSize: AppFontSize.s16,
//                         fontWeight: AppFontWeight.w600,
//                       ),
//                       20.height,
//                       Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: AppColor.primaryWhite,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColor.grey7C7C7C,
//                               blurRadius: 5,
//                               spreadRadius: 1,
//                               offset: Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: CustomText(
//                                     text: "Name",
//                                     fontSize: AppFontSize.s12,
//                                     fontWeight: AppFontWeight.w400,
//                                     color: AppColor.grey7C7C7C,
//                                   ),
//                                 ),
//                                 5.width,
//                                 Expanded(
//                                   flex: 3,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 12),
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: AppColor.greyF7F7F7,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: CustomText(
//                                       text: "${userDetails.firstName?.toTitleCase()} ${userDetails.lastName?.toTitleCase()}",
//                                       fontSize: AppFontSize.s14,
//                                       fontWeight: AppFontWeight.w600,
//                                       color: AppColor.textColor000000,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             15.height,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: CustomText(
//                                     text: "Address",
//                                     fontSize: AppFontSize.s12,
//                                     fontWeight: AppFontWeight.w400,
//                                     color: AppColor.grey7C7C7C,
//                                   ),
//                                 ),
//                                 10.width,
//                                 Expanded(
//                                   flex: 3,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 12),
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: AppColor.greyF7F7F7,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: CustomText(
//                                       text:  userDetails.address != null?userDetails.city?.toTitleCase():"",
//                                       fontSize: AppFontSize.s14,
//                                       fontWeight: AppFontWeight.w600,
//                                       color: AppColor.textColor000000,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       20.height,
//                       CustomText(
//                         text: "Reported Issues",
//                         fontSize: AppFontSize.s16,
//                         fontWeight: AppFontWeight.w600,
//                       ),
//                       10.height,
//                       ListView.separated(
//                         separatorBuilder:  (_, __) => 15.height,
//                         padding: const EdgeInsets.symmetric(vertical: 5),
//                         itemCount:userDetails.tickets?.length ?? 0,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           return Card(
//                             color: AppColor.primaryWhite,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               side: BorderSide(
//                                 color:
//                                     AppColor.textColor000000.withValues(alpha: 0.2),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.shopping_bag_outlined),
//                                         onPressed: () {},
//                                       ),
//                                       Expanded(
//                                         child: CustomText(
//                                           text: userDetails.tickets![index].ticketId ?? 'N/A',
//                                           fontSize: AppFontSize.s14,
//                                           color: AppColor.textColor000000,
//                                           fontWeight: AppFontWeight.w500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   8.height,
//                                   CustomText(
//                                     text: userDetails.tickets![index].problems?.toTitleCase() ?? 'No issues reported',
//                                     fontSize: AppFontSize.s16,
//                                     color: AppColor.textColor000000,
//                                     fontWeight: AppFontWeight.w600,
//                                   ),
//                                   8.height,
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 8,
//                                         height: 8,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color:userDetails.tickets?[index].ticketStatus == 'Completed'
//                                               ? AppColor.statusGreen
//                                               : userDetails.tickets?[index].ticketStatus == 'UnResolved'
//                                                   ? AppColor.statusRed
//                                                   : AppColor.statusBlue,
//                                         ),
//                                       ),
//                                       8.width,
//                                       CustomText(
//                                         text:
//                                             '${userDetails.tickets?[index].ticketStatus} - ${userDetails.tickets?[index].createdDate?.toLocal().toIso8601String().substring(0, 10)}',
//                                         fontSize: AppFontSize.s14,
//                                         color: AppColor.textColor000000,
//                                         fontWeight: AppFontWeight.w600,
//                                       ),
//                                     ],
//                                   ),
//                                   8.height,
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: AppButton(
//                                       height: 24,
//                                       width: 48,
//                                       text: 'View',
//                                       color: AppColor.ticketraisedbutton,
//                                       textColor: AppColor.service,
//                                       onPressed: () {
//                                        showSnackBar(context, 'This feature is under development');
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     );
//   }
// }
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:acvmx/feature/profile/controller/get_user_details_controller.dart';
import 'package:acvmx/feature/profile/model/reported_issue_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import 'package:go_router/go_router.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/appbutton.dart';
import '../../../../core/custom_text.dart';
import '../../controller/get_employee_controller.dart';

class ReportedIssue extends StatefulWidget {
  final String username;
  final String address;
  final String uniqueId;
   ReportedIssue({Key? key, required this.username, required this.address, required this.uniqueId}) : super(key: key);

  @override
  State<ReportedIssue> createState() => _ReportedIssue();
}
class _ReportedIssue extends State<ReportedIssue> {
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GetEmployeeController>(context, listen: false)
          .getEmployeeDetails(widget.uniqueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetEmployeeController>(
        builder: (context, provider, child) {
          final tickets = provider.userDetailsResponse?.data?.tickets ?? [];
          return PopScope(
            canPop: true, // This disables back navigation
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
              child: Scaffold(
                backgroundColor: AppColor.primaryWhite,
                appBar: commonAppBar(context,
                    showLeading: true, title: 'Customer Profile'),
                body: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : tickets == null
                    ? const Center(child: CustomText(text: 'No data available.'))
                    : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Customer's Profile",
                          fontSize: AppFontSize.s16,
                          fontWeight: AppFontWeight.w600,
                        ),
                        20.height,
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColor.primaryWhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.grey7C7C7C,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: "Name",
                                      fontSize: AppFontSize.s12,
                                      fontWeight: AppFontWeight.w400,
                                      color: AppColor.grey7C7C7C,
                                    ),
                                  ),
                                  5.width,
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColor.greyF7F7F7,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomText(
                                        text: widget.username,
                                        fontSize: AppFontSize.s14,
                                        fontWeight: AppFontWeight.w600,
                                        color: AppColor.textColor000000,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              15.height,
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: "Address",
                                      fontSize: AppFontSize.s12,
                                      fontWeight: AppFontWeight.w400,
                                      color: AppColor.grey7C7C7C,
                                    ),
                                  ),
                                  10.width,
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColor.greyF7F7F7,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomText(
                                        text: widget.address ,
                                        fontSize: AppFontSize.s14,
                                        fontWeight: AppFontWeight.w600,
                                        color: AppColor.textColor000000,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        20.height,
                        CustomText(
                          text: "Reported Issues",
                          fontSize: AppFontSize.s16,
                          fontWeight: AppFontWeight.w600,
                        ),
                        10.height,
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          itemCount: tickets.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final ticket = tickets[index];
                              return Card(
                                color: AppColor.primaryWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color:
                                    AppColor.textColor000000.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.shopping_bag_outlined),
                                            onPressed: () {},
                                          ),
                                          Expanded(
                                            child: CustomText(
                                              text:ticket.ticketId,
                                              fontSize: AppFontSize.s14,
                                              color: AppColor.textColor000000,
                                              fontWeight: AppFontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      8.height,
                                      CustomText(
                                        text: ticket.problems ?? 'No issues reported',
                                        fontSize: AppFontSize.s16,
                                        color: AppColor.textColor000000,
                                        fontWeight: AppFontWeight.w600,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:ticket.ticketStatus== 'Completed'
                                                  ? AppColor.statusGreen
                                                  : ticket.ticketStatus == 'UnResolved'
                                                  ? AppColor.statusRed
                                                  : AppColor.statusBlue,
                                            ),
                                          ),
                                          CustomText(
                                            text:
                                            '${ticket.ticketStatus} - ${DateFormat('dd MMM yy,hh:mm a')
                                                .format(ticket.createdDate!.toLocal())}',
                                            fontSize: AppFontSize.s14,
                                            color: AppColor.textColor000000,
                                            fontWeight: AppFontWeight.w600,
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },


                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

