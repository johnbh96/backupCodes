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

import android.annotation.SuppressLint

class CallKeepBackgroundMessagingService : Service() {
    @Nullable
    @Override
    fun onBind(intent: Intent): IBinder? {
        Log.d(TAG,
            "wakeUpApplication: " + intent.getStringExtra("callUUID")
                .toString() + ", number : " + intent.getStringExtra("handle")
                .toString() + ", displayName:" + intent.getStringExtra("name")
        )
        //TODO: not implemented
        return null
    }

    @Override
    fun onDestroy() {
        super.onDestroy()
        if (sWakeLock != null) {
            sWakeLock.release()
        }
    }

    companion object {
        private const val TAG = "FLT:CallKeepService"

        @Nullable
        private var sWakeLock: PowerManager.WakeLock? = null

        /**
         * Acquire a wake lock to ensure the device doesn't go to sleep while processing background tasks.
         */
        @SuppressLint("WakelockTimeout")
        fun acquireWakeLockNow(context: Context) {
            if (sWakeLock == null || !sWakeLock.isHeld()) {
                val powerManager: PowerManager =
                    context.getSystemService(POWER_SERVICE) as PowerManager
                sWakeLock = powerManager.newWakeLock(
                    PowerManager.PARTIAL_WAKE_LOCK,
                    CallKeepBackgroundMessagingService::class.java.getCanonicalName()
                )
                sWakeLock.setReferenceCounted(false)
                sWakeLock.acquire()
            }
        }
    }
}