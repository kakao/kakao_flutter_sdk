package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.Window
import kotlin.IllegalArgumentException

class TalkAuthCodeActivity : Activity() {

  private val REQUEST_CODE = 1004

  companion object {
    val KEY_CLIENT_ID = "key_client_Id"
    val KEY_REDIRECT_URI = "key_redirect_uri"

    fun start(context: Context, clientId: String, redirectUri: String) {
      context.startActivity(Intent(context, TalkAuthCodeActivity::class.java)
          .putExtra(KEY_CLIENT_ID, clientId).putExtra(KEY_REDIRECT_URI, redirectUri))
    }
  }

  fun talkLoginIntent(clientId: String, redirectUri: String, kaHeader: String): Intent {
    return Intent().setAction("com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY")
        .addCategory(Intent.CATEGORY_DEFAULT)
        .putExtra(Constants.EXTRA_APPLICATION_KEY, clientId)
        .putExtra(Constants.EXTRA_REDIRECT_URI, redirectUri)
        .putExtra(Constants.EXTRA_KA_HEADER, kaHeader)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    requestWindowFeature(Window.FEATURE_NO_TITLE)
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_talk_auth_code)


    val extras = intent.extras ?: throw IllegalArgumentException()
    val clientId = extras.getString(KEY_CLIENT_ID) ?: throw IllegalArgumentException()
    val redirectUri = extras.getString(KEY_REDIRECT_URI) ?: throw IllegalArgumentException()

    val loginIntent = talkLoginIntent(clientId, redirectUri, Utility.getKAHeader(this))
    startActivityForResult(loginIntent, REQUEST_CODE)
  }

  private fun sendError(errorCode: String, errorMessage: String, errorDetails: Any?) {
    KakaoFlutterSdkPlugin.redirectUriResult.error(errorCode, errorMessage, errorDetails)
    finish()
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    if (data == null || resultCode == Activity.RESULT_CANCELED) {
      sendError("Canceled", "User canceled the operation.", null)
      return
    }
    if (resultCode == Activity.RESULT_OK) {
      val extras = data.extras
      if (extras == null) {
        // no result returned from kakaotalk
        sendError("No result", "No result returned from KakaoTalk.", null)
        return
      }
      val error = extras.getString(Constants.EXTRA_ERROR_TYPE)
      val errorDescription = extras.getString(Constants.EXTRA_ERROR_DESCRIPTION) ?: "Error description not specified"
      if (error != null) {
        sendError(error, errorDescription, null)
        return
      }
      KakaoFlutterSdkPlugin.redirectUriResult.success(extras[Constants.EXTRA_REDIRECT_URL])
      finish()
      overridePendingTransition(0, 0)
      return
    }
    throw IllegalArgumentException("")
  }
}
