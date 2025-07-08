package com.qurig.aiwel

import android.content.Context
import androidx.annotation.NonNull
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.qurig.aiwel/secure_storage"
    private val PREFS_NAME = "SecurePrefs"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveTokens" -> {
                    val args = call.arguments as? Map<String, String>
                    if (args != null) {
                        try {
                            saveTokens(args)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("STORAGE_ERROR", "Failed to save tokens: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
                    }
                }
                "getToken" -> {
                    val key = call.argument<String>("key")
                    if (key != null) {
                        try {
                            val value = getToken(key)
                            result.success(value)
                        } catch (e: Exception) {
                            result.error("STORAGE_ERROR", "Failed to retrieve token: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid key", null)
                    }
                }
                "clearTokens" -> {
                    try {
                        clearTokens()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("STORAGE_ERROR", "Failed to clear tokens: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveTokens(args: Map<String, String>) {
        val masterKey = MasterKey.Builder(this)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()

        val sharedPreferences = EncryptedSharedPreferences.create(
                this,
                PREFS_NAME,
                masterKey,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        with(sharedPreferences.edit()) {
            args.forEach { (key, value) ->
                putString(key, value)
            }
            apply()
        }
    }

    private fun getToken(key: String): String? {
        val masterKey = MasterKey.Builder(this)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()

        val sharedPreferences = EncryptedSharedPreferences.create(
                this,
                PREFS_NAME,
                masterKey,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        return sharedPreferences.getString(key, null)
    }

    private fun clearTokens() {
        val masterKey = MasterKey.Builder(this)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()

        val sharedPreferences = EncryptedSharedPreferences.create(
                this,
                PREFS_NAME,
                masterKey,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        with(sharedPreferences.edit()) {
            clear()
            apply()
        }
    }
}