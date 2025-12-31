package com.kakao.sdk.flutter

import android.content.Context
import android.content.Intent
import android.content.pm.LabeledIntent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Build
import android.os.Parcelable

class IntentResolveClient {

    fun resolveTalkIntent(context: Context, intent: Intent): Intent? {
        val pm = context.packageManager

        val targetIntents = mutableListOf<Intent>()
        val labeledIntents = mutableListOf<LabeledIntent>()

        for (packageName in ALLOWED_PACKAGES) {
            val cloned = intent.clone() as Intent
            cloned.setPackage(packageName)
            val info = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pm.resolveActivity(
                    cloned,
                    PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong())
                )
            } else {
                @Suppress("DEPRECATION")
                pm.resolveActivity(cloned, PackageManager.MATCH_DEFAULT_ONLY)
            } ?: continue
            val packageInfo = packageInfo(pm, info)
            if (!validateTalkSignature(packageInfo)) continue
            targetIntents.add(cloned)
            labeledIntents.add(
                LabeledIntent(
                    intent,
                    info.activityInfo.applicationInfo.packageName,
                    info.activityInfo.applicationInfo.labelRes,
                    info.activityInfo.applicationInfo.icon
                )
            )
        }

        if (targetIntents.size == 0) {
            return null
        }
        if (targetIntents.size == 1) {
            return targetIntents[0]
        }
        val chooserIntent = Intent.createChooser(
            labeledIntents.removeAt(0),
            "Which version of KakaoTalk would you like to use?"
        )
        if (labeledIntents.size > 0) {
            val labeledIntentsParcelable: Array<Parcelable> = labeledIntents.toTypedArray()
            chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, labeledIntentsParcelable)
        }
        return chooserIntent
    }

    private fun validateTalkSignature(packageInfo: PackageInfo): Boolean {
        val arrayOfSignatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            packageInfo.signingInfo?.apkContentsSigners
        } else {
            @Suppress("DEPRECATION")
            packageInfo.signatures
        } ?: arrayOf()

        for (signature in arrayOfSignatures) {
            val signatureCharsString = signature.toCharsString()
            if (ALLOWED_SIGNATURES.contains(signatureCharsString)) {
                return true
            }
        }
        return false
    }

    private fun packageInfo(pm: PackageManager, info: ResolveInfo): PackageInfo {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getPackageInfo(
                info.activityInfo.applicationInfo.packageName,
                PackageManager.PackageInfoFlags.of(PackageManager.GET_SIGNING_CERTIFICATES.toLong())
            )
        } else {
            val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                PackageManager.GET_SIGNING_CERTIFICATES
            } else {
                @Suppress("DEPRECATION")
                PackageManager.GET_SIGNATURES
            }
            @Suppress("DEPRECATION")
            pm.getPackageInfo(info.activityInfo.applicationInfo.packageName, flag)
        }
    }

    companion object {
        val instance by lazy { IntentResolveClient() }

        private const val RELEASE_SIGNATURE =
            "308201db30820144a00302010202044c707197300d06092a864886f70d010105050030" +
                    "31310b3009060355040613026b6f310e300c060355040a13056b616b616f31123010060355040b13096b616b616f7465616d3020170d" +
                    "3130303832323030333834375a180f32313130303732393030333834375a3031310b3009060355040613026b6f310e300c060355040a" +
                    "13056b616b616f31123010060355040b13096b616b616f7465616d30819f300d06092a864886f70d010101050003818d003081890281" +
                    "8100aef387bc86e022a87e66b8c42153284f18e0c468cf9c87a241b989729dfdad3dd9e1847546d01a2819ba77f3974a47b473c926ac" +
                    "ae173fd90c7e635000721feeef6705da7ae949a35b82900a0f67d9464d73ed8a98c37f4ac70729494a17469bc40d4ee06d043b09147e" +
                    "badc55fa1020968d7036c5fb9b8c148cba1d8e9d9fc10203010001300d06092a864886f70d0101050500038181005569be704c68cff6" +
                    "221c1e04dd8a131110f9f5cd2138042286337fd6014a1b1d2d3eeb266ae1630afe56bf63c07dd0b5c8fad46dcb9f802f9a7802fb89eb" +
                    "3b4777b9665bb1ed9feaf1dc7cac4f91abedfc81187ff6d2f471dbd12335d2c0ef0e2ee719df6e763f814b9ac91f8be37fd11d406867" +
                    "00d66be6de22a1836f060f01"

        private const val DEBUG_SIGNATURE =
            "308201e53082014ea00302010202044f4ae542300d06092a864886f70d01010505003037" +
                    "310b30090603550406130255533110300e060355040a1307416e64726f6964311630140603550403130d416e64726f69642044656275" +
                    "67301e170d3132303232373032303635385a170d3432303231393032303635385a3037310b30090603550406130255533110300e0603" +
                    "55040a1307416e64726f6964311630140603550403130d416e64726f696420446562756730819f300d06092a864886f70d0101010500" +
                    "03818d0030818902818100c0b41c25ef21a39a13ce89c82dc3a14bf9ef0c3094aa2ac1bf755c9699535e79119e8b980c0ecdcc51f259" +
                    "eb0d8b2077d41de8fcfdeaac3f386c05e2a684ecb5504b660ad7d5a01cce35899f96bcbd099c9dcb274c6eb41fef861616a12fb45bc5" +
                    "7a19683a8a97ab1a33d9c70128878b67dd1b3a388ad5121d1d66ff04c065ff0203010001300d06092a864886f70d0101050500038181" +
                    "000418a7dacb6d13eb61c8270fe1fdd006eb66d0ff9f58f475defd8dc1fb11c41e34ce924531d1fd8ad26d9479d64f54851bf57b8dfe" +
                    "3a5d6f0a01dcad5b8c36ac4ac48caeff37888c36483c26b09aaa9689dbb896938d5afe40135bf7d9f12643046301867165d28be0baa3" +
                    "513a5084e182f7f9c044d5baa58bdce55fa1845241"

        private const val TALK_PACKAGE_NAME = "com.kakao.talk"
        private const val SANDBOX_TALK_PACKAGE_NAME = "com.kakao.talk.sandbox"
        private const val ALPHA_TALK_PACKAGE_NAME = "com.kakao.talk.alpha"

        private val ALLOWED_SIGNATURES = arrayOf(RELEASE_SIGNATURE, DEBUG_SIGNATURE)

        private val ALLOWED_PACKAGES = arrayOf(
            TALK_PACKAGE_NAME,
            SANDBOX_TALK_PACKAGE_NAME,
            ALPHA_TALK_PACKAGE_NAME
        )
    }
}
