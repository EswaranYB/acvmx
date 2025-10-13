import 'dart:io';

import 'package:acvmx/core/app_decoration.dart';
import 'package:acvmx/core/app_dimensions.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/controller/get_product_detail_controller.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:acvmx/feature/videorecording/controller/customer_recording_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/appbutton.dart';
import '../../../../core/custom_text.dart';
import '../../../../core/custom_textfield.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/sharedpreferences/sharedpreferences_services.dart';
import '../../controller/raise_ticket_controller.dart';
import '../../model/raise_ticket_model.dart';

class RaiseTicketScreen extends StatefulWidget {
  RaiseTicketScreen({super.key, required this.videoPath,required this.location});
  final String location;

  final String videoPath;

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _serviceNotesController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  final userId = SharedPrefService().getUserId();

  void initState(){
    _locationController.text = widget.location;
    super.initState();
  }

  Future<bool> _showDiscardDialog(BuildContext context) async {
    final cameraProvider = Provider.of<CustomerCameraProvider>(context, listen: false);
//_locationController.text= context.read<ProductDetailProvider>().productDetailsBySerialNumber?.productId??1.toString();

    return await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Discard Video"),
          content: const Text("Are you sure you want to discard the video and clear all data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Do not pop the screen
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                cameraProvider.clearCache();
                _titleController.clear();
                _serviceNotesController.clear();
                _locationController.clear();
                Navigator.of(dialogContext).pop(true); // Pop the dialog, indicating discard
              },
              child: const Text("Discard"),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('MM/dd/yyyy - hh:mma').format(DateTime.now());
    final cameraProvider = Provider.of<CustomerCameraProvider>(context, listen: false);
    return Consumer<RaiseTicketController>(
        builder: (context, controller, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: true,
          onPopInvoked: (value) async {
            if (await _showDiscardDialog(context)) {
              context.pop();
              context.pop();
              cameraProvider.clearCache();
            }
          },
          child: Scaffold(
            backgroundColor: AppColor.primaryWhite,
            appBar: commonAppBar(context, title: 'Raise Ticket', showLeading: true,
                onBack: () {
              cameraProvider.clearCache();
              context.pop();
              context.pop();
            }),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(AppIcons.calendericon),
                          onPressed: () {},
                        ),
                        CustomText(
                          text: formattedDateTime,
                          color: AppColor.textColor000000,
                          fontSize: AppFontSize.s11,
                          fontWeight: AppFontWeight.w700,
                        ),
                      ],
                    ),
                    Card.outlined(
                      elevation: 1,
                      color: AppColor.primaryWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: BorderSide(color: AppColor.greyE4E4E4)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.check_circle,
                                  color: AppColor.statusGreen,
                                  size: 100,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomText(
                                text: "Video Recorded Successfully",
                                fontSize: AppFontSize.s14,
                                fontWeight: AppFontWeight.w600,
                                color: AppColor.textColor000000,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    20.height,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Please fill the details below",
                        fontSize: AppFontSize.s16,
                        fontWeight: AppFontWeight.w900,
                        color: AppColor.textColor000000,
                      ),
                    ),
                    20.height,
                    Card.outlined(
                      elevation: 2,
                      color: AppColor.primaryWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                title('Issue'),
                                5.width,
                                Expanded(
                                    flex: 3,
                                    child: CustomTextFieldWidget(
                                      inputType: TextInputType.text,
                                      hintText: "Issue Title",
                                      controller: _titleController,
                                    )),
                              ],
                            ),
                            15.height,
                            Row(
                              children: [
                               title('Comments'),
                                10.width,
                                Expanded(
                                  flex: 3,
                                  child: CustomTextFieldWidget(
                                    controller: _serviceNotesController,
                                    inputType: TextInputType.text,
                                    maxLines: 3,
                                    hintText: "Issue Description",

                                  ),
                                ),
                              ],
                            ),
                            15.height,
                            Row(
                              children: [
                                title('Location'),
                                5.width,
                                Expanded(
                                    flex: 3,
                                    child: CustomTextFieldWidget(
                                      controller: _locationController,
                                      inputType: TextInputType.text,
                                      hintText: "Enter Your Location",
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    40.height,
                    if(controller.isLoading)...[
                      Center(
                        child: CustomText(text: "Please wait few seconds and do not go back",),
                      ),
                      5.height
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AppButton(
                        text: 'Raise a Ticket',
                        onPressed: () async {
                          final title = _titleController.text.trim();
                          final serviceNotes = _serviceNotesController.text.trim();
                          final location = _locationController.text.trim();
                          final productId = Provider.of<ProductDetailProvider>(context, listen: false)
                              .productDetailsBySerialNumber
                              ?.productId;

                          if (title.isEmpty) {
                            showSnackBar(context, "Please Enter Problem");
                          } else if (serviceNotes.isEmpty) {
                            showSnackBar(context, "Please Enter Comment");
                          } else if (location.isEmpty) {
                            showSnackBar(context, "Please Enter Location");
                          } else {
                            try {
                              showLoadingDialog(context, message: 'Raising ticket...');

                              final request = RaiseTicketRequest(
                                id: userId.toString(),
                                productId: productId ?? "PROD_001",
                                problems: title,
                                location: location,
                                comments: serviceNotes,
                                video: File(widget.videoPath),
                              );

                              await controller.raiseTicketApiCall(context,request);
                              await cameraProvider.clearCache();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                context.pushNamed(
                                  RouteName.dashboardScreen,
                                  pathParameters: {'userType': 'customer'},
                                );
                              }

                              _titleController.clear();
                              _serviceNotesController.clear();
                              _locationController.clear();
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.of(context).pop(); // Close the loading dialog
                                showSnackBar(context, "Failed to raise ticket: ${e.toString()}");
                              }
                            }
                          }
                        },
                        fontSize: 18,
                        height: 42,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  title(String title){
    return Expanded(
      flex: 1,
      child: CustomText(
        text:title,
        fontSize: Rem.rem(AppFontSize.s14),
        fontWeight: AppFontWeight.w600,
      ),
    );
  }
}
void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: AppColor.primaryWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
            child: Row(
              children: [
                10.width,
                 CircularProgressIndicator(color: AppColor.primaryColor,),
                24.width,
                Expanded(
                  child: CustomText(text:
                    message,
                    fontSize: AppFontSize.s16, fontWeight: AppFontWeight.w600,
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

