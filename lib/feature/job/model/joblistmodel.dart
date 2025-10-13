
import '../../Ticket/model/ticket_by_id_response.dart';

class JobModel {
  final String jobId;
  final String jobTitle;
  final String address;
  final String time;
  final DateTime date;
  final String jobStatus;

  JobModel({
    required this.jobId,
    required this.jobTitle,
    required this.address,
    required this.time,
    required this.date,
    required this.jobStatus,
  });

  factory JobModel.fromTicket(TicketByIdResponse ticket) {
    return JobModel(
      jobId: ticket.jobId,
      jobTitle: ticket.problems,
      address: ticket.comments,
      jobStatus: ticket.ticketStatus,
      time: ticket.createdDate.split(" ").last,
      date: DateTime.tryParse(ticket.createdDate.split(" ").first) ?? DateTime.now(),
    );
  }
}
