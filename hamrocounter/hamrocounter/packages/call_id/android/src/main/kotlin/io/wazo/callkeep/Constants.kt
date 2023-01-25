package io.package.call_id

import io.package.call_id.ConstraintsMap
import io.package.call_id.PermissionUtils
import io.package.call_id.PermissionUtils.RequestPermissionsFragment
import io.package.call_id.ConstraintsArray
import io.package.call_id.VoiceConnection
import io.package.call_id.VoiceConnectionService
import com.package.call_id.FlutterCallkeepPlugin

object Constants {
    const val ACTION_ANSWER_CALL = "ACTION_ANSWER_CALL"
    const val ACTION_AUDIO_SESSION = "ACTION_AUDIO_SESSION"
    const val ACTION_CHECK_REACHABILITY = "ACTION_CHECK_REACHABILITY"
    const val ACTION_DTMF_TONE = "ACTION_DTMF_TONE"
    const val ACTION_END_CALL = "ACTION_END_CALL"
    const val ACTION_HOLD_CALL = "ACTION_HOLD_CALL"
    const val ACTION_MUTE_CALL = "ACTION_MUTE_CALL"
    const val ACTION_ONGOING_CALL = "ACTION_ONGOING_CALL"
    const val ACTION_UNHOLD_CALL = "ACTION_UNHOLD_CALL"
    const val ACTION_UNMUTE_CALL = "ACTION_UNMUTE_CALL"
    const val ACTION_WAKE_APP = "ACTION_WAKE_APP"
    const val EXTRA_CALL_NUMBER = "EXTRA_CALL_NUMBER"
    const val EXTRA_CALL_UUID = "EXTRA_CALL_UUID"
    const val EXTRA_CALLER_NAME = "EXTRA_CALLER_NAME"
    const val FOREGROUND_SERVICE_TYPE_MICROPHONE = 128
}