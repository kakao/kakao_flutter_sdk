package com.kakao.sdk.flutter

import android.content.Intent

class AppsHandlerActivity : CustomTabsActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        val url = intent.dataString
        val data = Intent().putExtra(Constants.KEY_RETURN_URL, url.toString())
        setResult(RESULT_OK, data)
        finish()
    }
}
