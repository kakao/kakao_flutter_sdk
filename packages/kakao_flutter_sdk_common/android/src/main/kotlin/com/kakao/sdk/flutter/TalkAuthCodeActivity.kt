package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.ResultReceiver
import android.view.Window

class TalkAuthCodeActivity : Activity() {
    private var resultReceiver: ResultReceiver? = null
    private var activityName: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_talk_auth_code)
        val sdkVersion = intent.extras?.getString(Constants.KEY_SDK_VERSION)
        val clientId = intent.extras?.getString(Constants.KEY_CLIENT_ID)
            ?: throw IllegalArgumentException("Client id is required.")
        val redirectUri = intent.extras?.getString(Constants.KEY_REDIRECT_URI)
            ?: throw IllegalArgumentException("Redirect uri is required.")
        val extra = intent.extras?.getBundle(Constants.KEY_EXTRAS) ?: Bundle()

        activityName = intent.getStringExtra(Constants.ACTIVITY_NAME)

        resultReceiver = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.extras?.getBundle(Constants.KEY_BUNDLE)
                ?.getParcelable(Constants.KEY_RESULT_RECEIVER, ResultReceiver::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.extras?.getBundle(Constants.KEY_BUNDLE)
                ?.getParcelable(Constants.KEY_RESULT_RECEIVER)
        }

        val loginIntent = Utility.talkLoginIntent(
            clientId,
            redirectUri,
            "$sdkVersion ${Utility.getKAHeader(this)}",
            extra
        )
        startActivityForResult(loginIntent, Constants.REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (data == null || resultCode == RESULT_CANCELED) {
            sendError("CANCELED", "User canceled login.")
            return
        }
        if (resultCode == RESULT_OK) {
            val extras = data.extras
            if (extras == null) {
                // no result returned from kakaotalk
                sendError("EUNKNOWN", "No result returned from KakaoTalk.")
                return
            }
            val error = extras.getString(Constants.EXTRA_ERROR_TYPE)
            val errorDescription =
                extras.getString(Constants.EXTRA_ERROR_DESCRIPTION) ?: "No error description."
            if (error != null) {
                sendError(error, errorDescription)
                return
            }
            val redirectUrl = extras.getString(Constants.EXTRA_REDIRECT_URL)
            sendOk(redirectUrl)
            overridePendingTransition(0, 0)
            return
        }
        throw IllegalStateException("Unexpected data from KakaoTalk in onActivityResult. $data")
    }

    private fun sendOk(url: String?) {
        resultReceiver?.send(RESULT_OK, Bundle().apply {
            putParcelable(Constants.KEY_URL, Uri.parse(url))
        })
        finishAndRemoveTask()
    }

    private fun sendError(errorCode: String, errorMessage: String) {
        resultReceiver?.send(RESULT_CANCELED, Bundle().apply {
            putString(Constants.KEY_ERROR_CODE, errorCode)
            putString(Constants.KEY_ERROR_MESSAGE, errorMessage)
        })
        finishAndRemoveTask()
    }

    override fun finishAndRemoveTask() {
        super.finishAndRemoveTask()

        // To return to the app's Activity when the app's Activity and the current Activity's task are different
        runCatching {
            val activityClass = activityName?.let { Class.forName(it) }
            val intent = Intent(this, activityClass)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            startActivity(intent)
        }
    }
}
