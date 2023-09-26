package com.kakao.sdk.flutter

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Base64
import java.security.MessageDigest

object IntentFactory {
    fun talkAuthCode(context: Context, args: Map<String, String>): Intent {
        val sdkVersion = args["sdk_version"]
            ?: throw IllegalArgumentException("Sdk version id is required.")
        val clientId = args["client_id"]
            ?: throw IllegalArgumentException("Client id is required.")
        val redirectUri = args["redirect_uri"]
            ?: throw IllegalArgumentException("Redirect uri is required.")
        val channelPublicIds = args["channel_public_ids"]
        val serviceTerms = args["service_terms"]
        val approvalType = args["approval_type"]
        val codeVerifier = args["code_verifier"]
        val prompts = args["prompt"]
        val state = args["state"]
        val nonce = args["nonce"]
        val settleId = args["settle_id"]
        val extras = Bundle().apply {
            channelPublicIds?.let { putString(Constants.CHANNEL_PUBLIC_ID, it) }
            serviceTerms?.let { putString(Constants.SERVICE_TERMS, it) }
            approvalType?.let { putString(Constants.APPROVAL_TYPE, it) }
            codeVerifier?.let {
                putString(Constants.CODE_CHALLENGE, codeChallenge(it.toByteArray()))
                putString(
                    Constants.CODE_CHALLENGE_METHOD,
                    Constants.CODE_CHALLENGE_METHOD_VALUE
                )
            }
            prompts?.let { putString(Constants.PROMPT, it) }
            state?.let { putString(Constants.STATE, it) }
            nonce?.let { putString(Constants.NONCE, it) }
            settleId?.let { putString(Constants.SETTLE_ID, it) }
        }

        return Intent(context, TalkAuthCodeActivity::class.java)
            .putExtra(Constants.KEY_SDK_VERSION, sdkVersion)
            .putExtra(Constants.KEY_CLIENT_ID, clientId)
            .putExtra(Constants.KEY_REDIRECT_URI, redirectUri)
            .putExtra(Constants.KEY_EXTRAS, extras)
    }

    fun customTabs(context: Context, args: Map<String, String?>): Intent {
        return Intent(context, AuthCodeCustomTabsActivity::class.java)
            .putExtra(Constants.KEY_FULL_URI, args["url"] as String)
    }

    fun customTabsForLogin(context: Context, args: Map<String, String?>): Intent {
        return customTabs(context, args).apply {
            val redirectUrl = args["redirect_uri"]
            putExtra(Constants.KEY_REDIRECT_URL, redirectUrl)
        }
    }

    private fun codeChallenge(codeVerifier: ByteArray): String =
        Base64.encodeToString(
            MessageDigest.getInstance(Constants.CODE_CHALLENGE_ALGORITHM).digest(codeVerifier),
            Base64.NO_WRAP or Base64.NO_PADDING or Base64.URL_SAFE
        )
}
