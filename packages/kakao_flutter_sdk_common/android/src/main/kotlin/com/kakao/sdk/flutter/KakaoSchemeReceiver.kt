package com.kakao.sdk.flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel

class KakaoSchemeReceiver(private val events: EventChannel.EventSink) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString
        events.success(dataString)
    }
}