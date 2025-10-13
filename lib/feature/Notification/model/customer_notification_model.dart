// class NotificationModel {
//   final String title;
//   final String ticketId;
//   final bool isSuccess;
//
//   NotificationModel({
//     required this.title,
//     required this.ticketId,
//     required this.isSuccess,
//   });
// }
//
// final List<NotificationModel> customerNotifications = [
//   NotificationModel(
//     title: "Service Appointment Confirmed",
//     ticketId: "654321",
//     isSuccess: true,
//   ),
//   NotificationModel(
//     title: "Service Rescheduled",
//     ticketId: "112233",
//     isSuccess: false,
//   ),
// ];
class NotificationModel {
  final String title;
  final String ticketId;
  final String status; // New status field

  NotificationModel({
    required this.title,
    required this.ticketId,
    required this.status,
  });
}

final List<NotificationModel> customerNotifications = [
  NotificationModel(
    title: "Ticket Closed Successfully",
    ticketId: "221336",
    status: "Completed",
  ),
  NotificationModel(
    title: "Service Marked as Unresolved",
    ticketId: "221337",
    status: "Unresolved",
  ),
  NotificationModel(
    title: "Ticket Raised Successfully",
    ticketId: "221338",
    status: "Scheduled",
  ),
];
