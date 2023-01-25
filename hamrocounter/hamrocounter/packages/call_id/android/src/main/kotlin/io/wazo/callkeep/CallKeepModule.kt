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

import android.Manifest

class CallKeepModule(context: Context?, messenger: BinaryMessenger?) {
    private val _context: Context?
    private var isReceiverRegistered = false
    private var voiceBroadcastReceiver: VoiceBroadcastReceiver? = null
    private var _settings: ConstraintsMap? = null
    var _currentActivity: Activity? = null
    var _eventChannel: MethodChannel

    init {
        _context = context
        _eventChannel = MethodChannel(messenger, "FlutterCallKeep.Event")
    }

    fun setActivity(activity: Activity?) {
        _currentActivity = activity
    }

    fun dispose() {
        if (voiceBroadcastReceiver == null || _context == null) return
        LocalBroadcastManager.getInstance(_context).unregisterReceiver(voiceBroadcastReceiver)
        VoiceConnectionService.setPhoneAccountHandle(null)
        isReceiverRegistered = false
    }

    fun handleMethodCall(@NonNull call: MethodCall, @NonNull result: Result): Boolean {
        when (call.method) {
            "setup" -> {
                setup(ConstraintsMap(call.argument("options") as Map<String?, Object?>))
                result.success(null)
            }
            "displayIncomingCall" -> {
                displayIncomingCall(
                    call.argument("uuid") as String,
                    call.argument("handle") as String,
                    call.argument("localizedCallerName") as String
                )
                result.success(null)
            }
            "answerIncomingCall" -> {
                answerIncomingCall(call.argument("uuid") as String)
                result.success(null)
            }
            "startCall" -> {
                startCall(
                    call.argument("uuid") as String,
                    call.argument("number") as String,
                    call.argument("callerName") as String
                )
                result.success(null)
            }
            "endCall" -> {
                endCall(call.argument("uuid") as String)
                result.success(null)
            }
            "endAllCalls" -> {
                endAllCalls()
                result.success(null)
            }
            "checkPhoneAccountPermission" -> {
                checkPhoneAccountPermission(
                    ConstraintsArray(call.argument("optionalPermissions") as ArrayList<Object?>),
                    result
                )
            }
            "checkDefaultPhoneAccount" -> {
                checkDefaultPhoneAccount(result)
            }
            "setOnHold" -> {
                setOnHold(call.argument("uuid") as String, call.argument("hold") as Boolean)
                result.success(null)
            }
            "reportEndCallWithUUID" -> {
                reportEndCallWithUUID(
                    call.argument("uuid") as String,
                    call.argument("reason") as Int
                )
                result.success(null)
            }
            "rejectCall" -> {
                rejectCall(call.argument("uuid") as String)
                result.success(null)
            }
            "setMutedCall" -> {
                setMutedCall(call.argument("uuid") as String, call.argument("muted") as Boolean)
                result.success(null)
            }
            "sendDTMF" -> {
                sendDTMF(call.argument("uuid") as String, call.argument("key") as String)
                result.success(null)
            }
            "updateDisplay" -> {
                updateDisplay(
                    call.argument("uuid") as String,
                    call.argument("displayName") as String,
                    call.argument("handle") as String
                )
                result.success(null)
            }
            "hasPhoneAccount" -> {
                hasPhoneAccount(result)
            }
            "hasOutgoingCall" -> {
                hasOutgoingCall(result)
            }
            "hasPermissions" -> {
                hasPermissions(result)
            }
            "setAvailable" -> {
                setAvailable(call.argument("available") as Boolean)
                result.success(null)
            }
            "setReachable" -> {
                setReachable()
                result.success(null)
            }
            "setCurrentCallActive" -> {
                setCurrentCallActive(call.argument("uuid") as String)
                result.success(null)
            }
            "openPhoneAccounts" -> {
                openPhoneAccounts(result)
            }
            "backToForeground" -> {
                backToForeground(result)
            }
            "foregroundService" -> {
                VoiceConnectionService.setSettings(ConstraintsMap(call.argument("settings") as Map<String?, Object?>))
                result.success(null)
            }
            "isCallActive" -> {
                isCallActive(call.argument("uuid") as String, result)
            }
            "activeCalls" -> {
                activeCalls(result)
            }
            else -> return false
        }
        return true
    }

