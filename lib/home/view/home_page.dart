import 'package:demo_google_map/home/bloc/home_bloc.dart';
import 'package:demo_google_map/home/view/home_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_location_repository/user_location_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocProvider(create: (context) {
            return HomeBloc(userLocationRepository: RepositoryProvider.of<
                UserLocationRepository>(context));
          }, child: const HomeForm(),)
      ),
    );
  }
}
