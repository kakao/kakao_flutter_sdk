import 'package:example/api/sdk_picker_api.dart';
import 'package:example/api/sdk_talk_api.dart';
import 'package:example/api/sdk_web_login_api.dart';
import 'package:example/api/sdk_web_sharer_api.dart';
import 'package:example/model/custom_data.dart';
import 'package:example/model/list_item.dart';
import 'package:flutter/foundation.dart';

import 'sdk_navi_api.dart';
import 'sdk_share_api.dart';
import 'sdk_sync_api.dart';
import 'sdk_user_api.dart';

List<ListItem> createSdkApis(CustomData customData) => <ListItem>[
  if (kIsWeb) ...[...createWebLoginApis(customData)],
  ...createUserApis(customData),
  ...createShareApis(customData),
  ...createTalkApis(customData),
  ...pickerApis,
  ...createWebSharerApis(customData),
  ...naviApis,
  ...syncApis,
];
