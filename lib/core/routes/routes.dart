import 'package:acvmx/feature/Dashboard/model/get_product_detail_by_serial_number_model.dart';
import 'package:acvmx/feature/Ticket/view/screen/customer_scan_success.dart';
import 'package:acvmx/feature/Ticket/view/screen/raised_ticket.dart';
import 'package:acvmx/feature/mapView/view/customer_location_view.dart';
import 'package:acvmx/feature/videorecording/view/screen/customer_preview_screen.dart';
import 'package:acvmx/feature/videorecording/view/screen/customer_recording_screen.dart';
import 'package:acvmx/feature/videorecording/view/screen/technician_recordingscreen.dart';
import 'package:go_router/go_router.dart';
import '../../feature/Dashboard/view/screens/dashboard_screen.dart';
import '../../feature/Ticket/view/screen/view_ticket.dart';
import 'route_name.dart';
import 'package:acvmx/feature/auth/view/screens/splash_screen.dart';
import 'package:acvmx/feature/auth/view/screens/login.dart';
import 'package:acvmx/feature/Dashboard/view/screens/worker_home_screen.dart';
import 'package:acvmx/feature/Dashboard/view/screens/customer_home_screen.dart';
import 'package:acvmx/feature/job/view/screen/joblist.dart';
import 'package:acvmx/feature/job/view/screen/jobdetails.dart';
import 'package:acvmx/feature/job/view/screen/recentjobs.dart';
import 'package:acvmx/feature/Ticket/view/screen/add_attachment.dart';
import 'package:acvmx/feature/profile/view/screen/reported_issue_screen.dart';
import 'package:acvmx/feature/profile/view/screen/customer_profile_screen.dart';
import 'package:acvmx/feature/Scanner/view/barcode_scan_screen.dart';
import 'package:acvmx/feature/Scanner/view/result_page.dart';
import 'package:acvmx/feature/Ticket/view/screen/product_details.dart';
import 'package:acvmx/feature/Ticket/view/screen/raise_ticket_screen.dart';


