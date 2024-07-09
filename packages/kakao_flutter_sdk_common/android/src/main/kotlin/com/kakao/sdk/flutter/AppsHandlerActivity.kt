package com.kakao.sdk.flutter

import android.content.Intent

class AppsHandlerActivity : CustomTabsActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        intent.dataString?.let {
            sendOk(it)
            // If MainActivity and the current Activity have different taskAffinity settings, tasks are left behind when finish() is called
            finishAndRemoveTask()
        }
    }
}
