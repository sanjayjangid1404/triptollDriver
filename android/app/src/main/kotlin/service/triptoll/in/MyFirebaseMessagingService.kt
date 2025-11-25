package service.triptoll.`in`

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private var mediaPlayer: MediaPlayer? = null

    companion object {
        private const val CHANNEL_ID = "triptoll_channel"
        private const val CHANNEL_NAME = "TripToll Notifications"
        private const val CHANNEL_DESCRIPTION = "Notifications for new bookings"
        private const val NOTIFICATION_ID = 100
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d("FCM", "Message received: ${remoteMessage.data}")

        // Check if message contains both notification and data payload
        if (remoteMessage.notification != null) {
            Log.d("FCM", "Message Notification Body: ${remoteMessage.notification?.body}")
        }

        // Check for new_booking type
        if (remoteMessage.data["type"] == "new_booking") {
            // Show notification
            sendNotification(remoteMessage)

            // Play ringtone - only works when app is in foreground
            playRingtone()
        }
    }

    private fun sendNotification(remoteMessage: RemoteMessage) {
        // Create an explicit intent for an Activity in your app
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("notification_data", remoteMessage.data.toString())
        }

        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )

        // Get custom sound from raw resources or use default
        val soundUri = Uri.parse("android.resource://" + packageName + "/" + R.raw.booking)

        val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(remoteMessage.data["title"] ?: remoteMessage.notification?.title ?: "New Booking")
            .setContentText(remoteMessage.data["message"] ?: remoteMessage.notification?.body ?: "You have a new booking request")
            .setAutoCancel(true)
            .setSound(soundUri) // This will play sound even when app is in background
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Get custom sound from raw resources
            val soundUri = Uri.parse("android.resource://" + packageName + "/" + R.raw.booking)

            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = CHANNEL_DESCRIPTION
                setShowBadge(true)
                setSound(soundUri, null)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun playRingtone() {
        try {
            // This will only play when app is in foreground
            mediaPlayer?.release()

            mediaPlayer = MediaPlayer.create(this, R.raw.booking).apply {
                setOnCompletionListener {
                    it.release()
                    mediaPlayer = null
                }
                start()
            }

            if (mediaPlayer == null) {
                Log.e("FCM", "Custom ringtone not found")
            }
        } catch (e: Exception) {
            Log.e("FCM", "Error playing ringtone: ${e.message}")
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "New token: $token")
        // Send this token to your server
    }

    override fun onDestroy() {
        mediaPlayer?.release()
        super.onDestroy()
    }
}