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

final formParameterState = StateProvider.autoDispose<FormParameterState>((ref) {
  final now = DateTime.now();
  log("I am being recomputed! $now", name: "Your Provider", time: now);

  ref.onDispose(() {
    final now = DateTime.now();
    log("Triggered Dispose! $now", name: "Your disposed Provider", time: now);
  });
  return const FormParameterState();
});

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
    ref.listen(formParameterState, (_, __) {});
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
                          ref
                              .read(formParameterState.notifier)
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
                          ref
                              .read(formParameterState.notifier)
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
              /// Or `ref.read`, doesn't make much the difference
              final result = ref.watch(formParameterState);

              log("Name : ${result.name}", name: "Form");
              log("Email : ${result.email}", name: "Form");
            },
            child: const Text("Click me"),
          )
        ],
      ),
    );
  }
}
