package com.kakao.sdk.flutter.example

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast

/**
 * 카카오링크, 메시지 또는 카카오스토리에서 앱 링크 클릭 시 실행되는 Activity 예제
 *
 *  AndroidManifest.xml 에 intent-filter 설정이 필요하므로 샘플앱의 설정을 참고합니다.
 *
 *  실행되는 URL 형태:
 *    - kakao{NATIVE_APP_KEY}://kakaolink?{executionParams}
 *    - kakao{NATIVE_APP_KEY}://kakaostory?{executionParams}
 */
class KakaoLinkActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_kakao_link)

        intent.data?.let {
            parseKakaoLink(it)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        intent.data?.let {
            parseKakaoLink(it)
        }
    }

    // 카카오링크 파라미터 파싱
    private fun parseKakaoLink(uri: Uri) {
        // 공유 시 전달한 파라미터
        val executionParams = mutableMapOf<String, String>()

        uri.queryParameterNames.forEach { key ->
            executionParams[key] = uri.getQueryParameter(key)!!
        }

        Toast.makeText(this, "$executionParams", Toast.LENGTH_SHORT).show()
    }
}