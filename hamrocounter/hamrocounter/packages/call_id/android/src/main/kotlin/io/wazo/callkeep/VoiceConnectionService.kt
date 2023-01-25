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

// @see https://github.com/kbagchiGWC/voice-quickstart-android/blob/9a2aff7fbe0d0a5ae9457b48e9ad408740dfb968/exampleConnectionService/src/main/java/com/twilio/voice/examples/connectionservice/VoiceConnectionService.java
@TargetApi(Build.VERSION_CODES.M)
class VoiceConnectionService : ConnectionService() {
    init {
        Log.e(TAG, "Constructor")
        isReachable = false
        isInitialized = false
        isAvailable = false
        currentConnectionRequest = null
        currentConnectionService = this
    }

    @Override
    fun onCreateIncomingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest
    ): Connection {
        val extra: Bundle = request.getExtras()
        val number: Uri = request.getAddress()
        val name: String = extra.getString(EXTRA_CALLER_NAME)
        val incomingCallConnection: Connection = createConnection(request)
        incomingCallConnection.setRinging()
        incomingCallConnection.setInitialized()
        startForegroundService()
        return incomingCallConnection
    }

    @Override
    fun onCreateOutgoingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest
    ): Connection? {
        hasOutgoingCall = true
        val uuid: String = UUID.randomUUID().toString()
        if (!isInitialized && !isReachable) {
            notReachableCallUuid = uuid
            currentConnectionRequest = request
            checkReachability()
        }
        return makeOutgoingCall(request, uuid, false)
    }

    private fun makeOutgoingCall(
        request: ConnectionRequest,
        uuid: String,
        forceWakeUp: Boolean
    ): Connection? {
        val extras: Bundle = request.getExtras()
        var outgoingCallConnection: Connection? = null
        val number: String = request.getAddress().getSchemeSpecificPart()
        val extrasNumber: String = extras.getString(EXTRA_CALL_NUMBER)
        val displayName: String = extras.getString(EXTRA_CALLER_NAME)
        val isForeground = isRunning(this.getApplicationContext())
        Log.d(TAG, "makeOutgoingCall:$uuid, number: $number, displayName:$displayName")

        // Wakeup application if needed
        if (!isForeground || forceWakeUp) {
            Log.d(TAG, "onCreateOutgoingConnection: Waking up application")
            wakeUpApplication(uuid, number, displayName)
        } else if (!canMakeOutgoingCall() && isReachable) {
            Log.d(TAG, "onCreateOutgoingConnection: not available")
            return Connection.createFailedConnection(DisconnectCause(DisconnectCause.LOCAL))
        }

        // TODO: Hold all other calls
        if (extrasNumber == null || !extrasNumber.equals(number)) {
            extras.putString(EXTRA_CALL_UUID, uuid)
            extras.putString(EXTRA_CALLER_NAME, displayName)
            extras.putString(EXTRA_CALL_NUMBER, number)
        }
        outgoingCallConnection = createConnection(request)
        outgoingCallConnection.setDialing()
        outgoingCallConnection.setAudioModeIsVoip(true)
        outgoingCallConnection.setCallerDisplayName(
            displayName,
            TelecomManager.PRESENTATION_ALLOWED
        )
        startForegroundService()

        // ‍️Weirdly on some Samsung phones (A50, S9...) using `setInitialized` will not display the native UI ...
        // when making a call from the native Phone application. The call will still be displayed correctly without it.
        if (!Build.MANUFACTURER.equalsIgnoreCase("Samsung")) {
            outgoingCallConnection.setInitialized()
        }
        val extrasMap: HashMap<String, String> = bundleToMap(extras)
        sendCallRequestToActivity(ACTION_ONGOING_CALL, extrasMap)
        sendCallRequestToActivity(ACTION_AUDIO_SESSION, extrasMap)
        Log.d(TAG, "onCreateOutgoingConnection: calling")
        return outgoingCallConnection
    }

    private fun startForegroundService() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            // Foreground services not required before SDK 28
            return
        }
        Log.d(TAG, "[VoiceConnectionService] startForegroundService")
        if (_settings == null || !_settings.hasKey("foregroundService")) {
            Log.w(
                TAG,
                "[VoiceConnectionService] Not creating foregroundService because not configured"
            )
            return
        }
        val foregroundSettings: ConstraintsMap = _settings.getMap("foregroundService")
        val NOTIFICATION_CHANNEL_ID: String = foregroundSettings.getString("channelId")
        val channelName: String = foregroundSettings.getString("channelName")
        val chan = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            channelName,
            NotificationManager.IMPORTANCE_NONE
        )
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE)
        val manager: NotificationManager? =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?
        assert(manager != null)
        manager.createNotificationChannel(chan)
        val notificationBuilder: NotificationCompat.Builder = Builder(this, NOTIFICATION_CHANNEL_ID)
        notificationBuilder.setOngoing(true)
            .setContentTitle(foregroundSettings.getString("notificationTitle"))
            .setPriority(NotificationManager.IMPORTANCE_MIN)
            .setCategory(Notification.CATEGORY_SERVICE)
        if (foregroundSettings.hasKey("notificationIcon")) {
            val context: Context = this.getApplicationContext()
            val res: Resources = context.getResources()
            val smallIcon: String = foregroundSettings.getString("notificationIcon")
            val mipmap = "mipmap/"
            val drawable = "drawable/"
            if (smallIcon.contains(mipmap)) {
                notificationBuilder.setSmallIcon(
                    res.getIdentifier(
                        smallIcon.replace(mipmap, ""),
                        "mipmap", context.getPackageName()
                    )
                )
            } else if (smallIcon.contains(drawable)) {
                notificationBuilder.setSmallIcon(
                    res.getIdentifier(
                        smallIcon.replace(drawable, ""),
                        "drawable", context.getPackageName()
                    )
                )
            }
        }
        Log.d(TAG, "[VoiceConnectionService] Starting foreground service")
        val notification: Notification = notificationBuilder.build()
        startForeground(FOREGROUND_SERVICE_TYPE_MICROPHONE, notification)
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private fun stopForegroundService() {
        Log.d(TAG, "[VoiceConnectionService] stopForegroundService")
        if (_settings == null || !_settings.hasKey("foregroundService")) {
            Log.d(
                TAG,
                "[VoiceConnectionService] Discarding stop foreground service, no service configured"
            )
            return
        }
        stopForeground(FOREGROUND_SERVICE_TYPE_MICROPHONE)
    }

    private fun wakeUpApplication(uuid: String, number: String, displayName: String) {
        val headlessIntent = Intent(
            this.getApplicationContext(),
            CallKeepBackgroundMessagingService::class.java
        )
        headlessIntent.putExtra("callUUID", uuid)
        headlessIntent.putExtra("name", displayName)
        headlessIntent.putExtra("handle", number)
        Log.d(TAG, "wakeUpApplication: $uuid, number : $number, displayName:$displayName")
        val name: ComponentName = this.getApplicationContext().startService(headlessIntent)
        if (name != null) {
            CallKeepBackgroundMessagingService.acquireWakeLockNow(this.getApplicationContext())
        }
    }

    private fun wakeUpAfterReachabilityTimeout(request: ConnectionRequest?) {
        if (currentConnectionRequest == null) {
            return
        }
        Log.d(TAG, "checkReachability timeout, force wakeup")
        val extras: Bundle = request.getExtras()
        val number: String = request.getAddress().getSchemeSpecificPart()
        val displayName: String = extras.getString(EXTRA_CALLER_NAME)
        wakeUpApplication(notReachableCallUuid, number, displayName)
        currentConnectionRequest = null
    }

    private fun checkReachability() {
        Log.d(TAG, "checkReachability")
        val instance = this
        sendCallRequestToActivity(ACTION_CHECK_REACHABILITY, null)
        Handler().postDelayed(
            object : Runnable() {
                fun run() {
                    instance.wakeUpAfterReachabilityTimeout(currentConnectionRequest)
                }
            }, 2000
        )
    }

    private fun canMakeOutgoingCall(): Boolean {
        return isAvailable
    }

    private fun createConnection(request: ConnectionRequest): Connection {
        val extras: Bundle = request.getExtras()
        val extrasMap: HashMap<String?, String?> = bundleToMap(extras)
        extrasMap.put(EXTRA_CALL_NUMBER, request.getAddress().toString())
        val connection = VoiceConnection(this, extrasMap)
        connection.setConnectionCapabilities(Connection.CAPABILITY_MUTE or Connection.CAPABILITY_SUPPORT_HOLD)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val context: Context = getApplicationContext()
            val telecomManager: TelecomManager =
                context.getSystemService(context.TELECOM_SERVICE) as TelecomManager
            val phoneAccount: PhoneAccount =
                telecomManager.getPhoneAccount(request.getAccountHandle())

            //If the phone account is self managed, then this connection must also be self managed.
            if (phoneAccount.getCapabilities() and PhoneAccount.CAPABILITY_SELF_MANAGED === PhoneAccount.CAPABILITY_SELF_MANAGED) {
                Log.d(
                    TAG,
                    "[VoiceConnectionService] PhoneAccount is SELF_MANAGED, so connection will be too"
                )
                connection.setConnectionProperties(Connection.PROPERTY_SELF_MANAGED)
            } else {
                Log.d(
                    TAG,
                    "[VoiceConnectionService] PhoneAccount is not SELF_MANAGED, so connection won't be either"
                )
            }
        }
        connection.setInitializing()
        connection.setExtras(extras)
        currentConnections.put(extras.getString(EXTRA_CALL_UUID), connection)

        // Get other connections for conferencing
        val otherConnections: Map<String, VoiceConnection> = HashMap()
        for (entry in currentConnections.entrySet()) {
            if (!extras.getString(EXTRA_CALL_UUID).equals(entry.getKey())) {
                otherConnections.put(entry.getKey(), entry.getValue())
            }
        }
        val conferenceConnections: List<Connection> =
            ArrayList<Connection>(otherConnections.values())
        connection.setConferenceableConnections(conferenceConnections)
        return connection
    }

    @Override
    fun onConference(connection1: Connection, connection2: Connection) {
        super.onConference(connection1, connection2)
        val voiceConference = VoiceConference(phoneAccountHandle)
        voiceConference.addConnection(connection1)
        voiceConference.addConnection(connection2)
        connection1.onUnhold()
        connection2.onUnhold()
        this.addConference(voiceConference)
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
                LocalBroadcastManager.getInstance(instance).sendBroadcast(intent)
            }
        })
    }

    private fun bundleToMap(extras: Bundle): HashMap<String, String> {
        val extrasMap: HashMap<String, String> = HashMap()
        val keySet: Set<String> = extras.keySet()
        val iterator = keySet.iterator()
        while (iterator.hasNext()) {
            val key = iterator.next()
            if (extras.get(key) != null) {
                extrasMap.put(key, extras.get(key).toString())
            }
        }
        return extrasMap
    }

    companion object {
        private var isAvailable: Boolean
        private var isInitialized: Boolean
        private var isReachable: Boolean
        private var notReachableCallUuid: String? = null
        private var currentConnectionRequest: ConnectionRequest?
        private var phoneAccountHandle: PhoneAccountHandle? = null
        private const val TAG = "RNCK:VoiceConnectionService"
        var currentConnections: Map<String, VoiceConnection> = HashMap()
        var hasOutgoingCall = false
        var currentConnectionService: VoiceConnectionService? = null
        var _settings: ConstraintsMap? = null
        fun getConnection(connectionId: String): Connection? {
            return if (currentConnections.containsKey(connectionId)) {
                currentConnections[connectionId]
            } else null
        }

        val activeConnections: List<String>
            get() = ArrayList(currentConnections.keySet())

        fun setPhoneAccountHandle(phoneAccountHandle: PhoneAccountHandle?) {
            Companion.phoneAccountHandle = phoneAccountHandle
        }

        fun setAvailable(value: Boolean) {
            Log.d(TAG, "setAvailable: " + if (value) "true" else "false")
            if (value) {
                isInitialized = true
            }
            isAvailable = value
        }

        fun setSettings(settings: ConstraintsMap?) {
            _settings = settings
        }

        fun setReachable() {
            Log.d(TAG, "setReachable")
            isReachable = true
            currentConnectionRequest = null
        }

        fun deinitConnection(connectionId: String) {
            Log.d(TAG, "deinitConnection:$connectionId")
            hasOutgoingCall = false
            currentConnectionService!!.stopForegroundService()
            if (currentConnections.containsKey(connectionId)) {
                currentConnections.remove(connectionId)
            }
        }

        /**
         * https://stackoverflow.com/questions/5446565/android-how-do-i-check-if-activity-is-running
         *
         * @param context Context
         * @return boolean
         */
        fun isRunning(context: Context): Boolean {
            val activityManager: ActivityManager =
                context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val tasks: List<RunningTaskInfo> = activityManager.getRunningTasks(Integer.MAX_VALUE)
            for (task in tasks) {
                if (context.getPackageName()
                        .equalsIgnoreCase(task.baseActivity.getPackageName())
                ) return true
            }
            return false
        }
    }
}