import 'package:demo_google_map/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: Center(
        child: _RequestLocationButton()
      ),
    );
  }
}

class _RequestLocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return TextButton(onPressed: () {
          context.read<HomeBloc>().add(const RequestLocationSubmitEvent());
        }, child: const Text("Request Curr Location(BloC).", style: TextStyle(fontSize: 20),));
      },
    );
  }
}
