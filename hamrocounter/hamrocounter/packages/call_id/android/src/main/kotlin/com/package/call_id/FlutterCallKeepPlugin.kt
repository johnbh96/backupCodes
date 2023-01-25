package com.package.call_id

import android.app.Activity

/** FlutterCallkeepPlugin  */
class FlutterCallkeepPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null
    private var callKeep: CallKeepModule? = null
    private fun setActivity(@NonNull activity: Activity) {
        callKeep.setActivity(activity)
    }

    private fun startListening(context: Context, messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, "FlutterCallKeep.Method")
        channel.setMethodCallHandler(this)
        callKeep = CallKeepModule(context, messenger)
    }

    private fun stopListening() {
        channel.setMethodCallHandler(null)
        channel = null
        callKeep.dispose()
        callKeep = null
    }

    @Override
    fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        startListening(
            flutterPluginBinding.getApplicationContext(),
            flutterPluginBinding.getBinaryMessenger()
        )
    }

    @Override
    fun onMethodCall(@NonNull call: MethodCall?, @NonNull result: Result) {
        if (!callKeep.handleMethodCall(call, result)) {
            result.notImplemented()
        }
    }

    @Override
    fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding?) {
        stopListening()
    }

    @Override
    fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
        callKeep.setActivity(binding.getActivity())
    }

    @Override
    fun onDetachedFromActivityForConfigChanges() {
        callKeep.setActivity(null)
    }

    @Override
    fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {
        callKeep.setActivity(binding.getActivity())
    }

    @Override
    fun onDetachedFromActivity() {
        callKeep.setActivity(null)
    }

    companion object {
        /**
         * Plugin registration.
         */
        fun registerWith(registrar: Registrar) {
            val plugin = FlutterCallkeepPlugin()
            plugin.startListening(registrar.context(), registrar.messenger())
            if (registrar.activeContext() is Activity) {
                plugin.setActivity(registrar.activeContext() as Activity)
            }
            registrar.addViewDestroyListener { view ->
                plugin.stopListening()
                false
            }
        }
    }
}