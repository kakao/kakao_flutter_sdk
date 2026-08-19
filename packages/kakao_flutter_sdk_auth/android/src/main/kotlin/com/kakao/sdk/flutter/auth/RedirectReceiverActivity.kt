package com.kakao.sdk.flutter.auth

import android.app.Activity
import android.content.Intent
import android.os.Bundle

abstract class RedirectReceiverActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        forwardAndFinish(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        forwardAndFinish(intent)
    }

    private fun forwardAndFinish(source: Intent?) {
        runCatching {
            startActivity(
                Intent(this, CustomTabsActivity::class.java).apply {
                    data = source?.data
                    addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK
                            or Intent.FLAG_ACTIVITY_CLEAR_TOP
                            or Intent.FLAG_ACTIVITY_SINGLE_TOP
                    )
                }
            )
        }
        finish()
    }
}
