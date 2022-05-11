import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormParameterState extends Equatable {
  const FormParameterState({
    this.name = '',
    this.email = '',
  });
  final String name;
  final String email;

  @override
  List<Object> get props => [name, email];

  @override
  String toString() => 'FormParameterState(name: $name, email: $email)';

  FormParameterState copyWith({
    String? name,
    String? email,
  }) {
    return FormParameterState(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

final formParameterState = StateProvider.autoDispose(
  (ref) {
    ref.onDispose(() {
      log("Trigger Dispose [formParameterState]");
    });
    return const FormParameterState();
  },
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Name",
                        ),
                        onChanged: (val) {
                          // ref
                          //     .read(formParameterState.notifier)
                          //     .update((state) => state.copyWith(name: val));
                          ref
                              .watch(formParameterState.notifier)
                              .update((state) => state.copyWith(name: val));
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                        ),
                        onChanged: (val) {
                          // ref
                          //     .read(formParameterState.notifier)
                          //     .update((state) => state.copyWith(email: val));
                          ref
                              .watch(formParameterState.notifier)
                              .update((state) => state.copyWith(email: val));
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // final formRead = ref.read(formParameterState);
              // log("[Form Parameter Read] Name : ${formRead.name}");
              // log("[Form Parameter Read] Name : ${formRead.email}");

              final formWatch = ref.watch(formParameterState.notifier).state;
              log("[Form Parameter Watch] Name : ${formWatch.name}");
              log("[Form Parameter Watch] Name : ${formWatch.email}");
            },
            child: const Text("sss"),
          )
        ],
      ),
    );
  }
}
