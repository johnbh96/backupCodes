package com.truenary.hamrocounter.dev

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val smsReceiver = object:EventChannel.StreamHandler,BroadcastReceiver(){
            var eventSink: EventChannel.EventSink? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            override fun onReceive(p0: Context?, p1: Intent?) {
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){
                    for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
                        var validSms = sms.displayMessageBody.contains(Regex("[0-9]{6}"))
                        var otpExists = sms.displayMessageBody.contains(Regex("(?:OTP)"))
                        if (validSms && otpExists){
                            eventSink?.success(sms.displayMessageBody)
                        }
                    }
                }
            }
        }
        registerReceiver(smsReceiver,IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger,"com.truenary.hamrocounter.dev.app/smsStream")
        .setStreamHandler(smsReceiver)
    }
}
