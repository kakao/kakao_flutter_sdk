package com.kakao.sdk.flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.EventChannel

class KakaoTalkSharingSchemeReceiver(private val events: EventChannel.EventSink) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString
        events.success(dataString)
    }
}