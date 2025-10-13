import 'package:acvmx/Network/api_response.dart';
import 'package:acvmx/feature/Dashboard/model/dashboard_job_count_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../Network/api_manager.dart';
import '../../../Network/api_service.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_decoration.dart';
import '../../../core/helper/app_log.dart';
import '../model/homescreen_model.dart';

class DashboardJobCountController with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  DashboardJobCountController() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  JobCountResponse? _jobCountResponse;
  JobCountResponse? get jobCountResponse => _jobCountResponse;

  Future<void> fetchJobCount(BuildContext context, String userId) async {
    try {
      final ApiResponse response = await _apiServices.getJobCountById(userId);

      if (response.status == 200 && response.data != null) {
        _jobCountResponse = JobCountResponse.fromJson(response.data!);
        AppLog.d("Job count fetched successfully: ${_jobCountResponse}");
        AppLog.d("Job count response: ${_jobCountResponse?.toJson()}");
      } else {
        final msg = response.message ?? "Unexpected data format";
        AppLog.e("Failed to fetch job count. Status: ${response.status}, Message: $msg");
        if (context.mounted) showSnackBar(context, msg);
      }
    } catch (error, stackTrace) {
      AppLog.e("Exception in fetchJobCount: $error\n$stackTrace");
      if (context.mounted) showSnackBar(context, "Something went wrong. Please try again.");
    } finally {
      notifyListeners();
    }
  }


  List<Job> get jobList => [
    Job(
      number: _jobCountResponse?.todayScheduledCount.toString() ?? '0',
      title: '   Work\nallocated',
      icon: AppIcons.workAlloted,
      color: AppColor.jobAlloted,
    ),
    Job(
      number: _jobCountResponse?.upcomingScheduledCount.toString() ?? '0',
      title: 'Upcoming \n     jobs',
      icon: AppIcons.upcomingJob,
      color: AppColor.jobUpcoming,
    ),
    Job(
      number: _jobCountResponse?.pastScheduledCount.toString() ?? '0',
      title: 'Overdue \n    jobs',
      icon: AppIcons.overduejob,
      color: AppColor.joboverdue,
    ),
    Job(
      number: _jobCountResponse?.totalJobCount.toString() ?? '0',
      title: 'Waiting for \nsubmission',
      icon: AppIcons.waitingjob,
      color: AppColor.jobwaiting,
    ),
  ];

}