final GoRouter routes = GoRouter(
  initialLocation: RoutePath.splashScreen, // Use your AuthProvider here
  routes: [
    GoRoute(
      path: '${RoutePath.dashBoardScreen}/:userType',
      name: RouteName.dashboardScreen,
      builder: (context, state) {
        final userType = state.pathParameters['userType']!;
        final selectedTabStr = state.uri.queryParameters['tab'] ?? '0';
        final selectedTab = int.tryParse(selectedTabStr) ?? 0;

        return DashboardScreen(from: userType, selectedTab: selectedTab);
      },
    ),
    GoRoute(
      path: RoutePath.splashScreen,
      name: RouteName.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: RoutePath.loginScreen,
      name: RouteName.loginScreen,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: RoutePath.workerHomeScreen,
      name: RouteName.workerHomeScreen,
      builder: (context, state) => WorkerHomeScreen(),
    ),
    GoRoute(
      path: RoutePath.customerHomeScreen,
      name: RouteName.customerHomeScreen,
      builder: (context, state) => CustomerHomeScreen(),
    ),
    GoRoute(
      path: RoutePath.jobListScreen,
      name: RouteName.jobListScreen,
      builder: (context, state) => JobListScreen(),
    ),
    // GoRoute(
    //   path: RoutePath.jobDetailsScreen,
    //   name: RouteName.jobDetailsScreen,
    //   builder: (context, state) => JobDetailsScreen(), // Pass job to screen
    // ),
    GoRoute(
      path: "${RoutePath.jobDetailsScreen}/:ticketId",
      name: RouteName.jobDetailsScreen,
      builder: (context, state) {
        final ticketId = state.pathParameters['ticketId']??'';
        final jobUniqueId = state.uri.queryParameters['jobUniqueId'] ?? '';
        return JobDetailsScreen(ticketId: ticketId,jobUniqueId:jobUniqueId);
      },    ),


    GoRoute(
      path: RoutePath.technicianRecordingScreen,
      name: RouteName.technicianRecordingScreen,
      builder: (context, state) => TechnicianRecordingScreen(), // Pass job to screen
    ),
    GoRoute(
      path: RoutePath.recentJobScreen,
      name: RouteName.recentJobScreen,
      builder: (context, state) => RecentJobs(),
    ),
    GoRoute(
      path: "${RoutePath.attachmentScreen}/:videoPath",
      name: RouteName.attachmentScreen,
      builder: (context, state){
        final videoPath = state.pathParameters['videoPath']??''; // Ensure videoPath is passed correctly
        return AttachmentScreen(videoPath: videoPath);
      },
    ),
    GoRoute(
      path: RoutePath.customerProfileScreen,
      name: RouteName.customerProfileScreen,
      builder: (context, state) => CustomerProfile(),
    ),

    GoRoute(
      path: RoutePath.customerRecordingScreen,
      name: RouteName.customerRecordingScreen,
      builder: (context, state) {
        final location = state.extra as String;
        return CustomerRecordingScreen(
          productLocation:location,
        );
      } ,
    ),
    GoRoute(
      path: RoutePath.barcodeScannerScreen,
      name: RouteName.barcodeScannerScreen,
      builder: (context, state) => BarcodeScannerScreen(),
    ),
    GoRoute(
      path: RoutePath.barcodeResultScreen,
      name: RouteName.barcodeResultScreen,
      builder: (context, state) {
        final result = state.extra as String;
        return BarcodeResultScreen(result: result);
      },
    ),
    GoRoute(
      name: RouteName.productDetailsScreen,
      path: '/product-details',
      builder: (context, state) {
        final product = state.extra as ProductDetailsBySerialNumberResponse?;
        return ProductDetails(product: product);
      },
    ),


    GoRoute(
      path: RoutePath.raisedTicketScreen,
      name: RouteName.raisedTicketScreen,
      builder: (context, state) => TicketRaisedScreen(),
    ),
    GoRoute(
      path: RoutePath.raiseTicketScreen,
      name: RouteName.raiseTicketScreen,
      builder: (context, state) {
        final extra = state.extra as Map<String,dynamic>;
        final videoPath = extra['videoPath']!;
        final location = extra['location']!;//
        return RaiseTicketScreen(videoPath: videoPath,location: location,);
      },
    ),
//     GoRoute(
//       path: "${RoutePath.reportedIssueScreen}/:userId",
//       name: RouteName.reportedIssueScreen,
//       builder: (context, state){
//         final userId = state.pathParameters['userId'] ?? '';
//         return ReportedIssue(userId: userId);
// } ,
//     ),
    GoRoute(
      path: "${RoutePath.reportedIssueScreen}/:uniqueId",
      name: RouteName.reportedIssueScreen,
      builder: (context, state) {
        final uniqueId = state.pathParameters['uniqueId']??'';
        final data = state.extra as Map<String, dynamic>?;

        final username = data?['username'] ?? "";
        final address = data?['address'] ?? "";
        return ReportedIssue(
          username: username,
          address: address,
          uniqueId:uniqueId ,
        );
      },
    ),
    GoRoute(
      path: RoutePath.customerPreviewScreen,
      name: RouteName.customerPreviewScreen,
      builder: (context, state) {
        final extra = state.extra as Map<String,dynamic>;
        final videoPath = extra['videoPath']!;
        final location = extra['location']!;// Adjust type if needed
        return CustomerPreviewScreen(videoPath: videoPath,location: location,);
      },
    ),

    GoRoute(path: RoutePath.customerScanSuccessScreen,
      name: RouteName.customerScanSuccessScreen,
      builder: (context, state) => CustomerScanSuccess(),
    ),


    GoRoute(
      name: RouteName.viewTicketScreen,
      path: RoutePath.viewTicketScreen,
      builder: (context, state) {
        final ticketId = state.extra as String; // Ensure ticketId is passed correctly
        return ViewTicketScreen(ticketId: ticketId);
      },    ),

    GoRoute(
        name: RouteName.customerLocationView,
        path: RoutePath.customerLocationView,
      builder: (context,state){
          final extra = state.extra as Map<String,dynamic>;
          final customerLong = extra["customerLong"];
          final customerLat = extra["customerLat"];
          final employLong = extra["employLong"];
          final employLat = extra["employLat"];
          return CustomerLocationView(customerLat: customerLat, customerLong: customerLong,employLong: employLong,employLat: employLat);
      }
    )
  ],
);
