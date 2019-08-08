package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Bundle

/**
 * @author kevin.kang. Created on 2019-06-13..
 */
class AuthCodeCustomTabsActivity : Activity() {
  private lateinit var fullUri: Uri
  private var customTabsConnection: ServiceConnection? = null
  private var customTabsOpened = false

  companion object {
    val KEY_FULL_URI = "key_full_uri"

    fun startWithUrl(context: Context, uriString: String) {
      val uri = Uri.parse(uriString)
      val extras = Bundle()
      extras.putParcelable(KEY_FULL_URI, uri)
      context.startActivity(Intent(context, AuthCodeCustomTabsActivity::class.java)
          .putExtra(KEY_FULL_URI, uri))
    }
  }
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val extras = intent.extras ?: throw IllegalArgumentException()
    fullUri = extras.getParcelable(KEY_FULL_URI) ?: throw IllegalArgumentException()
  }

  override fun onResume() {
    super.onResume()
    if (!customTabsOpened) {
      openChromeCustomTab(fullUri)
      customTabsOpened = true
    } else {
      finish()
    }
  }

  override fun onNewIntent(intent: Intent?) {
    super.onNewIntent(intent)

    val url = intent?.dataString
    val redirectUri = KakaoFlutterSdkPlugin.redirectUri
    if (redirectUri != null && url?.startsWith(redirectUri) == true) {
      KakaoFlutterSdkPlugin.redirectUriResult.success(url.toString())
    }
    this.finish()
  }

  fun openChromeCustomTab(uri: Uri) {
    customTabsConnection = CustomTabsCommonClient.openWithDefault(this, uri)
  }

  override fun onDestroy() {
    super.onDestroy()
    customTabsConnection?.let { unbindService(it) }
  }
}