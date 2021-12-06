// import 'dart:async';
// import 'dart:html' as html;
// import 'package:flutter/services.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// class KakaoFlutterSdkPlugin {
//   static void registerWith(Registrar registrar) {
//     final MethodChannel channel = MethodChannel(
//         "kakao_flutter_sdk", const StandardMethodCodec(), registrar.messenger);

//     final KakaoFlutterSdkPlugin instance = KakaoFlutterSdkPlugin();
//     channel.setMethodCallHandler(instance.handleMethodCall);
//   }

//   Future<dynamic> handleMethodCall(MethodCall call) async {
//     switch (call.method) {
//       case "launchBrowserTab":
//         Map<dynamic, dynamic> args = call.arguments;
//         String uri = args["url"];
//         final fullUri = Uri.parse(uri);
//         Map<String, dynamic> queryParameters =
//             Map.from(fullUri.queryParameters);
//         queryParameters["redirect_uri"] = html.window.location.origin;
//         final finalUri = fullUri.replace(queryParameters: queryParameters);
//         html.window.open(finalUri.toString(), "KakaoAccountLogin");
//         final completer = Completer();
//         html.window.addEventListener("message", (html.Event e) {
//           if (e is html.MessageEvent) {
//             return completer.complete(e.data);
//           } else {
//             return completer.completeError(PlatformException(
//                 code: "NotMessageEvent",
//                 details: "Received wrong type of event ${e.runtimeType}"));
//           }
//         });
//         return completer.future;
//         break;
//       case "retrieveAuthCode":
//         final uri = Uri.parse(html.window.location.search);
//         final params = uri.queryParameters;
//         if (params.containsKey("code") || params.containsKey("error")) {
//           html.window.opener.postMessage(html.window.location.href, "*");
//           html.window.close();
//         }
//         break;
//       case "getOrigin":
//         return html.window.location.origin;
//         break;
//       case "getKaHeader":
//         return "os/javascript origin/${html.window.location.origin}";
//         break;
//       case "isKakaoTalkInstalled":
//         return false;
//         break;
//       default:
//         throw PlatformException(
//             code: "NotImplemented",
//             details:
//                 "KakaoFlutterSdk for web doesn't implement the method ${call.method}");
//     }
//   }
// }
