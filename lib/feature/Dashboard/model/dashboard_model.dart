import 'package:acvmx/feature/Notification/view/screen/customer_notification.dart';
import 'package:acvmx/feature/Notification/view/screen/worker_notification.dart';
import 'package:acvmx/feature/job/view/screen/recentjobs.dart';
import 'package:acvmx/feature/profile/view/screen/worker_profile.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_assets.dart';
import '../../Ticket/view/screen/raised_ticket.dart';
import '../../profile/view/screen/customer_profile_screen.dart';
import '../view/screens/customer_home_screen.dart';
import '../view/screens/worker_home_screen.dart';


class DashBoardModel {
  final String label;
  final String imagePath;
  final String name;
  final Widget screen;

  DashBoardModel(this.label, this.imagePath, this.name, this.screen);
}

List<DashBoardModel> navBarItems = [
  DashBoardModel("Home", AppIcons.home, "home", WorkerHomeScreen()),
  DashBoardModel("Recent Job", AppIcons.joblist, "recent jobs", RecentJobs()),
  DashBoardModel("Notification", AppIcons.notifation, "worker_notification", WorkerNotification()),
  DashBoardModel("Profile", AppIcons.bottomprofile, "profile", WorkerProfile()),
];

List<DashBoardModel> workerNavBarItems = [
  DashBoardModel("Home", AppIcons.home, 'customer_home', CustomerHomeScreen()),
  DashBoardModel("Raised Ticket", AppIcons.joblist, 'raised_ticket', TicketRaisedScreen()),
  DashBoardModel("Notification", AppIcons.notifation, 'customer_notification', CustomerNotification()),
  DashBoardModel("Profile", AppIcons.bottomprofile, 'profile', CustomerProfile()),
];
