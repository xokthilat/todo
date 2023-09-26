import 'package:todo/features/todo/domain/entities/auth.dart';
import 'package:todo/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

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
}
