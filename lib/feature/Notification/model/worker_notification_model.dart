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

final List<NotificationModel> workerNotifications = [
  NotificationModel(
    title: "New Job Assigned",
    ticketId: "123456",
    status: "Scheduled",
  ),
  NotificationModel(
    title: "Ticket Closed Successfully",
    ticketId: "987654",
    status: "Completed",
  ),
  NotificationModel(
    title: " Service Marked as Unresolved",
    ticketId: "987654",
    status: "Unresolved",
  ),
];
