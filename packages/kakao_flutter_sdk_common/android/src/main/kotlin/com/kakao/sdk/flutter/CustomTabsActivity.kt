package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Bundle
import android.util.Log

open class CustomTabsActivity : Activity() {
    private var fullUri: Uri? = null
    private var customTabsConnection: ServiceConnection? = null
    private var customTabsOpened = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try {
            val url = intent.getStringExtra(Constants.KEY_FULL_URI)
                ?: throw IllegalArgumentException("No uri was passed to CustomTabsActivity.")

            fullUri = Uri.parse(url)
        } catch (e: Throwable) {
            Log.e(e.javaClass.simpleName, e.toString())
            sendError(e.javaClass.simpleName, e.localizedMessage)
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putBoolean(Constants.KEY_CUSTOM_TABS_OPENED, customTabsOpened)
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        customTabsOpened =
            savedInstanceState.getBoolean(Constants.KEY_CUSTOM_TABS_OPENED, customTabsOpened)
    }

    override fun onResume() {
        super.onResume()

        if (!customTabsOpened) {
            customTabsOpened = true

            fullUri?.let {
                openChromeCustomTab(it)
            } ?: run {
                Log.e("CustomTabs", "url has been not initialized.")
                sendError("CustomTabs", "url has been not initialized.")
            }
        } else {
            sendError("CANCELED", "User canceled.")
        }
    }

    private fun openChromeCustomTab(uri: Uri) {
        try {
            customTabsConnection = CustomTabsCommonClient.openWithDefault(this, uri)
        } catch (e: Exception) {
            try {
                CustomTabsCommonClient.open(this, uri)
            } catch (e: Exception) {
                sendError("EUNKNOWN", e.localizedMessage)
            }
        }
    }

    protected fun sendError(errorCode: String, errorMessage: String?) {
        val data = Intent().putExtra(Constants.KEY_ERROR_CODE, errorCode)
            .putExtra(Constants.KEY_ERROR_MESSAGE, errorMessage)
        setResult(RESULT_CANCELED, data)
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        customTabsConnection?.let { unbindService(it) }
    }
}
