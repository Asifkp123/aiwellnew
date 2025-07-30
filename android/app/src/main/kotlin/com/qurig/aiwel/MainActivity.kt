package com.qurig.aiwel

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.qurig.aiwel/notifications"
    private val PERMISSION_REQUEST_CODE = 100
    private val PREFS_NAME = "MedicineReminderPrefs"
    private val KEY_INITIAL_SETUP_DONE = "initialSetupDone"

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        val sharedPreferences = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val initialSetupDone = sharedPreferences.getBoolean(KEY_INITIAL_SETUP_DONE, false)

        if (!initialSetupDone) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), PERMISSION_REQUEST_CODE)
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                if (!alarmManager.canScheduleExactAlarms()) {
                    startActivity(Intent(android.provider.Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM))
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val intent = Intent(android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = android.net.Uri.parse("package:$packageName")
                }
                startActivity(intent)
            }

            sharedPreferences.edit().putBoolean(KEY_INITIAL_SETUP_DONE, true).apply()
        } else {
            android.util.Log.d("MedicineReminder", "Initial setup already completed, skipping prompts")
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                android.util.Log.d("MedicineReminder", "Notification permission granted")
            } else {
                android.util.Log.d("MedicineReminder", "Notification permission denied")
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleNotification" -> {
                    val id = call.argument<String>("id")
                    val medicine = call.argument<String>("medicine")
                    val startDate = call.argument<String>("startDate")
                    val endDate = call.argument<String>("endDate")
                    val hour = call.argument<Int>("hour")
                    val minute = call.argument<Int>("minute")

                    if (id != null && medicine != null && startDate != null && endDate != null && hour != null && minute != null) {
                        scheduleNotification(id, medicine, startDate, endDate, hour, minute)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGS", "Missing arguments", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scheduleNotification(id: String, medicine: String, startDate: String, endDate: String, hour: Int, minute: Int) {
        android.util.Log.d("MedicineReminder", "Scheduling notification: id=$id, medicine=$medicine, startDate=$startDate, endDate=$endDate, hour=$hour, minute=$minute")
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val dateFormatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
        dateFormatter.timeZone = TimeZone.getTimeZone("Asia/Kolkata") // IST (UTC+5:30)
        val startCalendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata")).apply {
            time = dateFormatter.parse(startDate) ?: return
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val endCalendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata")).apply {
            time = dateFormatter.parse(endDate) ?: return
        }

        var currentTime = startCalendar.timeInMillis
        android.util.Log.d("MedicineReminder", "Start time: ${startCalendar.time}, End time: ${endCalendar.time}")

        while (currentTime <= endCalendar.timeInMillis) {
            android.util.Log.d("MedicineReminder", "Scheduling alarm for: $currentTime")
            val notificationIntent = Intent(this, NotificationActionReceiver::class.java).apply {
                action = "com.qurig.aiwel.NOTIFICATION"
                putExtra("id", id)
                putExtra("medicine", medicine)
                putExtra("notificationId", (id + currentTime.toString()).hashCode()) // Pass notification ID
            }
            val notificationPendingIntent = PendingIntent.getBroadcast(
                    this,
                    (id + currentTime.toString()).hashCode(),
                    notificationIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            if (currentTime >= System.currentTimeMillis()) {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, currentTime, notificationPendingIntent)
                android.util.Log.d("MedicineReminder", "Alarm set for: $currentTime")
            } else {
                android.util.Log.d("MedicineReminder", "Skipping past time: $currentTime")
            }

            currentTime += 24 * 60 * 60 * 1000 // Next day
        }
    }
}