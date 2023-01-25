/*
 * Copyright (c) 2016-2019 The CallKeep Authors (see the AUTHORS file)
 * SPDX-License-Identifier: ISC, MIT
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
package io.package.call_id

import android.annotation.TargetApi

@TargetApi(Build.VERSION_CODES.M)
class VoiceConnection internal constructor(context: Context, handle: HashMap<String?, String?>) :
    Connection() {
    private var isMuted = false
    private var handle: HashMap<String, String>
    private val context: Context

    init {
        this.handle = handle
        this.context = context
        val number: String = handle.get(EXTRA_CALL_NUMBER)
        val name: String = handle.get(EXTRA_CALLER_NAME)
        if (number != null) {
            setAddress(Uri.parse(number), TelecomManager.PRESENTATION_ALLOWED)
        }
        if (name != null && !name.equals("")) {
            setCallerDisplayName(name, TelecomManager.PRESENTATION_ALLOWED)
        }
    }

    @Override
    fun onExtrasChanged(extras: Bundle) {
        super.onExtrasChanged(extras)
        val attributeMap: HashMap =
            extras.getSerializable("attributeMap") as HashMap<String?, String?>
        if (attributeMap != null) {
            handle = attributeMap
        }
    }

    @Override
    fun onCallAudioStateChanged(state: CallAudioState) {
        if (state.isMuted() === isMuted) {
            return
        }
        isMuted = state.isMuted()
        sendCallRequestToActivity(if (isMuted) ACTION_MUTE_CALL else ACTION_UNMUTE_CALL, handle)
    }

    @Override
    fun onAnswer() {
        super.onAnswer()
        Log.d(TAG, "onAnswer called")
        Log.d(TAG, "onAnswer ignored")
    }

    @Override
    fun onAnswer(videoState: Int) {
        super.onAnswer(videoState)
        Log.d(TAG, "onAnswer videoState called: $videoState")
        setConnectionCapabilities(getConnectionCapabilities() or Connection.CAPABILITY_HOLD)
        setAudioModeIsVoip(true)
        sendCallRequestToActivity(ACTION_ANSWER_CALL, handle)
        sendCallRequestToActivity(ACTION_AUDIO_SESSION, handle)
        Log.d(TAG, "onAnswer videoState executed")
    }

    @Override
    fun onPlayDtmfTone(dtmf: Char) {
        try {
            handle.put("DTMF", Character.toString(dtmf))
        } catch (exception: Throwable) {
            Log.e(TAG, "Handle map error", exception)
        }
        sendCallRequestToActivity(ACTION_DTMF_TONE, handle)
    }

    @Override
    fun onDisconnect() {
        super.onDisconnect()
        setDisconnected(DisconnectCause(DisconnectCause.LOCAL))
        sendCallRequestToActivity(ACTION_END_CALL, handle)
        Log.d(TAG, "onDisconnect executed")
        try {
            (context as VoiceConnectionService).deinitConnection(handle.get(EXTRA_CALL_UUID))
        } catch (exception: Throwable) {
            Log.e(TAG, "Handle map error", exception)
        }
        destroy()
    }

    fun reportDisconnect(reason: Int) {
        super.onDisconnect()
        when (reason) {
            1 -> setDisconnected(DisconnectCause(DisconnectCause.ERROR))
            2, 5 -> setDisconnected(DisconnectCause(DisconnectCause.REMOTE))
            3 -> setDisconnected(DisconnectCause(DisconnectCause.BUSY))
            4 -> setDisconnected(DisconnectCause(DisconnectCause.ANSWERED_ELSEWHERE))
            6 -> setDisconnected(DisconnectCause(DisconnectCause.MISSED))
            else -> {}
        }
        (context as VoiceConnectionService).deinitConnection(handle.get(EXTRA_CALL_UUID))
        destroy()
    }

    @Override
    fun onAbort() {
        super.onAbort()
        setDisconnected(DisconnectCause(DisconnectCause.REJECTED))
        sendCallRequestToActivity(ACTION_END_CALL, handle)
        Log.d(TAG, "onAbort executed")
        try {
            (context as VoiceConnectionService).deinitConnection(handle.get(EXTRA_CALL_UUID))
        } catch (exception: Throwable) {
            Log.e(TAG, "Handle map error", exception)
        }
        destroy()
    }

    @Override
    fun onHold() {
        super.onHold()
        this.setOnHold()
        sendCallRequestToActivity(ACTION_HOLD_CALL, handle)
    }

    @Override
    fun onUnhold() {
        super.onUnhold()
        sendCallRequestToActivity(ACTION_UNHOLD_CALL, handle)
        setActive()
    }

    @Override
    fun onReject() {
        super.onReject()
        setDisconnected(DisconnectCause(DisconnectCause.REJECTED))
        sendCallRequestToActivity(ACTION_END_CALL, handle)
        Log.d(TAG, "onReject executed")
        try {
            (context as VoiceConnectionService).deinitConnection(handle.get(EXTRA_CALL_UUID))
        } catch (exception: Throwable) {
            Log.e(TAG, "Handle map error", exception)
        }
        destroy()
    }

    /*
     * Send call request to the RNCallKeepModule
     */
    private fun sendCallRequestToActivity(action: String, @Nullable attributeMap: HashMap?) {
        val instance = this
        val handler = Handler()
        handler.post(object : Runnable() {
            @Override
            fun run() {
                val intent = Intent(action)
                if (attributeMap != null) {
                    val extras = Bundle()
                    extras.putSerializable("attributeMap", attributeMap)
                    intent.putExtras(extras)
                }
                LocalBroadcastManager.getInstance(context).sendBroadcast(intent)
            }
        })
    }

    companion object {
        private const val TAG = "RNCK:VoiceConnection"
    }
}