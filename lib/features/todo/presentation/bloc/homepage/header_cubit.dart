import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/homepage/homepage_bloc.dart';

class HeaderCubit extends Cubit<PageStatus> {
  HeaderCubit() : super(PageStatus.todo);

  void changePage(PageStatus status) => emit(status);
}
