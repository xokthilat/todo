import 'homepage_state.dart';

class HomepageEvent {}

class FetchHomeData extends HomepageEvent {
  final PageStatus pageStatus;
  FetchHomeData({
    required this.pageStatus,
  });
}

class OnSubmitLastTouch extends HomepageEvent {
  final DateTime lastTouch;
  OnSubmitLastTouch({
    required this.lastTouch,
  });
}

class OnSubmitLastOnline extends HomepageEvent {
  final DateTime lastOnline;
  OnSubmitLastOnline({
    required this.lastOnline,
  });
}

class OnDeleteTodo extends HomepageEvent {
  final String id;
  OnDeleteTodo({
    required this.id,
  });
}

class OnPageChanged extends HomepageEvent {
  final PageStatus pageStatus;
  OnPageChanged({
    required this.pageStatus,
  });
}
