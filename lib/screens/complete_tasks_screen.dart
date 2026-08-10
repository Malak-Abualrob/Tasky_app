import 'package:flutter/material.dart';

class CompleteTasksScreen extends StatelessWidget {
  const CompleteTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed"),
      ),
      body: const Center(
        child: Text(
          "Completed Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}