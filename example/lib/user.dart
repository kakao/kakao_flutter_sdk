import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk_example/user_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/user_bloc/user_bloc.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserState();
  }
}

class _UserState extends State<UserScreen> {
  // User _user;
  AccessTokenInfo _tokenInfo;

  @override
  void initState() {
    super.initState();
    _getTokenInfo();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<UserBloc>(context);
          if (state is UserFetched) {
            final _user = state.user;
            return Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                        accountEmail: _user.kakaoAccount.email == null
                            ? null
                            : Text(_user.kakaoAccount.email),
                        accountName: Text(_user.properties != null &&
                                _user.properties['nickname'] != null
                            ? _user.properties['nickname']
                            : _user.kakaoAccount.profile.nickname),
                        currentAccountPicture: CircleAvatar(
                            radius: 40,
                            backgroundImage: _user.properties != null &&
                                    _user.properties["profile_image"] != null
                                ? NetworkImage(
                                    _user.properties["profile_image"])
                                : NetworkImage(_user
                                    .kakaoAccount.profile.profileImageUrl))),
                    _user != null ? Text(_user.id.toString()) : Container(),
                    TokenInfoBox(_tokenInfo),
                    RaisedButton(
                      child: Text("Logout"),
                      onPressed: () => bloc.add(UserLogOut()),
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      child: Text("Unlink"),
                      onPressed: () => bloc.add(UserUnlink()),
                      color: Colors.red,
                      textColor: Colors.white,
                    ),
                  ],
                ));
          }
          return Container();
        },
      );

  _getTokenInfo() async {
    try {
      var tokenInfo = await UserApi.instance.accessTokenInfo();
      setState(() {
        _tokenInfo = tokenInfo;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

class TokenInfoBox extends StatelessWidget {
  TokenInfoBox(this.tokenInfo);

  final AccessTokenInfo tokenInfo;

  @override
  Widget build(BuildContext context) {
    if (tokenInfo == null) return Container();
    return Column(
      children: <Widget>[
        Text("App id: ${tokenInfo.appId}"),
        Text("Token expires in: ${tokenInfo.expiresIn} seconds.")
      ],
    );
  }
}
