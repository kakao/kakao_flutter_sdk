package com.kakao.sdk.flutter

import android.content.Intent
import android.os.Bundle
import android.util.Log

class AuthCodeCustomTabsActivity : CustomTabsActivity() {
    private var redirectUrl: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try {
            redirectUrl = intent.getStringExtra(Constants.KEY_REDIRECT_URL)
        } catch (e: Throwable) {
            Log.e(e.javaClass.simpleName, e.toString())
            sendError(e.javaClass.simpleName, e.localizedMessage)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        val url = intent.dataString
        if (redirectUrl != null && url?.startsWith(redirectUrl!!) == true) {
            sendOk(url)
        } else {
            sendError("REDIRECT_URI_MISMATCH", "Expected: $redirectUrl, Actual: $url")
        }
    }
}
