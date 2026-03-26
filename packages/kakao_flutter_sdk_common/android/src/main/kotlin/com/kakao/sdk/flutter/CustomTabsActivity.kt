package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver
import android.util.Log

open class CustomTabsActivity : Activity() {
    private var fullUri: Uri? = null
    private var customTabsConnection: ServiceConnection? = null
    private var customTabsOpened = false
    private var resultReceiver: ResultReceiver? = null
    private var activityName: String? = null

    // Guards against OEM browsers (e.g. Brave, Samsung Internet on Xiaomi MIUI) where
    // bindCustomTabsService returns true but onCustomTabsServiceConnected never fires,
    // leaving the user on a transparent empty activity indefinitely.
    private val customTabsTimeoutHandler = Handler(Looper.getMainLooper())
    private var customTabsBrowserOpened = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try {
            val url = intent.getStringExtra(Constants.KEY_FULL_URI)
                ?: throw IllegalArgumentException("No uri was passed to CustomTabsActivity.")

            fullUri = Uri.parse(url)

            resultReceiver = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.extras?.getBundle(Constants.KEY_BUNDLE)
                    ?.getParcelable(Constants.KEY_RESULT_RECEIVER, ResultReceiver::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.extras?.getBundle(Constants.KEY_BUNDLE)
                    ?.getParcelable<ResultReceiver>(Constants.KEY_RESULT_RECEIVER) as ResultReceiver
            } ?: throw IllegalArgumentException("ResultReceiver not delivered")

            activityName = intent.getStringExtra(Constants.ACTIVITY_NAME)
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
            customTabsConnection = CustomTabsCommonClient.openWithDefault(
                context = this,
                uri = uri,
                onServiceConnected = {
                    // Browser launched successfully — cancel the timeout fallback.
                    customTabsBrowserOpened = true
                    customTabsTimeoutHandler.removeCallbacksAndMessages(null)
                },
            )
        } catch (e: Exception) {
            // No Custom Tabs browser found — fall back to a plain Intent.ACTION_VIEW launch.
            openDirectBrowser(uri)
            return
        }

        if (customTabsConnection != null) {
            // bindCustomTabsService returned true (binding in progress) but
            // onCustomTabsServiceConnected may never fire on some OEM devices.
            // Schedule a fallback: if the browser has not opened within 3 seconds,
            // fall back to a direct launch so the user is never stuck on an empty screen.
            customTabsTimeoutHandler.postDelayed({
                if (!customTabsBrowserOpened && !isFinishing) {
                    Log.w(
                        "CustomTabsActivity",
                        "onCustomTabsServiceConnected not called within 3 s. " +
                            "Falling back to direct browser launch. " +
                            "This typically happens with Brave or Samsung Internet on " +
                            "devices with aggressive background process management (e.g. Xiaomi MIUI).",
                    )
                    openDirectBrowser(uri)
                }
            }, CUSTOM_TABS_TIMEOUT_MS)
        }
    }

    private fun openDirectBrowser(uri: Uri) {
        try {
            CustomTabsCommonClient.open(this, uri)
        } catch (e: Exception) {
            sendError("EUNKNOWN", e.localizedMessage)
        }
    }

    protected fun sendOk(url: String) {
        resultReceiver?.send(RESULT_OK, Bundle().apply {
            putParcelable(Constants.KEY_URL, Uri.parse(url))
        })
        // // If MainActivity and the current Activity have different taskAffinity settings, tasks are left behind when finish() is called
        finishAndRemoveTask()
    }

    protected fun sendError(errorCode: String, errorMessage: String?) {
        resultReceiver?.send(RESULT_CANCELED, Bundle().apply {
            putString(Constants.KEY_ERROR_CODE, errorCode)
            putString(Constants.KEY_ERROR_MESSAGE, errorMessage)
        })
        // // If MainActivity and the current Activity have different taskAffinity settings, tasks are left behind when finish() is called
        finishAndRemoveTask()
    }

    override fun onDestroy() {
        super.onDestroy()
        customTabsTimeoutHandler.removeCallbacksAndMessages(null)
        customTabsConnection?.let { unbindService(it) }
    }

    companion object {
        // How long to wait for onCustomTabsServiceConnected before falling back to open().
        private const val CUSTOM_TABS_TIMEOUT_MS = 3_000L
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
