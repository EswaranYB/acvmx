import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors.dart';
import '../../controller/dashboard_controller.dart';
import '../../model/dashboard_model.dart';

class DashboardScreen extends StatelessWidget {
  final String? from;
  final int? selectedTab;

  const DashboardScreen({super.key, this.from, this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final isCustomer = from == 'worker';
    final initialPage = isCustomer ? 'home' : 'worker_home';

    return ChangeNotifierProvider(
      create: (_) => DashBoardController(initialPage: initialPage),
      child: Consumer<DashBoardController>(
        builder: (context, provider, _) {
          final navItems = isCustomer ? navBarItems : workerNavBarItems;
          int currentIndex = navItems.indexWhere((item) => item.name == provider.currentPage);

          // Ensure currentIndex is valid
          if (currentIndex == -1) {
            currentIndex = 0;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.updatePage(navItems[currentIndex].name);
            });
          }

          return PopScope(
            canPop: false, // Prevents default back navigation
            onPopInvokedWithResult: (didPop, result) {
              final isOnInitialTab = provider.currentPage == initialPage;
              if (!isOnInitialTab) {
                provider.updatePage(initialPage); // Navigate to initial tab
              } else {
                SystemNavigator.pop(); // Exit the app
              }
            },
            child: Scaffold(
              body: navItems[currentIndex].screen,
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: AppColor.primaryColor,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: AppColor.primaryColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      final selectedPage = navItems[index].name;
                      if (provider.currentPage != selectedPage) {
                        provider.updatePage(selectedPage);
                      }
                    },
                    items: navItems.map((item) {
                      final isSelected = provider.currentPage == item.name;
                      return BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          item.imagePath,
                          colorFilter: isSelected
                              ?  ColorFilter.mode(AppColor.primaryWhite, BlendMode.srcIn)
                              : null,
                        ),
                        label: "",
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
