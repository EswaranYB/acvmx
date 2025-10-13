import 'package:acvmx/feature/Ticket/controller/get_ticket_by_technician_controller.dart';
import 'package:flutter/material.dart';
import '../model/joblistmodel.dart';

class JobListProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;


  final List<JobModel> _jobList = [];
  List<JobModel> get jobList => _jobList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchJobs(context,String userId, GetTicketByTechnicianController controller) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Just call it; don't assign to a variable
      await controller.getTicketByTechnicianApiCall(context,userId);

      // Then access the list
      _jobList
        ..clear()
        ..addAll(controller.ticketByTechnician.map((ticket) => JobModel.fromTicket(ticket)));

      print("JobListProvider: Fetched ${_jobList.length} jobs");
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }


  List<JobModel> get jobsForSelectedDate {
    return _jobList.where((job) {
      final jobDate = job.date;
      return jobDate.year == _selectedDate.year &&
          jobDate.month == _selectedDate.month &&
          jobDate.day == _selectedDate.day;
    }).toList();
  }

  Map<DateTime, List<JobModel>> get jobsByDate {
    final Map<DateTime, List<JobModel>> jobMap = {};
    for (var job in _jobList) {
      final key = DateTime(job.date.year, job.date.month, job.date.day);
      jobMap.putIfAbsent(key, () => []).add(job);
    }
    return jobMap;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}

// import 'package:acvmx/feature/job/model/joblistmodel.dart';
  // import 'package:flutter/material.dart';
  // import '../../Ticket/ controller/get_ticket_by_technician_controller.dart';
  //
  // class JobListProvider with ChangeNotifier {
  //   DateTime _selectedDate = DateTime.now();
  //   DateTime get selectedDate => _selectedDate;
  //
  //   final List<JobModel> _jobList = [];
  //   List<JobModel> get jobList => _jobList;
  //
  //   bool _isLoading = false;
  //   bool get isLoading => _isLoading;
  //
  //   // Future<void> fetchJobs(String userId, GetTicketByTechnicianController controller) async {
  //   //   _isLoading = true;
  //   //   notifyListeners();
  //   //
  //   //   try {
  //   //     final tickets = await controller.getTicketByTechnicianApiCall(userId);
  //   //     _jobList
  //   //       ..clear()
  //   //       ..addAll(tickets.map((ticket) => JobModel.fromTicket(ticket)));
  //   //   } catch (e) {
  //   //     debugPrint('Error fetching jobs: $e');
  //   //   }
  //   //
  //   //   _isLoading = false;
  //   //   notifyListeners();
  //   // }
  //   Future<void> fetchJobs(String userId, GetTicketByTechnicianController controller) async {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     try {
  //       final tickets = await controller.getTicketByTechnicianApiCall(userId);
  //       _jobList.clear();
  //       _jobList.addAll(tickets.map((ticket) => JobModel.fromTicket(ticket)));
  //     } catch (e) {
  //       debugPrint('Error fetching jobs: $e');
  //     }
  //
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  //
  //   List<JobModel> get jobsForSelectedDate {
  //     return _jobList.where((job) {
  //       final jobDate = job.date;
  //       return jobDate.year == _selectedDate.year &&
  //           jobDate.month == _selectedDate.month &&
  //           jobDate.day == _selectedDate.day;
  //     }).toList();
  //   }
  //
  //   // Map<DateTime, List<JobModel>> get jobsByDate {
  //   //   Map<DateTime, List<JobModel>> jobMap = {};
  //   //   for (var job in _jobList) {
  //   //     final jobDate = job.date;
  //   //     final key = DateTime(jobDate.year, jobDate.month, jobDate.day);
  //   //     jobMap.putIfAbsent(key, () => []).add(job);
  //   //   }
  //   //   return jobMap;
  //   // }
  //   Map<DateTime, List<JobModel>> get jobsByDate {
  //     Map<DateTime, List<JobModel>> jobMap = {};
  //     for (var job in _jobList) {
  //       final jobDate = job.date;
  //       final key = DateTime(jobDate.year, jobDate.month, jobDate.day);
  //       if (!jobMap.containsKey(key)) {
  //         jobMap[key] = [];
  //       }
  //       jobMap[key]!.add(job);
  //     }
  //     return jobMap;
  //   }
  //
  //   void setSelectedDate(DateTime date) {
  //     _selectedDate = date;
  //     notifyListeners();
  //   }
  // }
