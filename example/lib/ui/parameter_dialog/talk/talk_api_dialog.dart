import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/radio_button_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/dialog_item/text_field_item.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/parameter_dialog.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/talk/talk_api_methods.dart';
import 'package:kakao_flutter_sdk_example/ui/parameter_dialog/talk/talk_api_parameter.dart';

class TalkApiDialog extends StatelessWidget {
  final String title;

  final bool offsetVisibility;
  final bool limitVisibility;
  final bool orderVisibility;
  final bool friendOrderVisibility;
  final bool channelPublicIdVisibility;
  final bool publicIdsVisibility;
  final Map<String, Object> result = {};

  final String? publicIds;
  final Order? order = Order.asc;

  TalkApiDialog(this.title, {super.key, this.publicIds})
      : offsetVisibility = friends == title,
        limitVisibility = friends == title,
        orderVisibility = friends == title,
        friendOrderVisibility = friends == title,
        channelPublicIdVisibility = {
          followChannel,
          addChannel,
          channelChat,
          addChannelUrl,
          channelChatUrl
        }.contains(title),
        publicIdsVisibility = channels == title;

  @override
  Widget build(BuildContext context) {
    return ParameterDialog(
      title: title,
      callback: (parameters) => _parameterResult(),
      items: [
        TextFieldItem(
          title: 'offset',
          visible: offsetVisibility,
          fontSize: 12.0,
          onValueChanged: (value) => result['offset'] = value,
        ),
        TextFieldItem(
          title: 'limit',
          visible: limitVisibility,
          fontSize: 12.0,
          onValueChanged: (value) => result['limit'] = value,
        ),
        RadioButtonItem<Order>(
          title: 'order',
          visible: orderVisibility,
          fontSize: 12.0,
          onValueChanged: (value) {
            if (value != null) {
              result['order'] = value;
            }
          },
          items: Order.values,
        ),
        RadioButtonItem<FriendOrder>(
          title: 'friendOrder',
          visible: friendOrderVisibility,
          fontSize: 10.0,
          onValueChanged: (value) {
            if (value != null) {
              result['friendOrder'] = value;
            }
          },
          items: FriendOrder.values,
        ),
        TextFieldItem(
          title: 'publicIds',
          visible: publicIdsVisibility,
          fontSize: 12.0,
          onValueChanged: (value) => result['publicIds'] = value,
        ),
        TextFieldItem(
          title: 'channelPublicId',
          visible: channelPublicIdVisibility,
          fontSize: 8.0,
          text: publicIds,
          switchChecked: true,
          onValueChanged: (value) => result['channelPublicId'] = value,
        ),
      ],
    );
  }

  TalkApiParameter? _parameterResult() {
    return TalkApiParameter(
      offset: int.tryParse((result['offset'] as String?) ?? ''),
      limit: int.tryParse((result['limit'] as String?) ?? ''),
      order: result['order'] as Order?,
      friendOrder: result['friendOrder'] as FriendOrder?,
      channelPublicId:
          (result['channelPublicId'] as String?) ?? publicIds ?? '',
      publicIds: (result['publicIds'] as String?)?.split(','),
    );
  }
}
