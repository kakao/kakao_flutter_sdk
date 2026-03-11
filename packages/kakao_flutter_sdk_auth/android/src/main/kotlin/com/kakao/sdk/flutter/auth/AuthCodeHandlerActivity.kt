package com.kakao.sdk.flutter.auth

import android.content.Intent
import android.os.Bundle

class AuthCodeHandlerActivity : CustomTabsActivity() {
    private var redirectUri: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        redirectUri = intent.getStringExtra(Constants.KEY_REDIRECT_URI) ?: run {
            sendError("INVALID_REQUEST", "No RedirectUri was passed to AuthCodeHandlerActivity.")
            return
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        println("onNewIntent called with intent: $intent")

        val url = intent.dataString
        if (redirectUri != null && url?.startsWith(redirectUri!!) == true) {
            sendOk(url)
        } else {
            sendError("MISMATCHED", "Expected RedirectUri: $redirectUri, Actual: $url")
        }
    }
}