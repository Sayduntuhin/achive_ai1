import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/custom_button.dart';
import 'package:achive_ai/view/widgets/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';

class HelpAndSupportScreen extends StatelessWidget {
  final TextEditingController problemController = TextEditingController();

  HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          title: "Help & Support",
          borderColor: secondaryBorderColor,
          textColor: textColor,
          onBackPress: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// *** Problem Description Field ***

            Text(
              "Describe Your Problem",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: textColor2,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: problemController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type your problem here...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),
            SizedBox(height: 0.1.sh),

            /// *** Send Button ***
            CustomButton(
              text: "Send",
              backgroundColor: buttonColor,
              onPressed: () {
                String problem = problemController.text;
                if (problem.isNotEmpty) {
                  // Show the dialog after sending the problem
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        title: SizedBox(),
                        content: Text(
                          "We are deeply sorry for the problem you are facing. We have received your message. We will contact you via email very soon.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor2,
                            fontFamily: 'Poppins'
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Center(
                            child: SizedBox(
                              width: 100.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:buttonColor,
                                  //onPrimary: Colors.white,
                                ),
                                child: Text("Cool",style: TextStyle(fontFamily: "Philosopher",color: Colors.white),),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  SnackbarHelper.showErrorSnackbar("Please describe your problem");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
