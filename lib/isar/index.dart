import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:isar_reproduce/isar/schema/profile.dart';

final isarInstance = Provider<Isar>((_) => throw UnimplementedError());

Future<Isar> createIsarInstance() async {
  final isar = await Isar.open(
    [
      ProfileSchema,
    ],
  );

  return isar;
}
