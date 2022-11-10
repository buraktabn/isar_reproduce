import 'package:isar/isar.dart';

part 'profile.g.dart';

@collection
class Profile {
  final Id? id;
  @Index()
  final int? age;
  // @Index()
  // final List<int>? someIds;
  final String name;
  final String? comments;
  @Ignore()
  final String? debug;

  const Profile(
      {required this.name, this.id, /*this.someIds*/ this.age, this.comments, this.debug});
}
