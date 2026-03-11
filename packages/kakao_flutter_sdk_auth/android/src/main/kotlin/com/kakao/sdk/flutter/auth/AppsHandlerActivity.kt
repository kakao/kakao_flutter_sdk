package com.kakao.sdk.flutter.auth

import android.content.Intent
import android.os.Bundle

class AppsHandlerActivity : CustomTabsActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        intent.dataString?.let {
            sendOk(it)
        }
    }
}