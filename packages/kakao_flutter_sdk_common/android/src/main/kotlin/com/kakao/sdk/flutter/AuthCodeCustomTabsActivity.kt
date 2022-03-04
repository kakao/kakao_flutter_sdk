package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Bundle
import java.lang.Exception
import androidx.browser.customtabs.CustomTabsIntent

class AuthCodeCustomTabsActivity : Activity() {
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
        fullUri = intent.extras?.getParcelable(KEY_FULL_URI)
            ?: throw IllegalArgumentException("No uri was passed to AuthCodeCustomTabsActivity. This might be a bug in Kakao Flutter SDK.")
    }

    override fun onResume() {
        super.onResume()
        if (!customTabsOpened) {
            openChromeCustomTab(fullUri)
            customTabsOpened = true
        } else {
            KakaoFlutterSdkPlugin.redirectUriResult.error("CANCELED", "User canceled login.", null)
            finish()
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)

        val url = intent?.dataString
        val redirectUri = KakaoFlutterSdkPlugin.redirectUri
        if (redirectUri != null && url?.startsWith(redirectUri) == true) {
            KakaoFlutterSdkPlugin.redirectUriResult.success(url.toString())
        } else {
            KakaoFlutterSdkPlugin.redirectUriResult.error(
                "REDIRECT_URL_MISMATCH",
                "Expected: $redirectUri, Actual: $url",
                null
            )
        }
        this.finish()
    }

    fun openChromeCustomTab(uri: Uri) {
        try {
            customTabsConnection = CustomTabsCommonClient.openWithDefault(this, uri)
        } catch (e: Exception) {

            try {
                CustomTabsIntent.Builder().enableUrlBarHiding().setShowTitle(true).build()
                    .launchUrl(this, uri)

            } catch (e: Exception) {
                KakaoFlutterSdkPlugin.redirectUriResult.error("EUNKNOWN", e.localizedMessage, null)
                finish()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        customTabsConnection?.let { unbindService(it) }
    }
}