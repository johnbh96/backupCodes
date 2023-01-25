package io.package.call_id

import io.package.call_id.ConstraintsMap
import io.package.call_id.PermissionUtils
import io.package.call_id.PermissionUtils.RequestPermissionsFragment
import io.package.call_id.ConstraintsArray
import io.package.call_id.VoiceConnection
import io.package.call_id.VoiceConnectionService
import com.package.call_id.FlutterCallkeepPlugin

interface Callback {
    operator fun invoke(vararg args: Object?)
}