
import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/custom_text.dart';
import 'package:acvmx/core/sharedpreferences/sharedpreferences_services.dart';
import 'package:acvmx/feature/Dashboard/controller/dashboard_job_count_controller.dart';
import 'package:acvmx/feature/profile/controller/worker_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../Ticket/controller/get_ticket_by_technician_controller.dart';
import '../../controller/status_update_controller.dart';
import '../../model/employee_status_update.dart';


class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = [];
  late final List<Animation<double>> _animations = [];
  bool _isInitializingAnimations = false;
  bool isAccepted=true;
String? userId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    // Step 1: Get user ID
    userId = SharedPrefService().getUserId();

    if (userId != null) {
      // Step 2: Fetch all data from providers
      await context.read<DashboardJobCountController>().fetchJobCount(context, userId!);
      await context.read<WorkerProfileController>().getWorkerDetailsApiCall(userId!);
      await context.read<GetTicketByTechnicianController>().getTicketByTechnicianApiCall(context, userId!);

      // Step 3: Initialize switch state from backend
      final profile = context.read<WorkerProfileController>().workerDetailsByIdResponse;
      if (profile != null && profile.status != null) {
        setState(() {
          isAccepted = profile.status!.toUpperCase() == "ACTIVE";
        });
      }

    } else {
      showSnackBar(context, 'User ID not found. Failed to load data.');
    }
  }

  void _initializeAnimations(int count) {
    if (_isInitializingAnimations || !mounted) return;
    _isInitializingAnimations = true;

    // Clear existing controllers
    _disposeAnimations();

    // Initialize new controllers
    try {
      _controllers.addAll(
        List.generate(
          count,
              (index) => AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 600),
          ),
        ),
      );

      _animations.addAll(
        _controllers.map(
              (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeIn),
          ),
        ),
      );

      // Start animations with delays
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted && i < _controllers.length) {
            try {
              _controllers[i].forward();
            } catch (e) {
              debugPrint('Error animating controller $i: $e');
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    } finally {
      _isInitializingAnimations = false;
    }
  }

  void _disposeAnimations() {
    for (final controller in _controllers) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing controller: $e');
      }
    }
    _controllers.clear();
    _animations.clear();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<DashboardJobCountController>(
        builder: (context, provider, child) {
          // Initialize animations when jobList is available and length changes
          if (provider.jobList.isNotEmpty &&
              _controllers.length != provider.jobList.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _initializeAnimations(provider.jobList.length);
              }
            });
          }
          return PopScope(
            canPop: false,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: AppColor.primaryWhite,
                body: Column(
                  children: [
                    Container(
                      color: AppColor.primaryWhite,
                      child: SizedBox(
                        height: size.height * 0.33,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 90),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Selector<WorkerProfileController, String?>(
                                        selector: (_, provider) => provider.workerDetailsByIdResponse?.image,
                                        builder: (context, imageUrl, child) {
                                          final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundColor: AppColor.primaryColor,
                                            child: ClipOval(
                                              child: hasImage
                                                  ? Image.network(
                                                imageUrl,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          AppColor.primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return SvgPicture.asset(
                                                    AppIcons.profile,
                                                    width: 30,
                                                    height: 30,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                                  : SvgPicture.asset(
                                                AppIcons.profile,
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: 'Hello,',
                                            fontSize: AppFontSize.s18,
                                            color: AppColor.primaryWhite,
                                          ),
                                          Selector<WorkerProfileController, String?>(
                                            selector: (_, provider) =>
                                            provider.workerDetailsByIdResponse?.username,
                                            builder: (_, user, __) {
                                              return CustomText(
                                                text: user ?? 'User',
                                                fontSize: AppFontSize.s22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.primaryWhite,

                                              );
                                            },
                                          ),
                                          Selector<WorkerProfileController, String?>(
                                            selector: (_, provider) =>
                                            provider.workerDetailsByIdResponse?.status,
                                            builder: (_, status, __) {
                                              return CustomText(
                                                text: status ?? 'User',
                                                fontSize: AppFontSize.s13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.primaryWhite,

                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Transform.scale(
                                            scale: 0.5,
                                            child: Switch(
                                              value: isAccepted,
                                              activeColor: Colors.green,
                                                onChanged: (val) async {
                                                  setState(() => isAccepted = val); // local toggle

                                                  // Call update API
                                                  await context.read<StatusUpdateController>().updateEmployeeStatus(
                                                      StatusUpdateRequest(status: isAccepted ? "ACTIVE" : "INACTIVE")
                                                  );

                                                  // Immediately refresh profile controller
                                                  final userId = SharedPrefService().getUserId();
                                                  if (userId != null) {
                                                    await context.read<WorkerProfileController>().getWorkerDetailsApiCall(userId);
                                                  }

                                                  // Show snackbar regardless
                                                  showSnackBar(context, "Status updated successfully");
                                                }
                                            ),
                                          ),
                                          Text(
                                            isAccepted ? "Active" : "Inactive",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isAccepted ? Colors.green : AppColor.greyABABAB,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              top: size.height * 0.1,
                              left: 20,
                              right: 20,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 69,
                                  child: Card(
                                    elevation: 5,
                                    color: AppColor.primaryWhite,
                                    shadowColor: AppColor.blackColor,
                                    child: ListTile(
                                      leading: SvgPicture.asset(AppIcons.documentsearch),
                                      title: Text(
                                        'Appointed jobs',
                                        style: TextStyle(
                                          fontSize: AppFontSize.s16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      trailing: CircleAvatar(
                                        backgroundColor: AppColor.primaryWhite,
                                        child: Selector<GetTicketByTechnicianController, String?>(
                                          selector: (_, provider) => provider.ticketByTechnician.length.toString(),
                                          builder: (context, jobCount, child) {
                                            return CustomText(
                                              text: jobCount,
                                              fontSize: AppFontSize.s24,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.w900,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            color: AppColor.primaryWhite,
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 36,
                                mainAxisSpacing: 36,
                              ),
                              itemCount: provider.jobList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index >= _animations.length) {
                                  return const SizedBox(); // Fallback widget
                                }
                                return AnimatedBuilder(
                                  animation: _animations[index],
                                  builder: (context, child) => Transform.scale(
                                    scale: _animations[index].value,
                                    child: Opacity(
                                      opacity: _animations[index].value,
                                      child: child,
                                    ),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 125,
                                      minWidth: 125,
                                    ),
                                    decoration: BoxDecoration(
                                      color: provider.jobList[index].color,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(provider.jobList[index].icon),
                                        CustomText(
                                          text: provider.jobList[index].number,
                                          fontSize: AppFontSize.s22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Text(
                                          provider.jobList[index].title,
                                          style: TextStyle(
                                            fontSize: AppFontSize.s14,
                                            fontWeight: AppFontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.of(context).pushNamed(RouteName.jobListScreen);
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         CustomText(
                          //           text: 'View job listings',
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //         const Icon(Icons.arrow_forward),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
