package com.finanzas.app.finanzas_personales

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
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
        val allPrefs = prefs.all
        val safeAvail = (allPrefs["flutter.widget_safe_available"] as? Number)?.toLong() ?: 0L
        val monthlyBal = (allPrefs["flutter.widget_monthly_balance"] as? Number)?.toLong() ?: 0L

        val formatter = NumberFormat.getNumberInstance(Locale("es", "CO"))

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_summary)

            views.setTextViewText(R.id.tv_safe_available, "$ " + formatter.format(safeAvail))
            views.setTextViewText(R.id.tv_monthly_balance, "Balance mes: $ " + formatter.format(monthlyBal))

            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launchIntent != null) {
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.summary_header_container, pendingIntent)
            }

            views.setOnClickPendingIntent(
                R.id.btn_summary_income,
                createDeepLinkIntent(context, "income", 301)
            )
            views.setOnClickPendingIntent(
                R.id.btn_summary_expense,
                createDeepLinkIntent(context, "expense", 302)
            )

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun createDeepLinkIntent(
        context: Context,
        kind: String,
        requestCode: Int
    ): PendingIntent {
        val uri = Uri.parse("finanzas://quick-add?kind=$kind")
        val intent = Intent(Intent.ACTION_VIEW, uri, context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