    fun setup(options: ConstraintsMap?) {
        if (isReceiverRegistered) {
            return
        }
        VoiceConnectionService.setAvailable(false)
        _settings = options
        if (isConnectionServiceAvailable) {
            this.registerPhoneAccount()
            registerEvents()
            VoiceConnectionService.setAvailable(true)
        }
        VoiceConnectionService.setSettings(options)
    }

    fun registerPhoneAccount() {
        if (!isConnectionServiceAvailable) {
            return
        }
        this.registerPhoneAccount(appContext)
    }

    fun registerEvents() {
        if (!isConnectionServiceAvailable) {
            return
        }
        voiceBroadcastReceiver = VoiceBroadcastReceiver()
        registerReceiver()
        VoiceConnectionService.setPhoneAccountHandle(handle)
    }

    fun displayIncomingCall(uuid: String?, number: String, callerName: String) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        Log.d(TAG, "displayIncomingCall number: $number, callerName: $callerName")
        val extras = Bundle()
        val uri: Uri = Uri.fromParts(PhoneAccount.SCHEME_TEL, number, null)
        extras.putParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS, uri)
        extras.putString(EXTRA_CALLER_NAME, callerName)
        extras.putString(EXTRA_CALL_UUID, uuid)
        telecomManager.addNewIncomingCall(handle, extras)
    }

    fun answerIncomingCall(uuid: String?) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        conn.onAnswer()
    }

    fun startCall(uuid: String?, number: String?, callerName: String) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount() || !hasPermissions() || number == null) {
            return
        }
        Log.d(TAG, "startCall number: $number, callerName: $callerName")
        val extras = Bundle()
        val uri: Uri = Uri.fromParts(PhoneAccount.SCHEME_TEL, number, null)
        val callExtras = Bundle()
        callExtras.putString(EXTRA_CALLER_NAME, callerName)
        callExtras.putString(EXTRA_CALL_UUID, uuid)
        callExtras.putString(EXTRA_CALL_NUMBER, number)
        extras.putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, handle)
        extras.putParcelable(TelecomManager.EXTRA_OUTGOING_CALL_EXTRAS, callExtras)
        telecomManager.placeCall(uri, extras)
    }

    fun endCall(uuid: String?) {
        Log.d(TAG, "endCall called")
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        conn.onDisconnect()
        Log.d(TAG, "endCall executed")
    }

    fun endAllCalls() {
        Log.d(TAG, "endAllCalls called")
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        val currentConnections: Map<String, VoiceConnection> =
            VoiceConnectionService.currentConnections
        for (connectionEntry in currentConnections.entrySet()) {
            val connectionToEnd: Connection = connectionEntry.getValue()
            connectionToEnd.onDisconnect()
        }
        Log.d(TAG, "endAllCalls executed")
    }

    fun checkPhoneAccountPermission(
        optionalPermissions: ConstraintsArray,
        @NonNull result: MethodChannel.Result
    ) {
        if (!isConnectionServiceAvailable) {
            result.error(
                E_ACTIVITY_DOES_NOT_EXIST,
                "ConnectionService not available for this version of Android.",
                null
            )
            return
        }
        if (_currentActivity == null) {
            result.error(E_ACTIVITY_DOES_NOT_EXIST, "Activity doesn't exist", null)
            return
        }
        val optionalPermsArr = arrayOfNulls<String>(optionalPermissions.size())
        for (i in 0 until optionalPermissions.size()) {
            optionalPermsArr[i] = optionalPermissions.getString(i)
        }
        val allPermissions: Array<String> =
            Arrays.copyOf(permissions, permissions.size + optionalPermsArr.size)
        System.arraycopy(
            optionalPermsArr,
            0,
            allPermissions,
            permissions.size,
            optionalPermsArr.size
        )
        if (!this.hasPermissions()) {
            //requestPermissions(_currentActivity, allPermissions, REQUEST_READ_PHONE_STATE);
            val list: ArrayList<String> = ArrayList<String>()
            Collections.addAll(list, allPermissions)
            requestPermissions(
                list,  /* successCallback */
                object : Callback() {
                    @Override
                    operator fun invoke(vararg args: Object) {
                        val grantedPermissions = args[0] as List<String>
                        result.success(grantedPermissions.size() === list.size())
                    }
                },  /* errorCallback */
                object : Callback() {
                    @Override
                    operator fun invoke(vararg args: Object?) {
                        result.success(false)
                    }
                })
            return
        }
        result.success(!hasPhoneAccount())
    }

    fun checkDefaultPhoneAccount(@NonNull result: MethodChannel.Result) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            result.success(true)
            return
        }
        if (!Build.MANUFACTURER.equalsIgnoreCase("Samsung")) {
            result.success(true)
            return
        }
        val hasSim = telephonyManager.getSimState() !== TelephonyManager.SIM_STATE_ABSENT
        val hasDefaultAccount = telecomManager.getDefaultOutgoingPhoneAccount("tel") != null
        result.success(!hasSim || hasDefaultAccount)
    }

    fun setOnHold(uuid: String?, shouldHold: Boolean) {
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        if (shouldHold == true) {
            conn.onHold()
        } else {
            conn.onUnhold()
        }
    }

    fun reportEndCallWithUUID(uuid: String?, reason: Int) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        val conn: VoiceConnection = VoiceConnectionService.getConnection(uuid) as VoiceConnection
            ?: return
        conn.reportDisconnect(reason)
    }

    fun rejectCall(uuid: String?) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            return
        }
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        conn.onReject()
    }

    fun setMutedCall(uuid: String?, shouldMute: Boolean) {
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        var newAudioState: CallAudioState? = null
        //if the requester wants to mute, do that. otherwise unmute
        if (shouldMute) {
            newAudioState = CallAudioState(
                true, conn.getCallAudioState().getRoute(),
                conn.getCallAudioState().getSupportedRouteMask()
            )
        } else {
            newAudioState = CallAudioState(
                false, conn.getCallAudioState().getRoute(),
                conn.getCallAudioState().getSupportedRouteMask()
            )
        }
        conn.onCallAudioStateChanged(newAudioState)
    }

    fun sendDTMF(uuid: String?, key: String) {
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        val dtmf: Char = key.charAt(0)
        conn.onPlayDtmfTone(dtmf)
    }

    fun updateDisplay(uuid: String?, displayName: String?, uri: String?) {
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        conn.setAddress(Uri.parse(uri), TelecomManager.PRESENTATION_ALLOWED)
        conn.setCallerDisplayName(displayName, TelecomManager.PRESENTATION_ALLOWED)
    }

    fun hasPhoneAccount(@NonNull result: MethodChannel.Result) {
        if (telecomManager == null) {
            initializeTelecomManager()
        }
        result.success(hasPhoneAccount())
    }

    fun hasOutgoingCall(@NonNull result: MethodChannel.Result) {
        result.success(VoiceConnectionService.hasOutgoingCall)
    }

    fun hasPermissions(@NonNull result: MethodChannel.Result) {
        result.success(this.hasPermissions())
    }

    fun isCallActive(uuid: String?, @NonNull result: MethodChannel.Result) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            result.success(false)
            return
        }
        val conn: Connection = VoiceConnectionService.getConnection(uuid)
        result.success(conn != null)
    }

    fun activeCalls(@NonNull result: MethodChannel.Result) {
        if (!isConnectionServiceAvailable || !hasPhoneAccount()) {
            result.success(ArrayList())
            return
        }
        result.success(VoiceConnectionService.getActiveConnections())
    }

    fun setAvailable(active: Boolean?) {
        VoiceConnectionService.setAvailable(active)
    }

    fun setReachable() {
        VoiceConnectionService.setReachable()
    }

    fun setCurrentCallActive(uuid: String?) {
        val conn: Connection = VoiceConnectionService.getConnection(uuid) ?: return
        conn.setConnectionCapabilities(conn.getConnectionCapabilities() or Connection.CAPABILITY_HOLD)
        conn.setActive()
    }

    fun openPhoneAccounts(@NonNull result: MethodChannel.Result) {
        if (!isConnectionServiceAvailable) {
            result.error("ConnectionServiceNotAvailable", null, null)
            return
        }
        if (Build.MANUFACTURER.equalsIgnoreCase("Samsung")) {
            val intent = Intent()
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
            intent.setComponent(
                ComponentName(
                    "com.android.server.telecom",
                    "com.android.server.telecom.settings.EnableAccountPreferenceActivity"
                )
            )
            _currentActivity.startActivity(intent)
            result.success(null)
            return
        }
        val intent = Intent(TelecomManager.ACTION_CHANGE_PHONE_ACCOUNTS)
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
        _currentActivity.startActivity(intent)
        result.success(null)
    }

    @SuppressLint("WrongConstant")
    fun backToForeground(@NonNull result: MethodChannel.Result) {
        val context: Context = appContext
        val packageName: String = context.getPackageName()
        val focusIntent: Intent =
            context.getPackageManager().getLaunchIntentForPackage(packageName).cloneFilter()
        val activity: Activity? = _currentActivity
        val isOpened = activity != null
        Log.d(TAG, "backToForeground, app isOpened ?" + if (isOpened) "true" else "false")
        if (isOpened) {
            focusIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            activity.startActivity(focusIntent)
        } else {
            focusIntent.addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK +
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED +
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD +
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
            if (activity != null) {
                activity.startActivity(focusIntent)
            } else {
                context.startActivity(focusIntent)
            }
        }
        result.success(isOpened)
    }

    private fun initializeTelecomManager() {
        val context: Context = appContext
        val cName = ComponentName(context, VoiceConnectionService::class.java)
        val appName = getApplicationName(context)
        handle = PhoneAccountHandle(cName, appName)
        telecomManager = context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
    }

    private fun registerPhoneAccount(appContext: Context) {
        if (!isConnectionServiceAvailable) {
            return
        }
        initializeTelecomManager()
        val appName = getApplicationName(this.appContext)
        val builder: PhoneAccount.Builder = Builder(handle, appName)
            .setCapabilities(PhoneAccount.CAPABILITY_CALL_PROVIDER)
        if (_settings != null && _settings.hasKey("imageName")) {
            val identifier: Int = appContext.getResources().getIdentifier(
                _settings.getString("imageName"),
                "drawable",
                appContext.getPackageName()
            )
            val icon: Icon = Icon.createWithResource(appContext, identifier)
            builder.setIcon(icon)
        }
        val account: PhoneAccount = builder.build()
        telephonyManager =
            this.appContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        telecomManager.registerPhoneAccount(account)
    }

    private fun sendEventToFlutter(eventName: String, @Nullable params: ConstraintsMap) {
        _eventChannel.invokeMethod(eventName, params.toMap())
    }

    private fun getApplicationName(appContext: Context): String {
        val applicationInfo: ApplicationInfo = appContext.getApplicationInfo()
        val stringId: Int = applicationInfo.labelRes
        return if (stringId == 0) applicationInfo.nonLocalizedLabel.toString() else appContext.getString(
            stringId
        )
    }

    private fun hasPermissions(): Boolean {
        var hasPermissions = true
        for (permission in permissions) {
            val permissionCheck: Int =
                ContextCompat.checkSelfPermission(_currentActivity, permission)
            if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                hasPermissions = false
            }
        }
        return hasPermissions
    }

    private fun registerReceiver() {
        if (!isReceiverRegistered) {
            val intentFilter = IntentFilter()
            intentFilter.addAction(ACTION_END_CALL)
            intentFilter.addAction(ACTION_ANSWER_CALL)
            intentFilter.addAction(ACTION_MUTE_CALL)
            intentFilter.addAction(ACTION_UNMUTE_CALL)
            intentFilter.addAction(ACTION_DTMF_TONE)
            intentFilter.addAction(ACTION_UNHOLD_CALL)
            intentFilter.addAction(ACTION_HOLD_CALL)
            intentFilter.addAction(ACTION_ONGOING_CALL)
            intentFilter.addAction(ACTION_AUDIO_SESSION)
            intentFilter.addAction(ACTION_CHECK_REACHABILITY)
            LocalBroadcastManager.getInstance(_context)
                .registerReceiver(voiceBroadcastReceiver, intentFilter)
            isReceiverRegistered = true
        }
    }

    private val appContext: Context
        private get() = _context.getApplicationContext()

    @RequiresApi(api = Build.VERSION_CODES.M)
    private fun requestPermissions(
        permissions: ArrayList<String>,
        successCallback: Callback,
        errorCallback: Callback
    ) {
        val callback: PermissionUtils.Callback =
            label@ PermissionUtils.Callback { permissions_, grantResults ->
                val grantedPermissions: List<String> = ArrayList()
                val deniedPermissions: List<String> = ArrayList()
                var i = 0
                while (i < permissions_.length) {
                    val permission: String = permissions_.get(i)
                    val grantResult: Int = grantResults.get(i)
                    if (grantResult == PackageManager.PERMISSION_GRANTED) {
                        grantedPermissions.add(permission)
                    } else {
                        deniedPermissions.add(permission)
                    }
                    ++i
                }

                // Success means that all requested permissions were granted.
                for (p in permissions) {
                    if (!grantedPermissions.contains(p)) {
                        // According to step 6 of the getUserMedia() algorithm
                        // "if the result is denied, jump to the step Permission
                        // Failure."
                        errorCallback.invoke(deniedPermissions)
                        return@label
                    }
                }
                successCallback.invoke(grantedPermissions)
            }
        val activity: Activity? = _currentActivity
        if (activity != null) {
            PermissionUtils.requestPermissions(
                activity, permissions.toArray(arrayOfNulls<String>(permissions.size())), callback
            )
        }
    }

    private inner class VoiceBroadcastReceiver : BroadcastReceiver() {
        @Override
        fun onReceive(context: Context?, intent: Intent) {
            val args = ConstraintsMap()
            val attributeMap: HashMap<String, String> =
                intent.getSerializableExtra("attributeMap") as HashMap<String, String>
            when (intent.getAction()) {
                ACTION_END_CALL -> {
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepPerformEndCallAction", args)
                }
                ACTION_ANSWER_CALL -> {
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepPerformAnswerCallAction", args)
                }
                ACTION_HOLD_CALL -> {
                    args.putBoolean("hold", true)
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepDidToggleHoldAction", args)
                }
                ACTION_UNHOLD_CALL -> {
                    args.putBoolean("hold", false)
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepDidToggleHoldAction", args)
                }
                ACTION_MUTE_CALL -> {
                    args.putBoolean("muted", true)
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepDidPerformSetMutedCallAction", args)
                }
                ACTION_UNMUTE_CALL -> {
                    args.putBoolean("muted", false)
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepDidPerformSetMutedCallAction", args)
                }
                ACTION_DTMF_TONE -> {
                    args.putString("digits", attributeMap.get("DTMF"))
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    sendEventToFlutter("CallKeepDidPerformDTMFAction", args)
                }
                ACTION_ONGOING_CALL -> {
                    args.putString("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    args.putString("handle", attributeMap.get(EXTRA_CALL_NUMBER))
                    args.putString("name", attributeMap.get(EXTRA_CALLER_NAME))
                    sendEventToFlutter("CallKeepDidReceiveStartCallAction", args)
                }
                ACTION_AUDIO_SESSION -> sendEventToFlutter("CallKeepDidActivateAudioSession", args)
                ACTION_CHECK_REACHABILITY -> sendEventToFlutter("CallKeepCheckReachability", args)
                ACTION_WAKE_APP -> {
                    val headlessIntent =
                        Intent(_context, CallKeepBackgroundMessagingService::class.java)
                    headlessIntent.putExtra("callUUID", attributeMap.get(EXTRA_CALL_UUID))
                    headlessIntent.putExtra("name", attributeMap.get(EXTRA_CALLER_NAME))
                    headlessIntent.putExtra("handle", attributeMap.get(EXTRA_CALL_NUMBER))
                    Log.d(
                        TAG,
                        "wakeUpApplication: " + attributeMap.get(EXTRA_CALL_UUID)
                            .toString() + ", number : " + attributeMap.get(EXTRA_CALL_NUMBER)
                            .toString() + ", displayName:" + attributeMap.get(EXTRA_CALLER_NAME)
                    )
                    val name: ComponentName = _context.startService(headlessIntent)
                    if (name != null) {
                        CallKeepBackgroundMessagingService.acquireWakeLockNow(_context)
                    }
                }
            }
        }
    }

    companion object {
        const val REQUEST_READ_PHONE_STATE = 1337
        const val REQUEST_REGISTER_CALL_PROVIDER = 394859
        private const val E_ACTIVITY_DOES_NOT_EXIST = "E_ACTIVITY_DOES_NOT_EXIST"
        private const val REACT_NATIVE_MODULE_NAME = "CallKeep"
        private val permissions = arrayOf<String>(
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.CALL_PHONE,
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.READ_PHONE_NUMBERS
        )
        private const val TAG = "FLT:CallKeepModule"
        private var telecomManager: TelecomManager? = null
        private var telephonyManager: TelephonyManager? = null
        var handle: PhoneAccountHandle? = null

        // PhoneAccount is available since api level 23
        val isConnectionServiceAvailable: Boolean
            get() =// PhoneAccount is available since api level 23
                Build.VERSION.SDK_INT >= 23

        private fun hasPhoneAccount(): Boolean {
            return isConnectionServiceAvailable && telecomManager != null && telecomManager.getPhoneAccount(
                handle
            ) != null && telecomManager.getPhoneAccount(handle).isEnabled()
        }
    }
}