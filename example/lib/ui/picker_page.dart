import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_friend.dart';

@immutable
class PickerPage extends StatefulWidget {
  final String? result;
  final String? error;

  const PickerPage({super.key, this.result, this.error});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

const double titleWidth = 140;

class _PickerPageState extends State<PickerPage> {
  final TextEditingController _titleController =
      TextEditingController(text: '친구 선택');
  bool _showMyProfile = true;
  bool _enableSearch = true;
  bool _showFavorite = true;
  bool _showPickedFriend = true;
  bool _isPopupPicker = true;
  final TextEditingController _maxPickableCountController =
      TextEditingController(text: '30');
  final TextEditingController _minPickableCountController =
      TextEditingController(text: '1');
  bool _enableBackButton = true;
  final TextEditingController _returnUrlController = TextEditingController();
  String? response;

  @override
  void initState() {
    super.initState();

    setState(() {
      response = widget.result ?? widget.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picker Test')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderTextFieldList('title', _titleController),
            BoolRadioListTile(
              title: 'enableSearch',
              defaultValue: _enableSearch,
              callback: (value) => _enableSearch = value,
            ),
            BoolRadioListTile(
              title: 'showMyProfile',
              defaultValue: _showMyProfile,
              callback: (value) => _showMyProfile = value,
            ),
            BoolRadioListTile(
              title: 'showFavorite',
              defaultValue: _showFavorite,
              callback: (value) => _showFavorite = value,
            ),
            BoolRadioListTile(
              title: 'showPickedFriend',
              defaultValue: _showPickedFriend,
              callback: (value) => _showPickedFriend = value,
            ),
            _renderTextFieldList(
              'maxPickableCount',
              _maxPickableCountController,
              isText: false,
            ),
            _renderTextFieldList(
              'minPickableCount',
              _minPickableCountController,
              isText: false,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Column(
                children: [
                  Text('NATIVE(Android/iOS) or WEB REDIRECT ONLY'),
                  Divider(height: 2, thickness: 2),
                ],
              ),
            ),
            BoolRadioListTile(
              title: 'enableBackButton',
              defaultValue: _enableBackButton,
              callback: (value) => _enableBackButton = value,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Column(
                children: [
                  Text('WEB REDIRECT ONLY'),
                  Divider(height: 2, thickness: 2),
                ],
              ),
            ),
            _renderTextFieldList('returnUrl', _returnUrlController),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Column(
                children: [
                  Text('팝업/리다이렉트 피커 설정 (실제로는 없는 테스트용 파라미터)'),
                  Divider(height: 2, thickness: 2),
                ],
              ),
            ),
            BoolRadioListTile(
              title: 'Popup Picker',
              defaultValue: _isPopupPicker,
              callback: (value) => _isPopupPicker = value,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    PickerFriendRequestParams params = _createPickerParams(
                      popupPicker: _isPopupPicker,
                    );
                    var users = await PickerApi.instance
                        .selectFriend(params: params, context: context);
                    setState(() {
                      if (users != null) {
                        response = '${users.toJson()}';
                      } else {
                        response = widget.result;
                      }
                    });
                  } catch (e) {
                    setState(() {
                      response = e.toString();
                    });
                  }
                },
                child: const Text('싱글 피커'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  PickerFriendRequestParams params = _createPickerParams(
                    popupPicker: _isPopupPicker,
                  );
                  try {
                    var users = await PickerApi.instance
                        .selectFriends(params: params, context: context);
                    setState(() {
                      if (users != null) {
                        response = '${users.toJson()}';
                      } else {
                        response = widget.result;
                      }
                    });
                  } catch (e) {
                    setState(() {
                      response = e.toString();
                    });
                  }
                },
                child: const Text('멀티 피커'),
              ),
            ),
            response == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(response!),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _renderTextFieldList(String title, TextEditingController controller,
      {bool isText = true}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(width: titleWidth, child: Text(title)),
          Expanded(
            // width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType:
                    isText ? TextInputType.text : TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PickerFriendRequestParams _createPickerParams({
    bool popupPicker = false,
  }) {
    return PickerFriendRequestParams(
      title: _titleController.text.isEmpty ? null : _titleController.text,
      enableSearch: _enableSearch,
      showMyProfile: _showMyProfile,
      showFavorite: _showFavorite,
      showPickedFriend: _showPickedFriend,
      maxPickableCount: int.parse(_maxPickableCountController.text),
      minPickableCount: int.parse(_minPickableCountController.text),
      enableBackButton: _enableBackButton,
      returnUrl: popupPicker
          ? null
          : (_returnUrlController.text.isEmpty
              ? null
              : _returnUrlController.text),
    );
  }
}

@immutable
class BoolRadioListTile extends StatefulWidget {
  final String title;
  final bool defaultValue;
  final Function(bool) callback;

  const BoolRadioListTile(
      {super.key,
      required this.title,
      required this.defaultValue,
      required this.callback});

  @override
  State<BoolRadioListTile> createState() => _BoolRadioListTileState();
}

class _BoolRadioListTileState extends State<BoolRadioListTile> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.defaultValue;
    widget.callback(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(width: titleWidth, child: Text(widget.title)),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRadioButton(true),
              _buildRadioButton(false),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildRadioButton(bool radioValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentValue = radioValue;
          widget.callback(_currentValue);
        });
      },
      child: Row(
        children: [
          Radio(
            value: radioValue,
            groupValue: _currentValue,
            onChanged: (bool? value) {
              setState(() {
                _currentValue = value!;
                widget.callback(_currentValue);
              });
            },
          ),
          Text('$radioValue'),
        ],
      ),
    );
  }
}
