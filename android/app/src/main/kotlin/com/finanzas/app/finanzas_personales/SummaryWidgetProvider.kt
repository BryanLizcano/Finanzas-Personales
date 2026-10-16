package com.finanzas.app.finanzas_personales

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.text.NumberFormat
import java.util.Locale

class SummaryWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val safeAvail = prefs.getLong("flutter.widget_safe_available", 0L)
        val monthlyBal = prefs.getLong("flutter.widget_monthly_balance", 0L)

        val formatter = NumberFormat.getNumberInstance(Locale("es", "CO"))

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_summary)

            views.setTextViewText(R.id.tv_safe_available, "$ " + formatter.format(safeAvail))
            views.setTextViewText(R.id.tv_monthly_balance, "$ " + formatter.format(monthlyBal))

            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launchIntent != null) {
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.tv_safe_available, pendingIntent)
                views.setOnClickPendingIntent(R.id.tv_monthly_balance, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
