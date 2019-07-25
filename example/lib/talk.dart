import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/main.dart';

class TalkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TalkState();
  }
}

class TalkState extends State<TalkScreen> {
  TalkProfile _profile;
  List<Friend> _friends = List();

  @override
  void initState() {
    super.initState();
    _getTalkProfile();
    _getFriends();
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) return Container();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text(
                  "KakaoTalk Profile",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.right,
                ),
                TalkProfileBox(_profile)
              ],
            ),
          ),
          Text("Friends", style: TextStyle(fontSize: 15)),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];

                return GestureDetector(
                    onTap: () => _friendsClicked(friend.userId),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Image.network(
                          friend.profileThumbnailImage,
                          width: 40,
                          height: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(friend.profileNickname),
                        )
                      ]),
                    ));
              }),
        ],
      ),
    );
  }

  _friendsClicked(int userId) async {}

  _getTalkProfile() async {
    try {
      var profile = await TalkApi.instance.profile();

      setState(() {
        _profile = profile;
      });
    } on KakaoApiException catch (e) {
      if (e.code == ApiErrorCause.INVALID_TOKEN) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _getFriends() async {
    try {
      var res = await TalkApi.instance.friends();
      setState(() {
        _friends = res.friends;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _customMemo() async {
    try {
      await TalkApi.instance
          .customMemo(16761, {"MESSAGE_TITLE": "FROM Flutter SDK Example"});
    } catch (e) {}
  }

  _defaultMemo() async {
    FeedTemplate template = FeedTemplate(Content(
        "Default Feed Template",
        "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png",
        Link()));
    try {
      await TalkApi.instance.defaultMemo(template);
    } catch (e) {
      print(e.toString());
    }
  }
}

class TalkProfileBox extends StatelessWidget {
  TalkProfileBox(this._profile);
  final TalkProfile _profile;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                _profile.profileImageUrl,
                width: 100,
                height: 100,
              ),
              Text("${_profile.nickname} (${_profile.countryISO})"),
            ],
          )
        ],
      ),
    );
  }
}
