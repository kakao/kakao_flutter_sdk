import 'package:example/model/list_item.dart';
import 'package:go_router/go_router.dart';

final pickerApis = <ListItem>[
  const Header('PickerApi'),
  Api(
    'PickerApi Config',
    showResult: false,
    (context) => context.push('/picker/config'),
  ),
];
