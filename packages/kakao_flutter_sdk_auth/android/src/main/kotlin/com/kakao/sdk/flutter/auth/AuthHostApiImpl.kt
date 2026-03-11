package com.kakao.sdk.flutter.auth

import android.app.Activity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver

class AuthHostApiImpl : AuthHostApi {
    private var activity: Activity? = null

    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    override fun authorizeWithKakaoTalk(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: List<String>?,
        serviceTerms: List<String>?,
        androidTalkPackageName: String,
        iosLoginScheme: String, // Unused in Android
        iosUniversalLink: String, // Unused in Android
        callback: (Result<String>) -> Unit
    ) {
        val activity = this.activity ?: run {
            callback(Result.failure(noActivityError()))
            return
        }

        val intent = IntentFactory.talkAuthActivity(
            context = activity,
            appKey = appKey,
            redirectUri = redirectUri,
            kaHeader = kaHeader,
            pkce = pkce,
            nonce = nonce,
            channelPublicIds = channelPublicIds,
            serviceTerms = serviceTerms,
            talkPackage = androidTalkPackageName,
            resultReceiver = createAuthResultReceiver(callback),
        )

        activity.startActivity(intent)
    }

    override fun authorize(url: String, redirectUri: String, callback: (Result<String>) -> Unit) {
        val activity = this.activity ?: run {
            callback(Result.failure(noActivityError()))
            return
        }

        val intent = IntentFactory.authCodeHandlerActivity(
            context = activity,
            url = url,
            redirectUri = redirectUri,
            resultReceiver = createAuthResultReceiver(callback),
        )
        activity.startActivity(intent)
    }

    override fun launchAppsUrl(url: String, callback: (Result<String>) -> Unit) {
        val activity = this.activity ?: run {
            callback(Result.failure(noActivityError()))
            return
        }

        val intent = IntentFactory.customTabsActivityIntent<AppsHandlerActivity>(
            context = activity,
            url = url,
            resultReceiver = createAuthResultReceiver(callback),
        )
        activity.startActivity(intent)
    }

    private fun createAuthResultReceiver(callback: (Result<String>) -> Unit): ResultReceiver {
        return object : ResultReceiver(Handler(Looper.getMainLooper())) {
            override fun onReceiveResult(resultCode: Int, resultData: Bundle?) {
                when (resultCode) {
                    Activity.RESULT_OK -> callback(onAuthOk(resultData))
                    else -> callback(onAuthError(resultData))
                }
            }
        }
    }

    private fun onAuthOk(resultData: Bundle?): Result<String> {
        val url = resultData?.getString(Constants.KEY_RESULT_URL)
        if (url.isNullOrBlank()) {
            return Result.failure(
                FlutterError("UNKNOWN", "No redirectUrl received.", null)
            )
        }
        return Result.success(url)
    }

    private fun onAuthError(resultData: Bundle?): Result<String> {
        val errorCode = resultData?.getString(Constants.KEY_ERROR_CODE) ?: "Unknown"
        val errorMessage = resultData?.getString(Constants.KEY_ERROR_MESSAGE) ?: "unknown error"
        return Result.failure(FlutterError(errorCode, errorMessage, null))
    }

    private fun noActivityError(): FlutterError {
        return FlutterError(
            "NO_ACTIVITY",
            "KakaoFlutterSdkAuthPlugin is not attached to an activity.",
            null,
        )
    }
}