import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class NewPriceNotificationItemWidget extends GetView<NotificationsController> {
  NewPriceNotificationItemWidget({Key key, this.notification}) : super(key: key);
  final model.NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.chat_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Loading data..."),
          duration: Duration(seconds: 12),
        ));
        await controller.markAsReadNotification(notification);
        print(notification.message);
        //await controller.getSpecificShipping(notification.message);
        //Get.find<MessagesController>().card.value = await controller.getTravelInfo(controller.travelId.value);
        var id = notification.message.substring(notification.message.lastIndexOf(':')+2, notification.message.length-1);
        print('id id :'+id.toString());
        print('message :'+notification.message.toString());
       var item = await controller.getSingleShipping(int.parse(id));
        Get.toNamed(Routes.CHAT, arguments: {'shippingCard': item});
        //Get.toNamed(Routes.CHAT, arguments: new Message([], id: notification.id.toString()));

      },
    );
  }
}
