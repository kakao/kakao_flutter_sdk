import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/search.dart';

@immutable
abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class SearchInitial extends SearchState {}

class SearchShown extends SearchState {}

class SearchLoading extends SearchState {}

class SearchFetched extends SearchState {
  final SearchEnvelope<WebResult> results;
  final SearchEnvelope<ImageResult> images;
  final SearchEnvelope<Blog> blogs;
  final SearchEnvelope<Book> books;

  SearchFetched(this.results, this.images, this.blogs, this.books)
      : super([results, images, blogs, books]);
}

class SearchErrored extends SearchState {
  final DapiException exception;
  SearchErrored(this.exception) : super([exception]);
}
