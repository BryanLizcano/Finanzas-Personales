package com.finanzas.app.finanzas_personales

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val widgetChannelName = "com.finanzas.app/widgets"
    private val installerChannelName = "com.finanzas.app/installer"
    private var widgetChannel: MethodChannel? = null
    private var pendingDeepLink: String? = null

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val dataStr = intent.dataString
        if (!dataStr.isNullOrEmpty() && dataStr.startsWith("finanzas://")) {
            pendingDeepLink = dataStr
            widgetChannel?.invokeMethod("onWidgetDeepLink", dataStr)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val initialDataStr = intent?.dataString
        if (!initialDataStr.isNullOrEmpty() && initialDataStr.startsWith("finanzas://")) {
            pendingDeepLink = initialDataStr
        }

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannelName)
        widgetChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidgets" -> {
                    refreshHomeWidgets()
                    result.success(true)
                }
                "consumeInitialDeepLink" -> {
                    val link = pendingDeepLink
                    pendingDeepLink = null
                    result.success(link)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, installerChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "installApk") {
                    val filePath = call.argument<String>("filePath")
                    if (filePath.isNullOrEmpty()) {
                        result.error("INVALID_PATH", "Ruta de APK no especificada", null)
                        return@setMethodCallHandler
                    }
                    val file = File(filePath)
                    if (!file.exists()) {
                        result.error("FILE_NOT_FOUND", "El archivo APK no existe en $filePath", null)
                        return@setMethodCallHandler
                    }

                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                            !packageManager.canRequestPackageInstalls()
                        ) {
                            val permIntent = Intent(
                                android.provider.Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                Uri.parse("package:${applicationContext.packageName}")
                            ).apply {
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(permIntent)
                            result.success(true)
                            return@setMethodCallHandler
                        }

                        val apkUri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            FileProvider.getUriForFile(
                                applicationContext,
                                "${applicationContext.packageName}.fileprovider",
                                file
                            )
                        } else {
                            Uri.fromFile(file)
                        }

                        val installIntent = Intent(Intent.ACTION_VIEW).apply {
                            setDataAndType(apkUri, "application/vnd.android.package-archive")
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }
                        startActivity(installIntent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INSTALL_ERROR", e.localizedMessage, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun refreshHomeWidgets() {
        val manager = AppWidgetManager.getInstance(applicationContext)
        val providers = arrayOf(
            SummaryWidgetProvider::class.java,
            QuickExpenseWidgetProvider::class.java,
            QuickIncomeWidgetProvider::class.java
        )
        for (providerClass in providers) {
            val component = ComponentName(applicationContext, providerClass)
            val ids = manager.getAppWidgetIds(component)
            if (ids != null && ids.isNotEmpty()) {
                val updateIntent = Intent(applicationContext, providerClass).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                }
                applicationContext.sendBroadcast(updateIntent)
            }
        }
    }
}
