package com.kakao.sdk.flutter

import android.app.Activity
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ResultReceiver
import android.util.Log

abstract class SingleResultReceiver<T : Any> private constructor() :
    BaseResultReceiver<T, (T?, Pair<String?, String?>?) -> Unit>() {

    override fun onSuccess(response: T) {
        this.emitter?.invoke(response, null)
    }

    override fun onError(errorCode: String?, errorMessage: String?) {
        this.emitter?.invoke(null, Pair(errorCode, errorMessage))
    }

    companion object {
        /**
         * @suppress
         */
        fun <T : Any> create(
            emitter: (T?, Pair<String?, String?>?) -> Unit,
            parseResponse: (uri: Uri) -> T?,
            parseError: (uri: Uri) -> Pair<String?, String?>,
            isError: (uri: Uri) -> Boolean,
        ): SingleResultReceiver<T> {
            return object : SingleResultReceiver<T>() {
                override fun parseResponse(url: Uri): T? = parseResponse(url)
                override fun parseError(url: Uri): Pair<String?, String?> = parseError(url)
                override fun isError(url: Uri): Boolean = isError(url)
            }.apply {
                setEmitter(emitter)
            }
        }
    }
}

abstract class BaseResultReceiver<T : Any, E> protected constructor() :
    ResultReceiver(Handler(Looper.getMainLooper())) {
    var emitter: E? = null
        private set

    // There was a bug in kotlin 2.0.0 where you couldn't assign a value to a protected set variable, so I added the setter function
    protected fun setEmitter(emitter: E) {
        this.emitter = emitter
    }

    abstract fun parseResponse(url: Uri): T?

    abstract fun parseError(url: Uri): Pair<String?, String?>

    abstract fun isError(url: Uri): Boolean

    abstract fun onSuccess(response: T)

    abstract fun onError(errorCode: String?, errorMessage: String?)

    override fun onReceiveResult(resultCode: Int, resultData: Bundle) {
        Log.d("ResultReceiver", "Status: $resultData")
        when (resultCode) {
            Activity.RESULT_OK -> receiveOk(resultData)
            Activity.RESULT_CANCELED -> receiveCanceled(resultData)
            else -> processError()
        }
        emitter = null
    }

    private fun receiveOk(resultData: Bundle) {
        val url = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            resultData.getParcelable(Constants.KEY_URL, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            resultData.getParcelable(Constants.KEY_URL)
        } ?: run {
            onError("ResultReceiver", "result url is not received")
            return
        }


        if (isError(url)) {
            val error = parseError(url)
            onError(error.first, error.second)
            return
        }

        val response = parseResponse(url) ?: run {
            onError("ResultReceiver", "Failed to parse response\n$url")
            return
        }

        onSuccess(response)
    }

    private fun receiveCanceled(resultData: Bundle) {
        val errorCode = resultData.getString(Constants.KEY_ERROR_CODE)
        val errorMessage = resultData.getString(Constants.KEY_ERROR_MESSAGE)
        onError(errorCode, errorMessage)
    }

    private fun processError() {
        onError(
            "error",
            "Unknown resultCode in ${this::class.java.simpleName}#onReceivedResult()"
        )
    }
}
