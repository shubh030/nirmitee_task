import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

const _h = 'bloc_observer';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('Bloc created: ${bloc.runtimeType}', name: _h);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      'onChange -- ${bloc.runtimeType} from State ${change.currentState.runtimeType} to State ${change.nextState.runtimeType}',
      name: _h,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log(
      'onClose -- ${bloc.runtimeType}',
      name: _h,
    );
  }
}
