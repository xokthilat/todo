import 'package:objectbox/objectbox.dart';

import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/objectbox.g.dart';

@Entity()
class AuthDao implements Auth {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  @override
  DateTime lastTouch;

  @Property(type: PropertyType.date)
  @override
  DateTime lastOnline;
  @override
  String passcode;
  AuthDao(
      {this.id = 0,
      required this.lastTouch,
      required this.lastOnline,
      required this.passcode});

  @override
  String toString() {
    return 'AuthDao(id: $id, lastTouch: $lastTouch, lastOnline: $lastOnline, passcode: $passcode)';
  }
}
