
class JobCountResponse {
  int? todayScheduledCount;
  int? upcomingScheduledCount;
  int? pastScheduledCount;
  int? totalJobCount;

  JobCountResponse({
    this.todayScheduledCount,
    this.upcomingScheduledCount,
    this.pastScheduledCount,
    this.totalJobCount,
  });

  factory JobCountResponse.fromJson(Map<String, dynamic> json) => JobCountResponse(
    todayScheduledCount: json["today_scheduled_count"]??0,
    upcomingScheduledCount: json["upcoming_scheduled_count"]??0,
    pastScheduledCount: json["past_scheduled_count"]??0,
    totalJobCount: json["total_scheduled_count"]??0,
  );

  Map<String, dynamic> toJson() => {
    "today_scheduled_count": todayScheduledCount,
    "upcoming_scheduled_count": upcomingScheduledCount,
    "past_scheduled_count": pastScheduledCount,
    "total_scheduled_count": totalJobCount,
  };
}
