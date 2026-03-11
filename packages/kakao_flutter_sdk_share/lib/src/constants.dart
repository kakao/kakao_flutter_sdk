/// @nodoc
class Constants {
  // API Paths
  static const String uploadImagePath = '/v2/api/talk/message/image/upload';
  static const String scrapImagePath = '/v2/api/talk/message/image/scrap';
  static const String validatePath = '/v2/api/kakaolink/talk/template';
  static const String sharerPath = 'talk/friends/picker/easylink';

  // Template Types
  static const String defaultTemplate = 'default';
  static const String validate = 'validate';
  static const String scrap = 'scrap';
  static const String custom = 'custom';

  // Template Parameters
  static const String templateId = 'template_id';
  static const String templateArgs = 'template_args';
  static const String templateObject = 'template_object';
  static const String templateJson = 'template_json';

  // Sharing Parameters
  static const String schemeParams = 'scheme_params';
  static const String list = 'list';
  static const String limit = 'limit';
  static const String requestUrl = 'request_url';

  // Image Upload Parameters
  static const String secureResource = 'secure_resource';
  static const String file = 'file';
  static const String imageUrl = 'image_url';

  // Link Version, App Info
  static const String linkVersion = 'link_ver';
  static const String linkVersion_40 = '4.0';
  static const String linkVer = 'linkver';
  static const String appKey = 'appkey';
  static const String appVer = 'appver';

  // Platform Specific Parameters
  static const String extras = 'extras';
  static const String ka = 'KA';
  static const String lcba = 'lcba';
  static const String appPkg = 'appPkg';
  static const String keyHash = 'keyHash';
  static const String iosBundleId = 'iosBundleId';

  // Template Message Keys
  static const String lv = 'lv';
  static const String av = 'av';
  static const String ak = 'ak';
  static const String P = 'P';
  static const String C = 'C';

  // Web Sharer Parameters
  static const String sharerAppKey = 'app_key';
  static const String sharerKa = 'ka';
  static const String validationAction = 'validation_action';
  static const String validationParams = 'validation_params';
}
