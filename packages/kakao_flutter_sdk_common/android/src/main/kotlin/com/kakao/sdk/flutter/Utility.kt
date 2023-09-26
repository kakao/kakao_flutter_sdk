package com.kakao.sdk.flutter

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*

object Utility {
    fun getKeyHash(context: Context): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val packageInfo = context.packageManager
                .getPackageInfo(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val signatures = packageInfo.signingInfo.signingCertificateHistory
            for (signature in signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                return Base64.encodeToString(md.digest(), Base64.NO_WRAP)
            }
            throw IllegalStateException()
        }
        return getKeyHashDeprecated(context)
    }

    @Suppress("DEPRECATION")
    @SuppressLint("PackageManagerGetSignatures")
    fun getKeyHashDeprecated(context: Context): String {
        val packageInfo = context.packageManager
            .getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)
        for (signature in packageInfo.signatures) {
            val md = MessageDigest.getInstance("SHA")
            md.update(signature.toByteArray())
            return Base64.encodeToString(md.digest(), Base64.NO_WRAP)
        }
        throw IllegalStateException()
    }

    /**
     * 카카오 API 에서 클라이언트 검증, 통계, 이슈 해결 등을 위하여 사용하는 KA 헤더를 생성한다.
     *
     * Generate KA header used by Kakao API for client verification, statistics, and customer support.
     */
    fun getKAHeader(context: Context): String {
        return String.format(
            "%s/android-%s %s/%s-%s %s/%s %s/%s %s/%s %s/%s",
            Constants.OS,
            Build.VERSION.SDK_INT,
            Constants.LANG,
            Locale.getDefault().language.lowercase(),
            Locale.getDefault().country.uppercase(),
            Constants.ORIGIN,
            getKeyHash(context),
            Constants.DEVICE,
            Build.MODEL.replace("[^\\p{ASCII}]".toRegex(), "*").replace("\\s".toRegex(), "-")
                .uppercase(),
            Constants.ANDROID_PKG,
            context.packageName,
            Constants.APP_VER,
            getAppVer(context),
        )
    }

    fun getAppVer(context: Context): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.getPackageInfo(
                context.packageName,
                PackageManager.PackageInfoFlags.of(0)
            ).versionName
        } else {
            @Suppress("DEPRECATION")
            context.packageManager.getPackageInfo(context.packageName, 0).versionName
        }
    }

    fun talkLoginIntent(
        clientId: String? = null,
        redirectUri: String? = null,
        kaHeader: String? = null,
        extras: Bundle = Bundle(),
    ): Intent {
        val intent = Intent().setAction("com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY")
            .addCategory(Intent.CATEGORY_DEFAULT)
            .putExtra(Constants.EXTRA_APPLICATION_KEY, clientId)
            .putExtra(Constants.EXTRA_REDIRECT_URI, redirectUri)
            .putExtra(Constants.EXTRA_KA_HEADER, kaHeader)
            .addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
        if (!extras.isEmpty) {
            intent.putExtra(Constants.EXTRA_EXTRAPARAMS, extras)
        }
        return intent
    }

    fun getMetadata(context: Context, key: String): String? {
        val ai = context.packageManager.getApplicationInfo(
            context.packageName, PackageManager.GET_META_DATA
        )
        return ai.metaData.getString(key)
    }

    fun isKakaoTalkInstalled(context: Context, talkPackageName: String): Boolean {
        return isPackageInstalled(context, talkPackageName) ||
                isPackageInstalled(context, "com.kakao.onetalk")
    }

    fun isKakaoNaviInstalled(context: Context, naviPackageName: String): Boolean {
        return isPackageInstalled(context, naviPackageName) ||
                isPackageInstalled(context, "com.lguplus.navi")
    }

    private fun isPackageInstalled(context: Context, packageName: String): Boolean {
        return context.packageManager.getLaunchIntentForPackage(packageName) != null
    }

    @SuppressLint("HardwareIds")
    @Throws(NoSuchAlgorithmException::class)
    fun androidId(context: Context): ByteArray {
        return try {
            val androidId =
                Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
            val stripped = androidId.replace("[0\\s]", "")
            val md = MessageDigest.getInstance("SHA-256")
            md.reset()
            md.update("SDK-$stripped".toByteArray())
            md.digest()
        } catch (e: Exception) {
            ("xxxx" + Build.PRODUCT + "a23456789012345bcdefg").toByteArray()
        }
    }

    fun naviBaseUriBuilder(
        scheme: String,
        authority: String,
        appKey: String?,
        extras: String?,
        params: String?,
    ): Uri.Builder {
        return Uri.Builder().scheme(scheme).authority(authority)
            .appendQueryParameter(Constants.PARAM, params)
            .appendQueryParameter(Constants.APIVER, Constants.APIVER_10)
            .appendQueryParameter(Constants.APPKEY, appKey)
            .appendQueryParameter(Constants.EXTRAS, extras)
    }

    fun platformId(context: Context): ByteArray {
        @SuppressLint("HardwareIds")
        val androidId = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ANDROID_ID
        )
        val stripped = androidId.replace("[0\\s]".toRegex(), "")
        val md = MessageDigest.getInstance("SHA-256")
        md.reset()
        md.update("SDK-$stripped".toByteArray())
        return md.digest()
    }
}
