import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class QueryEntered extends SearchEvent {
  final String query;
  QueryEntered(this.query) : super([query]);
}
