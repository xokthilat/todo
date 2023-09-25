// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_holder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ApiHolder {
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get isAsc => throw _privateConstructorUsedError;
  TodoStatus get status => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int offset, int limit, String sortBy, bool isAsc, TodoStatus status)
        fetchTodoList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int offset, int limit, String sortBy, bool isAsc,
            TodoStatus status)?
        fetchTodoList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int offset, int limit, String sortBy, bool isAsc,
            TodoStatus status)?
        fetchTodoList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FetchTodoList value) fetchTodoList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FetchTodoList value)? fetchTodoList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FetchTodoList value)? fetchTodoList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ApiHolderCopyWith<ApiHolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiHolderCopyWith<$Res> {
  factory $ApiHolderCopyWith(ApiHolder value, $Res Function(ApiHolder) then) =
      _$ApiHolderCopyWithImpl<$Res, ApiHolder>;
  @useResult
  $Res call(
      {int offset, int limit, String sortBy, bool isAsc, TodoStatus status});
}

/// @nodoc
class _$ApiHolderCopyWithImpl<$Res, $Val extends ApiHolder>
    implements $ApiHolderCopyWith<$Res> {
  _$ApiHolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? sortBy = null,
    Object? isAsc = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      isAsc: null == isAsc
          ? _value.isAsc
          : isAsc // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TodoStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FetchTodoListCopyWith<$Res>
    implements $ApiHolderCopyWith<$Res> {
  factory _$$_FetchTodoListCopyWith(
          _$_FetchTodoList value, $Res Function(_$_FetchTodoList) then) =
      __$$_FetchTodoListCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int offset, int limit, String sortBy, bool isAsc, TodoStatus status});
}

/// @nodoc
class __$$_FetchTodoListCopyWithImpl<$Res>
    extends _$ApiHolderCopyWithImpl<$Res, _$_FetchTodoList>
    implements _$$_FetchTodoListCopyWith<$Res> {
  __$$_FetchTodoListCopyWithImpl(
      _$_FetchTodoList _value, $Res Function(_$_FetchTodoList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? sortBy = null,
    Object? isAsc = null,
    Object? status = null,
  }) {
    return _then(_$_FetchTodoList(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      isAsc: null == isAsc
          ? _value.isAsc
          : isAsc // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TodoStatus,
    ));
  }
}

/// @nodoc

class _$_FetchTodoList extends _FetchTodoList {
  const _$_FetchTodoList(
      {required this.offset,
      required this.limit,
      required this.sortBy,
      required this.isAsc,
      required this.status})
      : super._();

  @override
  final int offset;
  @override
  final int limit;
  @override
  final String sortBy;
  @override
  final bool isAsc;
  @override
  final TodoStatus status;

  @override
  String toString() {
    return 'ApiHolder.fetchTodoList(offset: $offset, limit: $limit, sortBy: $sortBy, isAsc: $isAsc, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FetchTodoList &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.isAsc, isAsc) || other.isAsc == isAsc) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, offset, limit, sortBy, isAsc, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FetchTodoListCopyWith<_$_FetchTodoList> get copyWith =>
      __$$_FetchTodoListCopyWithImpl<_$_FetchTodoList>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int offset, int limit, String sortBy, bool isAsc, TodoStatus status)
        fetchTodoList,
  }) {
    return fetchTodoList(offset, limit, sortBy, isAsc, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int offset, int limit, String sortBy, bool isAsc,
            TodoStatus status)?
        fetchTodoList,
  }) {
    return fetchTodoList?.call(offset, limit, sortBy, isAsc, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int offset, int limit, String sortBy, bool isAsc,
            TodoStatus status)?
        fetchTodoList,
    required TResult orElse(),
  }) {
    if (fetchTodoList != null) {
      return fetchTodoList(offset, limit, sortBy, isAsc, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FetchTodoList value) fetchTodoList,
  }) {
    return fetchTodoList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FetchTodoList value)? fetchTodoList,
  }) {
    return fetchTodoList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FetchTodoList value)? fetchTodoList,
    required TResult orElse(),
  }) {
    if (fetchTodoList != null) {
      return fetchTodoList(this);
    }
    return orElse();
  }
}

abstract class _FetchTodoList extends ApiHolder {
  const factory _FetchTodoList(
      {required final int offset,
      required final int limit,
      required final String sortBy,
      required final bool isAsc,
      required final TodoStatus status}) = _$_FetchTodoList;
  const _FetchTodoList._() : super._();

  @override
  int get offset;
  @override
  int get limit;
  @override
  String get sortBy;
  @override
  bool get isAsc;
  @override
  TodoStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$_FetchTodoListCopyWith<_$_FetchTodoList> get copyWith =>
      throw _privateConstructorUsedError;
}
