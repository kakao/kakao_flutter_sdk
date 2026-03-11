package com.kakao.sdk.flutter.auth

import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import android.os.ResultReceiver
import android.view.Window
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.IntentCompat
import androidx.core.os.bundleOf
import androidx.fragment.app.FragmentActivity

class TalkAuthCodeActivity : FragmentActivity() {
    private var receiver: ResultReceiver? = null
    private val launcher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            handleAuthResult(result.resultCode, result.data)
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)


        receiver = IntentCompat.getParcelableExtra(
            intent,
            Constants.KEY_RESULT_RECEIVER,
            ResultReceiver::class.java
        )

        val talkIntent = IntentCompat.getParcelableExtra(
            intent,
            Constants.KEY_TALK_INTENT,
            Intent::class.java
        ) ?: run {
            receiver?.sendError("ILLEGAL_ARGUMENTS", "Talk intent is required.")
            finish()
            return
        }

        try {
            launcher.launch(talkIntent)
        } catch (_: ActivityNotFoundException) {
            receiver?.sendError("ACTIVITY_NOT_FOUND", "KakaoTalk is not installed.")
            finish()
        }
    }

    private fun handleAuthResult(resultCode: Int, data: Intent?) {
        val receiver = receiver ?: run {
            finish()
            return
        }

        if (resultCode == RESULT_CANCELED || data == null) {
            receiver.sendError("CANCELED", "User canceled login.")
            return
        }

        if (resultCode != RESULT_OK) {
            receiver.sendError("ERROR", "Login failed.")
            return
        }

        val extras = data.extras
        if (extras == null) {
            receiver.sendError("UNKNOWN", "No result returned from KakaoTalk.")
            return
        }

        val errorType = extras.getString(Constants.EXTRA_ERROR_TYPE)
        if (errorType != null) {
            val errorDescription = extras.getString(Constants.EXTRA_ERROR_DESCRIPTION) ?: "unknown"
            receiver.sendError(errorType, errorDescription)
            return
        }

        val redirectUrl = extras.getString(Constants.EXTRA_REDIRECT_URL)
        if (redirectUrl.isNullOrBlank()) {
            receiver.sendError("UNKNOWN", "No redirectUrl returned from KakaoTalk.")
            return
        }

        receiver.sendOk(redirectUrl)
    }

    private fun ResultReceiver.sendOk(url: String) {
        send(RESULT_OK, bundleOf(Constants.KEY_RESULT_URL to url))
        finish()
    }

    private fun ResultReceiver.sendError(errorCode: String, errorMessage: String) {
        send(
            RESULT_CANCELED,
            bundleOf(
                Constants.KEY_ERROR_CODE to errorCode,
                Constants.KEY_ERROR_MESSAGE to errorMessage,
            ),
        )
        finish()
    }
}