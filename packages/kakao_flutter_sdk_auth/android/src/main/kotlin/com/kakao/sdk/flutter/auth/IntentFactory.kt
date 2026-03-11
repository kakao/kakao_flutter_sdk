package com.kakao.sdk.flutter.auth

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.ResultReceiver

object IntentFactory {
    fun talkAuthActivity(
        context: Context,
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: List<String>?,
        serviceTerms: List<String>?,
        talkPackage: String,
        resultReceiver: ResultReceiver,
    ): Intent {
        val talkIntent = createTalkAuthorizeIntent(
            appKey = appKey,
            redirectUri = redirectUri,
            kaHeader = kaHeader,
            pkce = pkce,
            nonce = nonce,
            channelPublicIds = channelPublicIds,
            serviceTerms = serviceTerms,
            talkPackage = talkPackage,
        )

        return createTalkAuthCodeActivityIntent(
            context = context,
            talkIntent = talkIntent,
            resultReceiver = resultReceiver,
        )
    }

    inline fun <reified T : CustomTabsActivity> customTabsActivityIntent(
        context: Context,
        url: String,
        resultReceiver: ResultReceiver,
    ): Intent {
        return Intent(context, T::class.java).apply {
            putExtra(Constants.KEY_URL, url)
            putExtra(Constants.KEY_RESULT_RECEIVER, resultReceiver)

            val activityName = (context as? Activity)?.componentName?.className
            activityName?.let { putExtra(Constants.KEY_ACTIVITY_NAME, it) }
        }
    }

    fun authCodeHandlerActivity(
        context: Context,
        url: String,
        redirectUri: String,
        resultReceiver: ResultReceiver,
    ): Intent {
        return customTabsActivityIntent<AuthCodeHandlerActivity>(
            context,
            url,
            resultReceiver
        ).apply {
            putExtra(Constants.KEY_REDIRECT_URI, redirectUri)
        }
    }

    private fun createTalkAuthCodeActivityIntent(
        context: Context,
        talkIntent: Intent,
        resultReceiver: ResultReceiver,
    ): Intent {
        return Intent(context, TalkAuthCodeActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            .apply {
                putExtra(Constants.KEY_TALK_INTENT, talkIntent)
                putExtra(Constants.KEY_RESULT_RECEIVER, resultReceiver)
            }
    }

    private fun createTalkAuthorizeIntent(
        appKey: String,
        redirectUri: String,
        kaHeader: String,
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: List<String>?,
        serviceTerms: List<String>?,
        talkPackage: String,
    ): Intent {
        val extraParams = buildTalkExtraParams(
            pkce = pkce,
            nonce = nonce,
            channelPublicIds = channelPublicIds,
            serviceTerms = serviceTerms,
        )

        return Intent(Constants.CAPRI_LOGGED_IN_ACTIVITY).apply {
            setPackage(talkPackage)
            addCategory(Intent.CATEGORY_DEFAULT)

            putExtra(Constants.EXTRA_APPLICATION_KEY, appKey)
            putExtra(Constants.EXTRA_REDIRECT_URI, redirectUri)
            putExtra(Constants.EXTRA_KA_HEADER, kaHeader)

            addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)

            if (!extraParams.isEmpty) {
                putExtra(Constants.EXTRA_EXTRAPARAMS, extraParams)
            }
        }
    }

    private fun buildTalkExtraParams(
        pkce: PkceDto?,
        nonce: String?,
        channelPublicIds: List<String>?,
        serviceTerms: List<String>?,
    ): Bundle {
        return Bundle().apply {
            channelPublicIds?.takeIf { it.isNotEmpty() }
                ?.let { putString(Constants.CHANNEL_PUBLIC_ID, it.joinToString(",")) }

            serviceTerms?.takeIf { it.isNotEmpty() }
                ?.let { putString(Constants.SERVICE_TERMS, it.joinToString(",")) }

            pkce?.let {
                putString(Constants.CODE_CHALLENGE, it.codeChallenge)
                putString(Constants.CODE_CHALLENGE_METHOD, it.codeChallengeMethod)
            }

            nonce?.let { putString(Constants.NONCE, it) }
        }
    }
}