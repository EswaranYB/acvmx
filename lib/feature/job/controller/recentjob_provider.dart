// import 'package:acvmx/feature/job/model/job_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
//
// class RecentJobProvider with ChangeNotifier {
//   List<JobListModel> allJobs = [];
//   List<JobListModel> filteredJobs = [];
//
//   String? selectedStatus;
//   bool sortByRecent = true;
//
//   void setJobs(List<JobListModel> jobs) {
//     allJobs = jobs;
//     applyFilter(); // Apply current filter/sort when setting
//   }
//
//   void applyFilter({String? status, bool? recent}) {
//     if (status != null) selectedStatus = status;
//     if (recent != null) sortByRecent = recent;
//
//     filteredJobs = allJobs.where((job) {
//       if (selectedStatus == null) return true;
//       return job.workstatus.toLowerCase() == selectedStatus!.toLowerCase();
//     }).toList();
//
//     filteredJobs.sort((a, b) =>
//     sortByRecent ? b.date.compareTo(a.date) : a.date.compareTo(b.date)); // Now valid
//
//     notifyListeners();
//   }
//   void clearFilter() {
//     selectedStatus = null;
//     sortByRecent = true;
//     filteredJobs = List.from(allJobs);
//     notifyListeners();
//   }
// }