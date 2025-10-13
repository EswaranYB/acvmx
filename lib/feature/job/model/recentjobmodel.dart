class RecentJobModel {
  final String jobId;
  final String title;
  final String date;
  final String time;
  final String customerStatus;
  final String workStatus;
  final String serviceNotes;
  final String technicianNotes;
  final String technician;
  final String technicianStatus;

  RecentJobModel({
    required this.jobId,
    required this.title,
    required this.date,
    required this.time,
    required this.customerStatus,
    required this.workStatus,
    required this.serviceNotes,
    required this.technicianNotes,
    required this.technician,
    required this.technicianStatus,
  });

  factory RecentJobModel.fromMap(Map<String, dynamic> map) {
    return RecentJobModel(
      jobId: map['jobId'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      customerStatus: map['customerStatus'],
      workStatus: map['workStatus'],
      serviceNotes: map['serviceNotes'],
      technicianNotes: map['technicianNotes'],
      technician: map['technician'],
      technicianStatus: map['technicianStatus'],
    );
  }

  RecentJobModel copyWith({
    String? jobId,
    String? title,
    String? date,
    String? time,
    String? customerStatus,
    String? workStatus,
    String? serviceNotes,
    String? technicianNotes,
    String? technician,
    String? technicianStatus,
  }) {
    return RecentJobModel(
      jobId: jobId ?? this.jobId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      customerStatus: customerStatus ?? this.customerStatus,
      workStatus: workStatus ?? this.workStatus,
      serviceNotes: serviceNotes ?? this.serviceNotes,
      technicianNotes: technicianNotes ?? this.technicianNotes,
      technician: technician ?? this.technician,
      technicianStatus: technicianStatus ?? this.technicianStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'title': title,
      'date': date,
      'time': time,
      'customerStatus': customerStatus,
      'workStatus': workStatus,
      'serviceNotes': serviceNotes,
      'technicianNotes': technicianNotes,
      'technician': technician,
      'technicianStatus': technicianStatus,
    };
  }

  /// 🔹 Dummy job list
  static List<RecentJobModel> dummyJobs = [
    RecentJobModel(
      jobId: '001',
      title: 'Installation and Maintenance',
      date: '2025-05-01',
      time: '10:00 AM',
      customerStatus: 'Confirmed',
      workStatus: 'Not Completed',
      serviceNotes: '4',
      technicianNotes: '1',
      technician: 'John Doe',
      technicianStatus: 'Assigned',
    ),
    RecentJobModel(
      jobId: '002',
      title: 'Installation and Repair',
      date: '2025-05-02',
      time: '02:30 PM',
      customerStatus: 'Pending',
      workStatus: 'Scheduled',
      serviceNotes: '2',
      technicianNotes: '1',
      technician: 'Jane Smith',
      technicianStatus: 'In Transit',
    ),
    RecentJobModel(
      jobId: '003',
      title: 'Service Checkup',
      date: '2025-05-03',
      time: '09:00 AM',
      customerStatus: 'Confirmed',
      workStatus: 'Completed',
      serviceNotes: '1',
      technicianNotes: '3',
      technician: 'Mike Johnson',
      technicianStatus: 'On Site',
    ),
  ];
}

