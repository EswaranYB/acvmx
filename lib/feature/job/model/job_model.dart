// class JobListModel {
//   final String jobId;
//   final String jobTitle;
//   final String address;
//   final DateTime date; // changed from String to DateTime
//   final String time;
//   final String workstatus;
//   final String statusColor;
//   final String? jobType;
//   final String? customerName;
//   final String? serviceNotes;
//   final String? technicianNotes;
//   final String? customerStatus;
//
//   JobListModel({
//     required this.jobId,
//     required this.jobTitle,
//     required this.address,
//     required this.date,
//     required this.time,
//     required this.workstatus,
//     required this.statusColor,
//     this.jobType,
//     this.customerName,
//     this.serviceNotes,
//     this.technicianNotes,
//     this.customerStatus,
//   });
//
//   factory JobListModel.fromJson(Map<String, dynamic> json) {
//     return JobListModel(
//       jobId: json['jobId'] ?? '',
//       jobTitle: json['jobTitle'] ?? '',
//       address: json['address'] ?? '',
//       date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(), // updated
//       time: json['time'] ?? '',
//       workstatus: json['status'] ?? '',
//       statusColor: json['statusColor'] ?? 'blue',
//       jobType: json['jobType'],
//       customerName: json['customerName'],
//       serviceNotes: json['serviceNotes'],
//       technicianNotes: json['technicianNotes'],
//       customerStatus: json['customerStatus'] ?? 'inactive',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'jobId': jobId,
//       'jobTitle': jobTitle,
//       'address': address,
//       'date': date.toIso8601String(), // updated
//       'time': time,
//       'status': workstatus,
//       'statusColor': statusColor,
//       'jobType': jobType,
//       'customerName': customerName,
//       'serviceNotes': serviceNotes,
//       'technicianNotes': technicianNotes,
//       'customerStatus': customerStatus,
//     };
//   }
// }
// final List<JobListModel> sampleJobs = [
//   JobListModel(
//     jobId: '221334',
//     jobTitle: 'Repair and Maintenance',
//     address: '123, Baker Street, London',
//     date: DateTime(2025, 5, 30), // updated
//     time: '12:00PM',
//     workstatus: 'Completed',
//     statusColor: 'green',
//     jobType: 'Service',
//     customerName: 'Kathy Taylor',
//     serviceNotes: 'Replaced faulty dispenser motor. Cleaned brew unit thoroughly. Checked water inlet valve function. Test run successful after repair.',
//     technicianNotes: 'Identified motor burnout due to overload. No other components damaged. Recalibrated temperature settings. Recommended monthly maintenance.',
//     customerStatus: 'Part Replaced',
//   ),
//   JobListModel(
//     jobId: '221335',
//     jobTitle: 'Installation and Maintenance ',
//     address: '456, Elm Street, New York',
//     date: DateTime(2025, 5, 15), // updated
//     time: '12:00PM',
//     workstatus: 'Unresolved',
//     statusColor: 'red',
//     jobType: 'Service',
//     customerName: 'James Wan',
//     serviceNotes: 'Initial diagnostics pending. No access to internal modules. Customer unavailable for demonstration. Rescheduled service suggested.',
//     technicianNotes: 'Could not proceed without client. External unit inspection looks fine. Left a service note at premises. Follow-up call required.',
//     customerStatus: 'Customer Not Available',
//   ),
//   JobListModel(
//     jobId: '221336',
//     jobTitle: 'Installation and Maintenance',
//     address: '789, Sunset Blvd, Los Angeles',
//     date: DateTime(2025, 5, 29), // updated
//     time: '12:00PM',
//     workstatus: 'Scheduled',
//     statusColor: 'blue',
//     jobType: 'Service',
//     customerName: 'Kathy Taylor',
//     customerStatus: 'Active',
//   ),
//   JobListModel(
//     jobId: '221337',
//     jobTitle: 'Installation and Maintenance',
//     address: '789, Sunset Blvd, Los Angeles',
//     date: DateTime(2025, 5, 27), // updated
//     time: '12:00PM',
//     workstatus: 'Scheduled',
//     statusColor: 'blue',
//     jobType: 'Service',
//     customerName: 'Kathy Taylor',
//     customerStatus: 'Active',
//   ),
// ];