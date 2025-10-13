class ReportedIssueModel {
  final String ticketId;
  final String title;
  final String date;
  final String time;

  final String workStatus;

  ReportedIssueModel({
    required this.ticketId,
    required this.title,
    required this.date,
    required this.time,
    required this.workStatus,
  });

  factory ReportedIssueModel.fromMap(Map<String, dynamic> map) {
    return ReportedIssueModel(
      ticketId: map['ticketId'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      workStatus: map['workStatus'],
    );
  }

  ReportedIssueModel copyWith({
    String? ticketId,
    String? title,
    String? date,
    String? time,
    String? workStatus,
  }) {
    return ReportedIssueModel(
      ticketId: ticketId ?? this.ticketId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      workStatus: workStatus ?? this.workStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'title': title,
      'date': date,
      'time': time,
      'workStatus': workStatus,
    };
  }
}
