import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_example/search_bloc/search_state.dart';

import 'search_bloc/bloc.dart';

class DataSearch extends SearchDelegate<String> {
  final Bloc<SearchEvent, SearchState> bloc;

  DataSearch(this.bloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    bloc.add(QueryEntered(query));
    return BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchErrored) {
            final snackBar = SnackBar(
              content: Text(state.exception.message),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is SearchInitial || state is SearchErrored) {
              return Center(child: Text("Search with Kakao Search API!"));
            }
            if (state is SearchLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is SearchErrored) {
              return Center(child: Text(state.exception.toJson().toString()));
            }
            if (state is SearchFetched) {
              return SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Text(
                    "Web pages",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.web),
                        title: Text(state.results.documents[index].title),
                        //  HtmlWidget(state.results.documents[index].title,
                        //     webView: false),
                      );
                    },
                    itemCount: state.results.documents.length,
                  ),
                  Text(
                    "Images",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: state.images.documents.map((image) {
                      return ListTile(
                          title: Image.network(
                        image.imageUrl.toString(),
                        width: 100,
                        height: 100,
                      ));
                    }).toList(),
                  ),
                  Text(
                    "Blogs",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.pages),
                        title: Text(state.blogs.documents[index].title),
                        // HtmlWidget(state.blogs.documents[index].title,
                        // webView: false),
                      );
                    },
                    itemCount: state.blogs.documents.length,
                  ),
                  Text(
                    "Books",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: Icon(Icons.book),
                          title: Text(state.books.documents[index].title)
                          // HtmlWidget(state.books.documents[index].title,
                          //     webView: false),
                          );
                    },
                    itemCount: state.books.documents.length,
                  )
                ],
              ));
            }
            return Container();
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search with Kakao Search API!"),
    );
  }
}
