
import 'package:acvmx/core/appbutton.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';

class AttachmentScreen extends StatelessWidget {
  final String? videoPath;
  const AttachmentScreen({super.key, required this.videoPath});
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryWhite,
      appBar: commonAppBar(context,title: 'Add Attachment',showLeading: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            children: [
              10.height,
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton( icon: SvgPicture.asset(AppIcons.calendericon),
                    onPressed: () {
        
                    },),
        
                  CustomText(
                    text: '07/31/202104:07AM',
                    color: AppColor.textColor000000,
                    fontSize: AppFontSize.s11,
                    fontWeight: AppFontWeight.w600,
                  ),
                ],
              ),
              10.height,
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: AppColor.greyE4E4E4)
                ),
                child: Container(
        
                  decoration: BoxDecoration(
                      color: AppColor.primaryWhite,
        
                    // boxShadow: greyBoxShadow()
                  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
        'assets/images/coffeemachinevideo.png', // Ensure this path is correct
         // Adjust size as needed
        height: 450,
        fit: BoxFit.contain,
            ),
        //
        //     IconButton(
        // icon: Icon(Icons.delete),
        // color: AppColor.textColor000000,
        // onPressed: () {},
        //     ),

          ],
        ),
                ),
              ),

              40.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AppButton(text: 'Submit Attachment', onPressed: (){
                 // context.pushNamed(RouteName.dashboardScreen,pathParameters: {'userType': 'worker'});
                 //  context.pushReplacementNamed(RouteName.jobDetailsScreen);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                fontSize: 18,
                height: 42,),
              )
        
        
        
        
            ],
          ),
        ),
      ),

    );
  }

  }