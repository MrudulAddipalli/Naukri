import 'package:flutter/material.dart';

class ModalHelper {
  //
  //
  static ModalHelper _instance;
  ModalHelper._();
  static ModalHelper get getInstance => _instance ??= ModalHelper._();
  //
  Future show(BuildContext bcontext, Widget widgetPassed) {
    return showModalBottomSheet(
      context: bcontext,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      builder: (_) {
        return DraggableScrollableSheet(
            initialChildSize: 0.80, //set this as you want
            maxChildSize: 0.80, //set this as you want
            minChildSize: 0.80, //set this as you want
            expand: false,
            builder: (_, scrollController) {
              return widgetPassed;
            });
      },
    );
  }

  Future full(BuildContext bcontext, Widget widgetPassed) {
    return showModalBottomSheet(
      context: bcontext,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      builder: (_) {
        return DraggableScrollableSheet(
            initialChildSize: 1, //set this as you want
            maxChildSize: 1, //set this as you want
            minChildSize: 1, //set this as you want
            expand: false,
            builder: (_, scrollController) {
              return widgetPassed;
            });
      },
    );
  }
}
