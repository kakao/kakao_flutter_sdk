package com.kakao.sdk.flutter.auth

import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import android.os.ResultReceiver
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.content.IntentCompat
import androidx.core.net.toUri
import androidx.core.os.bundleOf
import androidx.fragment.app.FragmentActivity

open class CustomTabsActivity : FragmentActivity() {
    private var receiver: ResultReceiver? = null
    private var activityName: String? = null
    private var customTabsOpened = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        activityName = intent.getStringExtra(Constants.KEY_ACTIVITY_NAME)
        receiver = IntentCompat.getParcelableExtra(
            intent,
            Constants.KEY_RESULT_RECEIVER,
            ResultReceiver::class.java
        )
        val url = intent.getStringExtra(Constants.KEY_URL) ?: run {
            sendError(
                "INVALID_REQUEST",
                "No URL was passed to AuthCodeHandlerActivity."
            )
            return
        }

        try {
            val customTabsIntent = CustomTabsIntent.Builder()
                .setUrlBarHidingEnabled(true)
                .setShowTitle(true)
                .build()

            customTabsIntent.launchUrl(this, url.toUri())
        } catch (_: ActivityNotFoundException) {
            sendError(
                "ACTIVITY_NOT_FOUND",
                "No activity found to handle custom tabs intent."
            )
        }
    }

    override fun onResume() {
        super.onResume()

        if (!customTabsOpened) {
            customTabsOpened = true
        } else {
            // User returned without completing login (ex - back button press)
            sendError("CANCELED", "User canceled login.")
        }
    }

    fun sendOk(url: String) {
        receiver?.send(RESULT_OK, bundleOf(Constants.KEY_RESULT_URL to url))
        finishAndRemoveTask()
    }

    fun sendError(errorCode: String, errorMessage: String) {
        val resultData = bundleOf(
            Constants.KEY_ERROR_CODE to errorCode,
            Constants.KEY_ERROR_MESSAGE to errorMessage,
        )

        receiver?.send(RESULT_CANCELED, resultData)
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