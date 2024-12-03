import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nirmitee/di/get_it.dart'; 
import 'package:nirmitee/presentation/cubits/grid_cubit/grid_cubit.dart';
import 'package:nirmitee/presentation/routes/route_name.dart';
import 'package:nirmitee/presentation/screens/greed_screen.dart';
import 'package:nirmitee/presentation/screens/splash_screen.dart';

class RouteGenerator {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.initial,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.initial,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: Routes.grid,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<GridCubit>(),
              ),
            ],
            child: const GridScreen(),
          );
        },
      ),
    ],
  );
}
