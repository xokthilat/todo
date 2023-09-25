//dao is data access object
import 'package:objectbox/objectbox.dart';

import 'package:todo/features/todo/domain/entities/todo.dart';
import 'package:todo/objectbox.g.dart';

@Entity()
class TodoDao implements Todo {
  @Id()
  int localId;

  @Property(type: PropertyType.date)
  @override
  late final DateTime createdAt;

  @override
  late final String description;

  @Index()
  @override
  late final String id;

  @Transient()
  @override
  late final TodoStatus status;

  @override
  late final String title;

  int? get dbStatus {
    _ensureStableEnumValues();
    return status.index;
  }

  set dbStatus(int? value) {
    _ensureStableEnumValues();
    if (value == null) {
      status = TodoStatus.UNKNOWN;
    } else {
      status = TodoStatus.values[value]; // throws a RangeError if not found

      // or if you want to handle unknown values gracefully:
      status = value >= 0 && value < TodoStatus.values.length
          ? TodoStatus.values[value]
          : TodoStatus.UNKNOWN;
    }
  }

  void _ensureStableEnumValues() {
    assert(TodoStatus.TODO.index == 0);
    assert(TodoStatus.DOING.index == 1);
    assert(TodoStatus.DONE.index == 2);
  }

  TodoDao({
    this.localId = 0,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.title,
  });
}
