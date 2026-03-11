package com.kakao.sdk.flutter.common

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.util.Base64
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.net.toUri
import java.security.MessageDigest
import java.util.Locale

class CommonHostApiImpl(private val context: Context) : CommonHostApi {
    private var activity: Activity? = null // for KakaoCustomTabsClient

    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    override fun getPlatformData(): PlatformData {
        return PlatformData(
            platformId = getPlatformId(),
            origin = getOrigin(),
            kaHeader = getKaHeader(),
            appVer = getAppVersion(),
            packageName = getPackageName()
        )
    }

    override fun isAppInstalled(appIdentifier: String): Boolean {
        return context.packageManager.getLaunchIntentForPackage(appIdentifier) != null
    }

    override fun isKakaoTalkAvailable(appScheme: String?): Boolean {
        val intent = appScheme?.let { Intent(Intent.ACTION_VIEW, it.toUri()) }
            ?: Intent(Constants.CAPRI_LOGGED_IN_ACTIVITY).addCategory(Intent.CATEGORY_DEFAULT)

        return TalkValidator.resolveIntent(context, intent) != null
    }

    override fun launchUrl(
        url: String,
        useBrowserSession: Boolean, // ios에서만 사용하는 파라미터
        callback: (Result<Unit>) -> Unit
    ) {
        runCatching {
            val activity = activity
                ?: throw IllegalStateException("Activity is not attached. Cannot launch URL.")

            val customTabsIntent = CustomTabsIntent.Builder()
                .setUrlBarHidingEnabled(true)
                .setShowTitle(true)
                .build()
                .apply {
                    // 중복 생성 방지
                    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                }

            // activity와 같은 task에서 열기 위해 activity 사용
            customTabsIntent.launchUrl(activity, url.toUri())
        }
            .onSuccess { callback(Result.success(it)) }
            .onFailure { callback(Result.failure(it)) }
    }

    private fun getAppVersion(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.getPackageInfo(
                context.packageName,
                PackageManager.PackageInfoFlags.of(0)
            ).versionName
        } else {
            context.packageManager.getPackageInfo(context.packageName, 0).versionName
        } ?: throw FlutterError("Failed to get app version")
    }

    private fun getPlatformId(): ByteArray {
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

    private fun getOrigin(): String {
        return getKeyHash(context)
    }

    private fun getKaHeader(): String {
        return String.format(
            "%s/android-%s %s/%s-%s %s/%s %s/%s %s/%s",
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
        )
    }

    private fun getPackageName(): String {
        return context.packageName
    }

    private fun getKeyHash(context: Context): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val packageInfo = context.packageManager
                .getPackageInfo(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val signatures = packageInfo.signingInfo?.signingCertificateHistory ?: arrayOf()
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
    private fun getKeyHashDeprecated(context: Context): String {
        val packageInfo = context.packageManager
            .getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)
        for (signature in packageInfo.signatures ?: arrayOf()) {
            val md = MessageDigest.getInstance("SHA")
            md.update(signature.toByteArray())
            return Base64.encodeToString(md.digest(), Base64.NO_WRAP)
        }
        throw IllegalStateException()
    }
}