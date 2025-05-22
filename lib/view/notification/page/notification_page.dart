import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/notification_controller.dart';
import '../../../model/notification_model.dart';
import '../../../themes/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Widget _buildShimmerNotificationCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150.w,
                    height: 16.h,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final NotificationController controller = Get.find<NotificationController>();
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          controller.markAsRead(notification.id);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withAlpha(50),
              ),
              child: Icon(
                notification.title.contains('Completed')
                    ? Icons.check_circle
                    : Icons.notifications,
                color: primaryColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      fontFamily: 'Philosopher',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt.toLocal()),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[500],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
            fontFamily: 'Philosopher',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor, size: 24.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? Column(
          children: List.generate(
            5,
                (index) => _buildShimmerNotificationCard(),
          ),
        )
            : controller.errorMessage.value.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: controller.fetchNotifications,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        )
            : controller.notifications.isEmpty
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_off,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No Notifications',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          color: primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 16.h),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) => _buildNotificationCard(
              controller.notifications[index],
            ),
          ),
        ),
      ),
    );
  }
}