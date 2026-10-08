import 'package:flutter/material.dart';

import 'screens/app_navigator.dart';
import 'state/counter_model.dart';
import 'state/counter_scope.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key, this.now});

  final DateTime Function()? now;

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  late final CounterModel _model;

  @override
  void initState() {
    super.initState();
    _model = CounterModel(now: widget.now);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterApp');
    return CounterScope(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Лічильник з історією',
        theme: ThemeData(
          fontFamily: 'EvidenceFont',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315DA8)),
          useMaterial3: true,
        ),
        home: const AppNavigator(),
      ),
    );
  }
}
