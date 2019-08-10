package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.Window
import java.lang.IllegalStateException
import kotlin.IllegalArgumentException

class TalkAuthCodeActivity : Activity() {
  companion object {
    private const val REQUEST_CODE = 1004
    const val KEY_CLIENT_ID = "key_client_Id"
    const val KEY_REDIRECT_URI = "key_redirect_uri"

    fun start(context: Context, clientId: String, redirectUri: String) {
      context.startActivity(Intent(context, TalkAuthCodeActivity::class.java)
          .putExtra(KEY_CLIENT_ID, clientId).putExtra(KEY_REDIRECT_URI, redirectUri))
    }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    requestWindowFeature(Window.FEATURE_NO_TITLE)
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_talk_auth_code)

    val clientId = intent.extras?.getString(KEY_CLIENT_ID) ?: throw IllegalArgumentException("Client id is required.")
    val redirectUri = intent.extras?.getString(KEY_REDIRECT_URI)
        ?: throw IllegalArgumentException("Redirect uri is required.")

    val loginIntent = Utility.talkLoginIntent(clientId, redirectUri, Utility.getKAHeader(this))
    startActivityForResult(loginIntent, REQUEST_CODE)
  }

  private fun sendError(errorCode: String, errorMessage: String, errorDetails: Any?) {
    KakaoFlutterSdkPlugin.redirectUriResult.error(errorCode, errorMessage, errorDetails)
    finish()
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    if (data == null || resultCode == RESULT_CANCELED) {
      sendError("CANCELED", "User canceled login.", null)
      return
    }
    if (resultCode == RESULT_OK) {
      val extras = data.extras
      if (extras == null) {
        // no result returned from kakaotalk
        sendError("EUNKNOWN", "No result returned from KakaoTalk.", null)
        return
      }
      val error = extras.getString(Constants.EXTRA_ERROR_TYPE)
      val errorDescription = extras.getString(Constants.EXTRA_ERROR_DESCRIPTION) ?: "No error description."
      if (error != null) {
        sendError(error, errorDescription, null)
        return
      }
      KakaoFlutterSdkPlugin.redirectUriResult.success(extras[Constants.EXTRA_REDIRECT_URL])
      finish()
      overridePendingTransition(0, 0)
      return
    }
    throw IllegalStateException("Unexpected data from KakaoTalk in onActivityResult. $data")
  }
}
