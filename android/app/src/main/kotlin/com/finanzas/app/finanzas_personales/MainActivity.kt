package com.finanzas.app.finanzas_personales

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val widgetChannelName = "com.finanzas.app/widgets"

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidgets") {
                    refreshHomeWidgets()
                    result.success(true)
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
