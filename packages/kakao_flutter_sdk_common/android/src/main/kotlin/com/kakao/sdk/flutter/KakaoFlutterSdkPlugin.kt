package com.kakao.sdk.flutter

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class KakaoFlutterSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware,
    PluginRegistry.ActivityResultListener, EventChannel.StreamHandler,
    PluginRegistry.NewIntentListener {
    private var applicationContext: Context? = null
    private var activity: Activity? = null

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    private var result: Result? = null

    private var receiver: BroadcastReceiver? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result

        when (call.method) {
            "appVer" -> {
                try {
                    applicationContext?.let {
                        result.success(Utility.getAppVer(it))
                    } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
                } catch (e: PackageManager.NameNotFoundException) {
                    result.error("Name not found", e.message, null)
                }
            }

            "packageName" -> result.success(applicationContext?.packageName)
            "getOrigin" -> {
                applicationContext?.let {
                    result.success(Utility.getKeyHash(it))
                } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
            }

            "getKaHeader" -> {
                applicationContext?.let {
                    result.success(Utility.getKAHeader(it))
                } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
            }

            "launchBrowserTab" -> {
                val context = applicationContext ?: run {
                    result.error("Error", "Application is not attached to FlutterEngine", null)
                    return
                }

                val activity = activity ?: run {
                    result.error("Error", "Plugin is not attached to Activity", null)
                    return
                }

                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String?>

                val intent: Intent
                val requestCode: Int

                if (args.contains("redirect_uri")) {
                    intent = IntentFactory.customTabsForLogin(context, args)
                    requestCode = Constants.REQUEST_KAKAO_LOGIN
                } else {
                    intent = IntentFactory.customTabs(context, args)
                    requestCode = Constants.REQUEST_CUSTOM_TABS
                }

                activity.startActivityForResult(intent, requestCode)
            }

            "authorizeWithTalk" -> {
                try {
                    @Suppress("UNCHECKED_CAST")
                    val args = call.arguments as Map<String, String>
                    val talkPackageName = args["talkPackageName"] ?: Constants.TALK_PACKAGE

                    if (applicationContext == null) {
                        result.error("Error", "Application is not attached to FlutterEngine", null)
                        return
                    }

                    if (!Utility.isKakaoTalkInstalled(applicationContext!!, talkPackageName)) {
                        result.error(
                            "Error",
                            "KakaoTalk is not installed. If you want KakaoTalk Login, please install KakaoTalk",
                            null
                        )
                        return
                    }
                    val intent = IntentFactory.talkAuthCode(applicationContext!!, args)
                    activity?.startActivityForResult(intent, Constants.REQUEST_KAKAO_LOGIN)
                        ?: result.error("Error", "Plugin is not attached to Activity", null)
                } catch (e: Exception) {
                    result.error(e.javaClass.simpleName, e.localizedMessage, e)
                }
            }

            "isKakaoTalkInstalled" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val talkPackageName = args["talkPackageName"] ?: Constants.TALK_PACKAGE
                applicationContext?.let {
                    result.success(Utility.isKakaoTalkInstalled(it, talkPackageName))
                } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
            }

            "isKakaoNaviInstalled" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val naviPackageName = args["navi_origin"] ?: "com.locnall.KimGiSa"
                applicationContext?.let {
                    result.success(Utility.isKakaoNaviInstalled(it, naviPackageName))
                } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
            }

            "launchKakaoTalk" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val talkPackageName = args["talkPackageName"] ?: Constants.TALK_PACKAGE
                if (applicationContext == null) {
                    result.error("Error", "Application is not attached to FlutterEngine", null)
                    return
                }

                if (!Utility.isKakaoTalkInstalled(applicationContext!!, talkPackageName)) {
                    result.success(false)
                    return
                }
                val uri = args["uri"]
                    ?: throw IllegalArgumentException("KakaoTalk uri scheme is required.")
                val intent = Intent(
                    Intent.ACTION_SEND,
                    Uri.parse(uri)
                ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                applicationContext?.startActivity(intent)
                result.success(true)
            }

            "addChannel" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val scheme = args["channel_scheme"] ?: Constants.CHANNEL_SCHEME
                val channelPublicId = args["channel_public_id"]
                val uri = Uri.parse("$scheme/home/$channelPublicId/add")

                try {
                    activity?.startActivity(Intent(Intent.ACTION_VIEW, uri)) ?: run {
                        result.error("Error", "Plugin is not attached to Activity", null)
                    }
                } catch (e: ActivityNotFoundException) {
                    result.error(
                        "Error",
                        "KakaoTalk is not installed. please install KakaoTalk",
                        null
                    )
                }
            }

            "channelChat" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val scheme = args["channel_scheme"] ?: Constants.CHANNEL_SCHEME
                val channelPublicId = args["channel_public_id"]
                val uri = Uri.parse("$scheme/talk/chat/$channelPublicId")

                try {
                    activity?.startActivity(Intent(Intent.ACTION_VIEW, uri)) ?: run {
                        result.error("Error", "Plugin is not attached to Activity", null)
                    }
                } catch (e: ActivityNotFoundException) {
                    result.error(
                        "Error",
                        "KakaoTalk is not installed. please install KakaoTalk",
                        null
                    )
                }
            }

            "isKakaoTalkSharingAvailable" -> {
                applicationContext?.let {
                    val uriBuilder = Uri.Builder().scheme("kakaolink").authority("send")
                    val kakaotalkIntentClient = IntentResolveClient.instance
                    val isKakaoTalkSharingAvailable = kakaotalkIntentClient.resolveTalkIntent(
                        it,
                        Intent(Intent.ACTION_VIEW, uriBuilder.build())
                    ) != null
                    result.success(isKakaoTalkSharingAvailable)
                } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
            }

            "navigate" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val (scheme, authority) = (args["navi_scheme"] ?: "kakaonavi-sdk://navigate").split(
                    "://"
                )
                val appKey = args["app_key"]
                val extras = args["extras"]
                val params = args["navi_params"]
                val uri =
                    Utility.naviBaseUriBuilder(scheme, authority, appKey, extras, params).build()
                val intent = Intent(Intent.ACTION_VIEW, uri)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                try {
                    applicationContext?.startActivity(intent)
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.error("Error", "KakaoNavi not installed", null)
                }
            }

            "shareDestination" -> {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String>
                val (scheme, authority) = (args["navi_scheme"] ?: "kakaonavi-sdk://navigate").split(
                    "://"
                )
                val appKey = args["app_key"]
                val extras = args["extras"]
                val params = args["navi_params"]
                val uri =
                    Utility.naviBaseUriBuilder(scheme, authority, appKey, extras, params).build()
                val intent = Intent(
                    Intent.ACTION_VIEW,
                    uri
                ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                try {
                    applicationContext?.startActivity(intent)
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.error("Error", "KakaoNavi not installed", null)
                }
            }

            "platformId" -> {
                try {
                    applicationContext?.let {
                        result.success(Utility.platformId(it))
                    } ?: result.error("Error", "Application is not attached to FlutterEngine", null)
                } catch (e: Exception) {
                    result.error("Error", "Can't get androidId", null)
                }
            }

            "receiveKakaoScheme" -> {
                activity?.let {
                    result.success(handleTalkSharingIntent(it, it.intent))
                } ?: result.error("Error", "Plugin is not attached to Activity", null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == Constants.REQUEST_KAKAO_LOGIN && data != null) {
            return when (resultCode) {
                Activity.RESULT_OK -> {
                    resultOk(result, data)
                    return true
                }

                Activity.RESULT_CANCELED -> {
                    resultCanceled(result, data)
                    return true
                }

                else -> false
            }
        } else if (requestCode == Constants.REQUEST_CUSTOM_TABS) {
            return when (resultCode) {
                Activity.RESULT_OK -> {
                    resultOk(result, data)
                    true
                }

                Activity.RESULT_CANCELED -> {
                    resultCanceled(result, data)
                    true
                }

                else -> false
            }
        }
        return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        receiver = KakaoSchemeReceiver(events)
    }

    override fun onCancel(arguments: Any?) {
        receiver = null
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        this.applicationContext = applicationContext
        methodChannel = MethodChannel(messenger, Constants.METHOD_CHANNEL)
        methodChannel?.setMethodCallHandler(this)

        eventChannel = EventChannel(messenger, Constants.EVENT_CHANNEL)
        eventChannel?.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null

        eventChannel?.setStreamHandler(null)
        eventChannel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
        binding.addOnNewIntentListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
        binding.addOnNewIntentListener(this)
        handleTalkSharingIntent(binding.activity, binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun handleTalkSharingIntent(context: Context, intent: Intent): String? {
        val action = intent.action
        val dataString = intent.dataString

        return if (Intent.ACTION_VIEW == action && dataString?.startsWith("kakao") == true &&
            dataString.contains("kakaolink")
        ) {
            receiver?.onReceive(context, intent)
            dataString
        } else {
            null
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        if (activity != null && handleTalkSharingIntent(activity!!, intent) != null) {
            return true
        }
        return false
    }

    private fun resultOk(result: Result?, data: Intent?) {
        val url = data?.getStringExtra(Constants.KEY_RETURN_URL)
        result?.success(url)
    }

    private fun resultCanceled(result: Result?, data: Intent?) {
        val errorCode = data?.getStringExtra(Constants.KEY_ERROR_CODE) ?: "ERROR"
        val errorMessage = data?.getStringExtra(Constants.KEY_ERROR_MESSAGE)
        result?.error(errorCode, errorMessage, null)
    }
}
