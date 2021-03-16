import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/talk.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/bloc.dart';

class TalkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: BlocBuilder<TalkBloc, TalkState>(
                builder: (context, state) {
                  if (state is TalkProfileFetched) {
                    return TalkProfileBox(state.profile);
                  }
                  return Container();
                },
              ),
            ),
            BlocBuilder<FriendsBloc, FriendsState>(
              builder: (context, state) {
                if (state is FriendsPermissionRequired) {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text("Following scopes are required: ${state.scopes}"),
                        RaisedButton(
                          onPressed: () => BlocProvider.of<FriendsBloc>(context)
                              .add(RequestAgreement(state.scopes)),
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text("Request scopes"),
                        )
                      ],
                    ),
                  );
                }
                if (state is FriendsFetched) {
                  final _friends = state.friends;
                  return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey),
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        final friend = _friends[index];

                        return GestureDetector(
                            onTap: () => {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(children: <Widget>[
                                CircleAvatar(
                                    radius: 25,
                                    backgroundImage: friend
                                            .profileThumbnailImage
                                            .toString()
                                            .isNotEmpty
                                        ? NetworkImage(friend
                                            .profileThumbnailImage
                                            .toString())
                                        : AssetImage("assets/images/cat2.png")),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(friend.profileNickname),
                                )
                              ]),
                            ));
                      });
                }
                return Container();
              },
            )
          ],
        ),
      );
}

//   _customMemo() async {
//     try {
//       await TalkApi.instance
//           .customMemo(17125, {"MESSAGE_TITLE": "FROM Flutter SDK Example"});
//     } catch (e) {}
//   }

//   _defaultMemo() async {
//     FeedTemplate template = FeedTemplate(Content(
//         "Default Feed Template",
//         "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png",
//         Link()));
//     try {
//       await TalkApi.instance.defaultMemo(template);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

class TalkProfileBox extends StatelessWidget {
  TalkProfileBox(this._profile);
  final TalkProfile _profile;
  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text(_profile.nickname),
        accountEmail: Text(_profile.countryISO),
        currentAccountPicture: CircleAvatar(
            radius: 40,
            backgroundImage: _profile.thumbnailUrl != null &&
                    _profile.thumbnailUrl.toString().isNotEmpty
                ? NetworkImage(_profile.thumbnailUrl.toString())
                : AssetImage("assets/images/cat2.png")));
  }
}
