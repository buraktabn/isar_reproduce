import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_reproduce/isar/index.dart';
import 'package:isar_reproduce/isar/schema/profile.dart';

void main() async {
  final isar = await createIsarInstance();

  runApp(ProviderScope(
    overrides: [isarInstance.overrideWithValue(isar)],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'name'),
            ),
            Consumer(builder: (context, ref, _) {
              final isar = ref.watch(isarInstance);
              return ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    final age = Random().nextInt(100) + 1;
                    isar
                        .writeTxn(() => isar.profiles.put(Profile(name: controller.text, age: age)))
                        .then((value) => controller.clear());
                  },
                  child: const Text('create Profile'));
            }),
            SizedBox(
              height: 300,
              child: Consumer(
                builder: (context, ref, _) {
                  final isar = ref.watch(isarInstance);
                  return StreamBuilder(
                      stream: isar.profiles.watchLazy(),
                      builder: (context, snapshot) {
                        final size = isar.profiles.countSync();
                        final profiles =
                            isar.profiles.getAllSync(List.generate(size, (index) => index + 1));
                        return ListView.builder(
                          itemCount: profiles.length,
                          itemBuilder: (_, i) {
                            return ListTile(
                              title: Text(profiles[i]!.name),
                              subtitle: Text('age: ${profiles[i]?.age}'),
                            );
                          },
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
