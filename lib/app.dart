import 'package:demo_google_map/google_map/view/google_map_page.dart';
import 'package:demo_google_map/home/home.dart';
import 'package:demo_google_map/splash/view/splash_page.dart';
import 'package:demo_google_map/user_location/bloc/user_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_location_repository/user_location_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final UserLocationRepository _userLocationRepository;

  @override
  void initState() {
    _userLocationRepository = UserLocationRepository();
    super.initState();
  }

  @override
  void dispose() {
    _userLocationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userLocationRepository,
      child: BlocProvider(
        create: (_) => UserLocationBloc(
          userLocationRepository: _userLocationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<UserLocationBloc, UserLocationState>(
          listener: (context, state) {
            switch (state.status) {
              case UserLocationStatus.initialized:
                _navigator.pushAndRemoveUntil<void>(
                  GoogleMapDemoPage.route(),
                      (route) => false,
                );
              case UserLocationStatus.unknown:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                      (route) => false,
                );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

