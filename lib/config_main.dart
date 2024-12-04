import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nirmitee/di/get_it.dart';
import 'package:nirmitee/presentation/cubits/bloc_observer.dart';

Future<void> configMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    configureDependencies();
    Bloc.observer = MyBlocObserver();
  } catch (e) {
    debugPrint('Error during app initialization: $e');
  }
}
