part of 'homepage_bloc.dart';

class HomepageEvent {}

class FetchHomeData extends HomepageEvent {
  final PageStatus pageStatus;
  final bool fetchLocalOnly;
  FetchHomeData({
    required this.pageStatus,
    this.fetchLocalOnly = false,
  });
}

class OnSubmitLastTouch extends HomepageEvent {
  OnSubmitLastTouch();
}

class OnSubmitLastOnline extends HomepageEvent {
  OnSubmitLastOnline();
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

class OnStartInactiveValidation extends HomepageEvent {
  OnStartInactiveValidation();
}

class OnStopInactiveValidation extends HomepageEvent {
  OnStopInactiveValidation();
}

class OnFetchMore extends HomepageEvent {
  final PageStatus pageStatus;
  OnFetchMore({
    required this.pageStatus,
  });
}
