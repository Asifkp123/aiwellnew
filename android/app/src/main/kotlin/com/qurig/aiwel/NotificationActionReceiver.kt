package com.qurig.aiwel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        android.util.Log.d("MedicineReminder", "Received intent: ${intent.action}, id=${intent.getStringExtra("id")}")
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "medicine_reminder_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !channelExists(notificationManager, channelId)) {
            val channel = NotificationChannel(
                    channelId,
                    "Medicine Reminders",
                    NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        when (intent.action) {
            "com.qurig.aiwel.NOTIFICATION" -> {
                val id = intent.getStringExtra("id") ?: return
                val medicine = intent.getStringExtra("medicine") ?: return
                val notificationId = intent.getIntExtra("notificationId", 0)

                // PendingIntent to open MainActivity when notification is clicked
                val contentIntent = PendingIntent.getActivity(
                        context,
                        id.hashCode(),
                        Intent(context, MainActivity::class.java),
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                // PendingIntent for "Mark as Taken" action
                val actionIntent = Intent(context, NotificationActionReceiver::class.java).apply {
                    action = "com.qurig.aiwel.MARK_TAKEN"
                    putExtra("id", id)
                    putExtra("notificationId", notificationId)
                }
                val actionPendingIntent = PendingIntent.getBroadcast(
                        context,
                        id.hashCode(),
                        actionIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                val notification = NotificationCompat.Builder(context, channelId)
                        .setContentTitle("Medicine Reminder")
                        .setContentText("Time to take $medicine")
                        .setSmallIcon(android.R.drawable.ic_dialog_info)
                        .setContentIntent(contentIntent) // Open app on click
                        .addAction(
                                NotificationCompat.Action.Builder(
                                        android.R.drawable.ic_menu_save,
                                        "Mark as Taken",
                                        actionPendingIntent
                                ).build()
                        )
                        .setAutoCancel(true)
                        .build()

                notificationManager.notify(notificationId, notification)
            }
            "com.qurig.aiwel.MARK_TAKEN" -> {
                val id = intent.getStringExtra("id") ?: return
                val notificationId = intent.getIntExtra("notificationId", 0)
                notificationManager.cancel(notificationId) // Clear the notification
                val flutterEngine = FlutterEngine(context)
                flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
                val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.qurig.aiwel/notifications")
                channel.invokeMethod("markMedicineTaken", mapOf("id" to id))
            }
        }
    }

    private fun channelExists(notificationManager: NotificationManager, channelId: String): Boolean {
        return notificationManager.getNotificationChannel(channelId) != null
    }
}