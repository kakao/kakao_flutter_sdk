package com.example.kakao_flutter_sdk

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.util.Base64
import java.lang.IllegalStateException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*

/**
 * @author kevin.kang. Created on 2019-06-07..
 */
object Utility {
    @TargetApi(Build.VERSION_CODES.P)
    fun getKeyHash(context: Context): String {
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
        return String.format("%s/%s %s/android-%s %s/%s-%s %s/%s %s/%s %s/%s %s/%s",
                Constants.SDK, BuildConfig.VERSION_NAME,
                Constants.OS, Build.VERSION.SDK_INT,
                Constants.LANG, Locale.getDefault().language.toLowerCase(), Locale.getDefault().country.toUpperCase(),
                Constants.ORIGIN, getKeyHash(context),
                Constants.DEVICE, Build.MODEL.replace("\\s".toRegex(), "-").toUpperCase(),
                Constants.ANDROID_PKG, context.packageName,
                Constants.APP_VER, context.packageManager.getPackageInfo(context.packageName, 0).versionName
        )
    }

    fun getMetadata(context: Context, key: String): String? {
        val ai = context.packageManager.getApplicationInfo(
                context.packageName, PackageManager.GET_META_DATA)
        return ai.metaData.getString(key)
    }

    @SuppressLint("HardwareIds")
    @Throws(NoSuchAlgorithmException::class)
    fun androidId(context: Context): ByteArray {
        return try {
            val androidId = Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
            val stripped = androidId.replace("[0\\s]", "")
            val md = MessageDigest.getInstance("SHA-256")
            md.reset()
            md.update("SDK-$stripped".toByteArray())
            md.digest()
        } catch (e: Exception) {
            ("xxxx" + Build.PRODUCT + "a23456789012345bcdefg").toByteArray()
        }
    }
}