package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Window

class TalkAuthCodeActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_talk_auth_code)
        val sdkVersion = intent.extras?.getString(Constants.KEY_SDK_VERSION)
        val clientId = intent.extras?.getString(Constants.KEY_CLIENT_ID)
            ?: throw IllegalArgumentException("Client id is required.")
        val redirectUri = intent.extras?.getString(Constants.KEY_REDIRECT_URI)
            ?: throw IllegalArgumentException("Redirect uri is required.")
        val extra = intent.extras?.getBundle(Constants.KEY_EXTRAS) ?: Bundle()

        val loginIntent = Utility.talkLoginIntent(
            clientId,
            redirectUri,
            "$sdkVersion ${Utility.getKAHeader(this)}",
            extra
        )
        startActivityForResult(loginIntent, Constants.REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (data == null || resultCode == RESULT_CANCELED) {
            sendError("CANCELED", "User canceled login.")
            return
        }
        if (resultCode == RESULT_OK) {
            val extras = data.extras
            if (extras == null) {
                // no result returned from kakaotalk
                sendError("EUNKNOWN", "No result returned from KakaoTalk.")
                return
            }
            val error = extras.getString(Constants.EXTRA_ERROR_TYPE)
            val errorDescription =
                extras.getString(Constants.EXTRA_ERROR_DESCRIPTION) ?: "No error description."
            if (error != null) {
                sendError(error, errorDescription)
                return
            }
            val redirectUrl = extras.getString(Constants.EXTRA_REDIRECT_URL)
            setResult(RESULT_OK, Intent().putExtra(Constants.KEY_RETURN_URL, redirectUrl))
            finish()
            overridePendingTransition(0, 0)
            return
        }
        throw IllegalStateException("Unexpected data from KakaoTalk in onActivityResult. $data")
    }

    private fun sendError(errorCode: String, errorMessage: String) {
        val intent = Intent()
            .putExtra(Constants.KEY_ERROR_CODE, errorCode)
            .putExtra(Constants.KEY_ERROR_MESSAGE, errorMessage)
        setResult(RESULT_CANCELED, intent)
        finish()
    }
}
