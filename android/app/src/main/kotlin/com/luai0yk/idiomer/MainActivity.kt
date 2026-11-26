package com.luai0yk.idiomer

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val DOWNLOADS_CHANNEL = "com.luai0yk.idiomer/downloads"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DOWNLOADS_CHANNEL,
        ).setMethodCallHandler { call, result ->
            if (call.method == "saveImageToDownloads") {
                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")
                val subFolder = call.argument<String>("subFolder") ?: "Idiomer"

                if (bytes == null || fileName.isNullOrBlank()) {
                    result.error("INVALID_ARGS", "Missing bytes or fileName", null)
                    return@setMethodCallHandler
                }

                try {
                    val savedPath = saveToDownloadsFolder(bytes, fileName, subFolder)
                    result.success(savedPath)
                } catch (e: Exception) {
                    result.error("SAVE_FAILED", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveToDownloadsFolder(
        bytes: ByteArray,
        fileName: String,
        subFolder: String,
    ): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val relativePath = "${Environment.DIRECTORY_DOWNLOADS}/$subFolder"
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "image/png")
                put(MediaStore.Downloads.RELATIVE_PATH, relativePath)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }

            val resolver = applicationContext.contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Could not create MediaStore Downloads entry")

            try {
                resolver.openOutputStream(uri)?.use { out ->
                    out.write(bytes)
                    out.flush()
                } ?: throw IllegalStateException("Could not open MediaStore output stream")

                val completed = ContentValues().apply {
                    put(MediaStore.Downloads.IS_PENDING, 0)
                }
                resolver.update(uri, completed, null, null)
                return "$relativePath/$fileName"
            } catch (e: Exception) {
                resolver.delete(uri, null, null)
                throw e
            }
        } else {
            @Suppress("DEPRECATION")
            val downloadsDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            )
            val targetDir = File(downloadsDir, subFolder)
            if (!targetDir.exists()) {
                targetDir.mkdirs()
            }
            val targetFile = File(targetDir, fileName)
            targetFile.writeBytes(bytes)
            return targetFile.absolutePath
        }
    }
}
