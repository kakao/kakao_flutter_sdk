package com.kakao.sdk.flutter

import android.annotation.SuppressLint
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
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
import java.security.MessageDigest

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
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as Map<String, String?>
                val uri = args["url"] as String
                val redirectUrl = args["redirect_uri"]
                val intent = Intent(activity, AuthCodeCustomTabsActivity::class.java)
                    .putExtra(Constants.KEY_FULL_URI, uri)
                    .putExtra(Constants.KEY_REDIRECT_URL, redirectUrl)
                activity?.startActivityForResult(intent, Constants.REQUEST_KAKAO_LOGIN)
                    ?: result.error("Error", "Plugin is not attached to Activity", null)

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

                    if (!Utility.isKakaoTalkInstalled(
                            applicationContext!!,
                            talkPackageName
                        )
                    ) {
                        result.error(
                            "Error",
                            "KakaoTalk is not installed. If you want KakaoTalk Login, please install KakaoTalk",
                            null
                        )
                        return
                    }
                    val sdkVersion = args["sdk_version"]
                        ?: throw IllegalArgumentException("Sdk version id is required.")
                    val clientId = args["client_id"]
                        ?: throw IllegalArgumentException("Client id is required.")
                    val redirectUri = args["redirect_uri"]
                        ?: throw IllegalArgumentException("Redirect uri is required.")
                    val channelPublicIds = args["channel_public_ids"]
                    val serviceTerms = args["service_terms"]
                    val approvalType = args["approval_type"]
                    val codeVerifier = args["code_verifier"]
                    val prompts = args["prompt"]
                    val state = args["state"]
                    val nonce = args["nonce"]
                    val settleId = args["settle_id"]
                    val extras = Bundle().apply {
                        channelPublicIds?.let { putString(Constants.CHANNEL_PUBLIC_ID, it) }
                        serviceTerms?.let { putString(Constants.SERVICE_TERMS, it) }
                        approvalType?.let { putString(Constants.APPROVAL_TYPE, it) }
                        codeVerifier?.let {
                            putString(Constants.CODE_CHALLENGE, codeChallenge(it.toByteArray()))
                            putString(
                                Constants.CODE_CHALLENGE_METHOD,
                                Constants.CODE_CHALLENGE_METHOD_VALUE
                            )
                        }
                        prompts?.let { putString(Constants.PROMPT, it) }
                        state?.let { putString(Constants.STATE, it) }
                        nonce?.let { putString(Constants.NONCE, it) }
                        settleId?.let { putString(Constants.SETTLE_ID, it) }
                    }
                    val intent = Intent(activity, TalkAuthCodeActivity::class.java)
                        .putExtra(Constants.KEY_SDK_VERSION, sdkVersion)
                        .putExtra(Constants.KEY_CLIENT_ID, clientId)
                        .putExtra(Constants.KEY_REDIRECT_URI, redirectUri)
                        .putExtra(Constants.KEY_EXTRAS, extras)
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
                val intent = Intent(Intent.ACTION_SEND, Uri.parse(uri))
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                applicationContext?.startActivity(intent)
                result.success(true)
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
                val uri = naviBaseUriBuilder(scheme, authority, appKey, extras, params).build()
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
                val uri = naviBaseUriBuilder(scheme, authority, appKey, extras, params).build()
                val intent = Intent(Intent.ACTION_VIEW, uri)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                try {
                    applicationContext?.startActivity(intent)
                    result.success(true)
                } catch (e: ActivityNotFoundException) {
                    result.error("Error", "KakaoNavi not installed", null)
                }
            }

            "platformId" -> {
                try {
                    @SuppressLint("HardwareIds")
                    val androidId = Settings.Secure.getString(
                        applicationContext?.contentResolver,
                        Settings.Secure.ANDROID_ID
                    )
                    val stripped = androidId.replace("[0\\s]".toRegex(), "")
                    val md = MessageDigest.getInstance("SHA-256")
                    md.reset()
                    md.update("SDK-$stripped".toByteArray())
                    result.success(md.digest())
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
                    val url = data.getStringExtra(Constants.KEY_RETURN_URL)
                    result?.success(url)
                    true
                }

                Activity.RESULT_CANCELED -> {
                    val errorCode = data.getStringExtra(Constants.KEY_ERROR_CODE) ?: "ERROR"
                    val errorMessage = data.getStringExtra(Constants.KEY_ERROR_MESSAGE)
                    result?.error(errorCode, errorMessage, null)
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

        return if (Intent.ACTION_VIEW == action && dataString?.startsWith("kakao") == true
            && (dataString.contains("kakaolink") || dataString.contains("kakaostory"))
        ) {
            receiver?.onReceive(context, intent)
            dataString
        } else {
            null
        }
    }

    private fun codeChallenge(codeVerifier: ByteArray): String =
        Base64.encodeToString(
            MessageDigest.getInstance(Constants.CODE_CHALLENGE_ALGORITHM).digest(codeVerifier),
            Base64.NO_WRAP or Base64.NO_PADDING or Base64.URL_SAFE
        )

    private fun naviBaseUriBuilder(
        scheme: String,
        authority: String,
        appKey: String?,
        extras: String?,
        params: String?,
    ): Uri.Builder {
        return Uri.Builder().scheme(scheme).authority(authority)
            .appendQueryParameter(Constants.PARAM, params)
            .appendQueryParameter(Constants.APIVER, Constants.APIVER_10)
            .appendQueryParameter(Constants.APPKEY, appKey)
            .appendQueryParameter(Constants.EXTRAS, extras)
    }

    override fun onNewIntent(intent: Intent): Boolean {
        if (activity != null && handleTalkSharingIntent(activity!!, intent) != null) {
            return true
        }
        return false
    }
}
