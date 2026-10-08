import 'package:flutter/widgets.dart';

import 'counter_model.dart';

class CounterScope extends InheritedNotifier<CounterModel> {
  const CounterScope({
    super.key,
    required CounterModel model,
    required super.child,
  }) : super(notifier: model);

  /// У build - підписка, у колбеках - одноразове читання з listen: false.
  static CounterModel of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<CounterScope>()
        : context.getInheritedWidgetOfExactType<CounterScope>();
    if (scope == null || scope.notifier == null) {
      throw FlutterError('CounterScope.of викликано поза CounterScope.');
    }
    return scope.notifier!;
  }
}
