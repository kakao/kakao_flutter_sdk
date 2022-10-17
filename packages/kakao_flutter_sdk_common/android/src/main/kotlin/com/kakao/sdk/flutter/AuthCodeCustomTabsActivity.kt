package com.kakao.sdk.flutter

import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.browser.customtabs.CustomTabsIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class AuthCodeCustomTabsActivity : FlutterActivity() {
    private lateinit var result: MethodChannel.Result
    private lateinit var fullUri: Uri
    private var customTabsConnection: ServiceConnection? = null
    private var customTabsOpened = false

    companion object {
        const val KEY_FULL_URI = "key_full_uri"

        fun startWithUrl(context: Context, uriString: String) {
            val uri = Uri.parse(uriString)
            val extras = Bundle()
            extras.putParcelable(KEY_FULL_URI, uri)
            context.startActivity(
                Intent(context, AuthCodeCustomTabsActivity::class.java)
                    .putExtra(KEY_FULL_URI, uri)
            )
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        try {
            fullUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.extras?.getParcelable(KEY_FULL_URI, Uri::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.extras?.getParcelable(KEY_FULL_URI)
            }
                ?: throw IllegalArgumentException("No uri was passed to AuthCodeCustomTabsActivity. This might be a bug in Kakao Flutter SDK.")

            result = KakaoFlutterSdkPlugin.redirectUriResult
        } catch (e: Throwable) {
            if (::result.isInitialized) {
                result.error(e.javaClass.simpleName, e.localizedMessage, e)
            }
            Log.e(e.javaClass.simpleName, e.toString())
            finish()
        }
    }

    override fun onResume() {
        super.onResume()
        if (!customTabsOpened) {
            customTabsOpened = true

            if (::fullUri.isInitialized) {
                openChromeCustomTab(fullUri)
            } else {
                if (::result.isInitialized) {
                    result.error("AuthCodeCustomTabs", "url has been not initialized.", null)
                }
                Log.e("AuthCodeCustomTabs", "url has been not initialized.")
                finish()
            }
        } else {
            if (::result.isInitialized) {
                result.error("CANCELED", "User canceled login.", null)
            }
            finish()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        val url = intent.dataString
        val redirectUri = KakaoFlutterSdkPlugin.redirectUri
        if (redirectUri != null && url?.startsWith(redirectUri) == true) {
            if(::result.isInitialized) {
                result.success(url.toString())
            }
        } else {
            if(::result.isInitialized) {
                result.error(
                    "REDIRECT_URL_MISMATCH",
                    "Expected: $redirectUri, Actual: $url",
                    null
                )
            }
        }
        finish()
    }

    private fun openChromeCustomTab(uri: Uri) {
        try {
            customTabsConnection = CustomTabsCommonClient.openWithDefault(this, uri)
        } catch (e: Exception) {
            try {
                CustomTabsIntent.Builder().enableUrlBarHiding().setShowTitle(true).build()
                    .launchUrl(this, uri)
            } catch (e: Exception) {
                if(::result.isInitialized) {
                    result.error("EUNKNOWN", e.localizedMessage, null)
                }
                finish()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        customTabsConnection?.let { unbindService(it) }
    }
}