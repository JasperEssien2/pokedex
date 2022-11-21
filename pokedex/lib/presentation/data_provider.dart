import 'package:flutter/material.dart';

import 'data_controller.dart';

class DataControllerProvider<T extends BaseListDataController>
    extends InheritedWidget {
  const DataControllerProvider({
    super.key,
    required this.dataController,
    required super.child,
  });

  final T dataController;

  static T of<T extends BaseListDataController>(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<DataControllerProvider<T>>();

    assert(element != null, "DataControllerProvider<$T> not found");

    return (element!.widget as DataControllerProvider<T>).dataController;
  }

  @override
  bool updateShouldNotify(DataControllerProvider oldWidget) =>
      oldWidget.dataController != dataController;
}
