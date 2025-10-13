
import 'package:acvmx/feature/Dashboard/controller/dashboard_job_count_controller.dart';
import 'package:acvmx/feature/profile/controller/worker_profile_controller.dart';
import 'package:acvmx/feature/videorecording/controller/customer_recording_provider.dart';
import 'package:acvmx/feature/videorecording/view/screen/job_list_view_video_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../Network/api_manager.dart';
import '../feature/Dashboard/controller/dashboard_controller.dart';
import '../feature/Dashboard/controller/get_product_detail_controller.dart';
import '../feature/Dashboard/controller/status_update_controller.dart';
import '../feature/Notification/controller/notification_controller.dart';
import '../feature/Ticket/controller/get_ticket_by_technician_controller.dart';
import '../feature/Ticket/controller/raise_ticket_controller.dart';
import '../feature/Ticket/controller/raised_ticket_by_customerid_controller.dart';
import '../feature/Ticket/controller/ticket_details_byId_controller.dart';
import '../feature/auth/controller/auth_controller.dart';
import '../feature/job/controller/joblist_provider.dart';
import '../feature/job/controller/stock_inventory_controller.dart';
import '../feature/job/controller/ticket_status_update_controller.dart';
import '../feature/job/view/screen/recentjobs.dart';
import '../feature/profile/controller/get_employee_controller.dart';
import '../feature/profile/controller/get_user_details_controller.dart';
import '../feature/profile/controller/serialno_provider.dart';
import '../feature/videorecording/controller/technician_recording_provider.dart';

List<SingleChildWidget> appProvider = [
  Provider<BaseApiManager>(create: (_) => BaseApiManager()),
  Provider<ApiManager>(create: (_) => ApiManager()),
  ChangeNotifierProvider(create: (_) => AuthController()),
  ChangeNotifierProvider(create: (_) => RaisedTicketsController()),
  ChangeNotifierProvider(create: (_) => DashBoardController(initialPage: '')),
  // ChangeNotifierProvider(create: (context) => AuthProvider()..loadUser()),
  ChangeNotifierProvider(create: (_) => GetUserDetailsProvider()), //
  ChangeNotifierProvider(create: (_) => JobListProvider()),
  ChangeNotifierProvider(create: (_) => JobListProvider()),
  ChangeNotifierProvider(
    create: (_) => JobListProvider(),
    child: RecentJobs(),
  ),
  ChangeNotifierProvider(create: (_) => GetTicketByTechnicianController()),
  ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
  ChangeNotifierProvider(create: (_) => RaiseTicketController()),
  ChangeNotifierProvider(create: (_) => TicketDetailsController(),lazy: false,),
  ChangeNotifierProvider(create: (_) => DashboardJobCountController()),
  ChangeNotifierProvider(create: (_) => WorkerProfileController()),
  // ChangeNotifierProvider(create: (_) => VideoProvider()),
  ChangeNotifierProvider(create: (_) => TechnicianCameraProvider()),
  ChangeNotifierProvider(create: (_) => CustomerCameraProvider()),
  ChangeNotifierProvider(create: (_) => GetTicketByTechnicianController()),
  ChangeNotifierProvider(create: (_) => StatusUpdateController()),
  ChangeNotifierProvider(create: (_) => TicketStatusUpdateController()),
  ChangeNotifierProvider(create: (_) => StockInventoryController()),
  ChangeNotifierProvider(create: (_) => NotificationController()),
  ChangeNotifierProvider(create: (_) => CustomerProfileProductProvider()),
  ChangeNotifierProvider(create: (_) => GetEmployeeController()),
];
