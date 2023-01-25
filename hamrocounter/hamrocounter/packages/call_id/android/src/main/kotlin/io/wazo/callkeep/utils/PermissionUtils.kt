package io.package.call_id

import android.app.Activity

/** Helper module for dealing with dynamic permissions, introduced in Android M (API level 23).  */
object PermissionUtils {
    /**
     * Constants for internal fields in the <tt>Bundle</tt> exchanged between the activity requesting
     * the permissions and the auxiliary activity we spawn for this purpose.
     */
    private const val GRANT_RESULTS = "GRANT_RESULT"
    private const val PERMISSIONS = "PERMISSION"
    private const val REQUEST_CODE = "REQUEST_CODE"
    private const val RESULT_RECEIVER = "RESULT_RECEIVER"

    /** Incrementing counter for permission requests. Each request must have a unique numeric code.  */
    private var requestCode = 0
    private fun requestPermissions(
        activity: Activity, permissions: Array<String>, resultReceiver: ResultReceiver
    ) {
        // Ask the Context whether we have already been granted the requested
        // permissions.
        val size = permissions.size
        val grantResults = IntArray(size)
        var permissionsGranted = true
        for (i in 0 until size) {
            var grantResult: Int
            // No need to ask for permission on pre-Marshmallow
            grantResult =
                if (Build.VERSION.SDK_INT < VERSION_CODES.M) PackageManager.PERMISSION_GRANTED else activity.checkSelfPermission(
                    permissions[i]
                )
            grantResults[i] = grantResult
            if (grantResult != PackageManager.PERMISSION_GRANTED) {
                permissionsGranted = false
            }
        }

        // Obviously, if the requested permissions have already been granted,
        // there is nothing to ask the user about. On the other hand, if there
        // is no Activity or the runtime permissions are not supported, there is
        // no way to ask the user to grant us the denied permissions.
        val requestCode = ++requestCode
        if (permissionsGranted // Here we test for the target SDK version with which *the app*
            // was compiled. If we use Build.VERSION.SDK_INT that would give
            // us the API version of the device itself, not the version the
            // app was compiled for. When compiled for API level < 23 we
            // must still use old permissions model, regardless of the
            // Android version on the device.
            || Build.VERSION.SDK_INT < VERSION_CODES.M || activity.getApplicationInfo().targetSdkVersion < VERSION_CODES.M
        ) {
            send(resultReceiver, requestCode, permissions, grantResults)
            return
        }
        val args = Bundle()
        args.putInt(REQUEST_CODE, requestCode)
        args.putParcelable(RESULT_RECEIVER, resultReceiver)
        args.putStringArray(PERMISSIONS, permissions)
        val fragment = RequestPermissionsFragment()
        fragment.setArguments(args)
        val transaction: FragmentTransaction = activity
            .getFragmentManager()
            .beginTransaction()
            .add(fragment, fragment.getClass().getName() + "-" + requestCode)
        try {
            transaction.commit()
        } catch (ise: IllegalStateException) {
            // Context is a Plugin, just send result back.
            send(resultReceiver, requestCode, permissions, grantResults)
        }
    }

    fun requestPermissions(
        activity: Activity, permissions: Array<String>, callback: Callback
    ) {
        requestPermissions(
            activity,
            permissions,
            object : ResultReceiver(Handler(Looper.getMainLooper())) {
                @Override
                protected fun onReceiveResult(resultCode: Int, resultData: Bundle) {
                    callback.invoke(
                        resultData.getStringArray(PERMISSIONS),
                        resultData.getIntArray(GRANT_RESULTS)
                    )
                }
            })
    }

    private fun send(
        resultReceiver: ResultReceiver,
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        val resultData = Bundle()
        resultData.putStringArray(PERMISSIONS, permissions)
        resultData.putIntArray(GRANT_RESULTS, grantResults)
        resultReceiver.send(requestCode, resultData)
    }

    interface Callback {
        operator fun invoke(permissions: Array<String?>?, grantResults: IntArray?)
    }

    /**
     * Helper activity for requesting permissions. Android only allows requesting permissions from an
     * activity and the result is reported in the <tt>onRequestPermissionsResult</tt> method. Since
     * this package is a library we create an auxiliary activity and communicate back the results
     * using a <tt>ResultReceiver</tt>.
     */
    @RequiresApi(api = VERSION_CODES.M)
    class RequestPermissionsFragment : Fragment() {
        private fun checkSelfPermissions(requestPermissions: Boolean) {
            // Figure out which of the requested permissions are actually denied
            // because we do not want to ask about the granted permissions
            // (which Android supports).
            val args: Bundle = getArguments()
            val permissions: Array<String> = args.getStringArray(PERMISSIONS)
            val size = permissions.size
            val activity: Activity = getActivity()
            val grantResults = IntArray(size)
            val deniedPermissions: ArrayList<String> = ArrayList()
            for (i in 0 until size) {
                val permission = permissions[i]
                var grantResult: Int
                // No need to ask for permission on pre-Marshmallow
                grantResult =
                    if (Build.VERSION.SDK_INT < VERSION_CODES.M) PackageManager.PERMISSION_GRANTED else activity.checkSelfPermission(
                        permission
                    )
                grantResults[i] = grantResult
                if (grantResult != PackageManager.PERMISSION_GRANTED) {
                    deniedPermissions.add(permission)
                }
            }
            val requestCode: Int = args.getInt(REQUEST_CODE, 0)
            if (deniedPermissions.isEmpty() || !requestPermissions) {
                // All permissions have already been granted or we cannot ask
                // the user about the denied ones.
                finish()
                send(
                    args.getParcelable(RESULT_RECEIVER) as ResultReceiver,
                    requestCode,
                    permissions,
                    grantResults
                )
            } else {
                // Ask the user about the denied permissions.
                requestPermissions(
                    deniedPermissions.toArray(arrayOfNulls<String>(deniedPermissions.size())),
                    requestCode
                )
            }
        }

        private fun finish() {
            val activity: Activity = getActivity()
            if (activity != null) {
                activity.getFragmentManager().beginTransaction().remove(this)
                    .commitAllowingStateLoss()
            }
        }

        @Override
        fun onRequestPermissionsResult(
            requestCode: Int, @NonNull permissions: Array<String?>, @NonNull grantResults: IntArray
        ) {
            val args: Bundle = getArguments()
            if (args.getInt(REQUEST_CODE, 0) !== requestCode) {
                return
            }

            // XXX The super's documentation says: It is possible that the
            // permissions request interaction with the user is interrupted. In
            // this case you will receive empty permissions and results arrays
            // which should be treated as a cancellation.
            if (permissions.size == 0 || grantResults.size == 0) {
                // The getUserMedia algorithm does not define a way to cancel
                // the invocation so we have to redo the permission request.
                finish()
                requestPermissions(
                    getActivity(),
                    args.getStringArray(PERMISSIONS),
                    args.getParcelable(RESULT_RECEIVER) as ResultReceiver
                )
            } else {
                // We did not ask for all requested permissions, just the denied
                // ones. But when we send the result, we have to answer about
                // all requested permissions.
                checkSelfPermissions( /* requestPermissions */false)
            }
        }

        @Override
        fun onResume() {
            super.onResume()
            checkSelfPermissions( /* requestPermissions */true)
        }
    }
}