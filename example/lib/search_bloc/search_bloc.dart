import 'package:bloc/bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import 'package:kakao_flutter_sdk/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchApi _api;

  SearchBloc({SearchApi api})
      : _api = api ?? SearchApi.instance,
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is QueryEntered) {
      yield SearchLoading();
      try {
        final webResults = await _api.web(event.query);
        final images = await _api.image(event.query, size: 20);
        final blogs = await _api.blog(event.query);
        final books = await _api.book(event.query);
        yield SearchFetched(webResults, images, blogs, books);
      } on DapiException catch (e) {
        yield SearchErrored(e);
      }
    }
  }
}
