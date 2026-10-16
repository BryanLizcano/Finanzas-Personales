package com.finanzas.app.finanzas_personales

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class QuickExpenseWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_quick_expense)

            views.setOnClickPendingIntent(
                R.id.btn_expense_food,
                createDeepLinkIntent(context, "expense", "food")
            )
            views.setOnClickPendingIntent(
                R.id.btn_expense_transport,
                createDeepLinkIntent(context, "expense", "transport")
            )
            views.setOnClickPendingIntent(
                R.id.btn_expense_fuel,
                createDeepLinkIntent(context, "expense", "fuel")
            )
            views.setOnClickPendingIntent(
                R.id.btn_expense_other,
                createDeepLinkIntent(context, "expense", "other_expense")
            )

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun createDeepLinkIntent(context: Context, kind: String, cat: String): PendingIntent {
        val uri = Uri.parse("finanzas://quick-add?kind=$kind&cat=$cat")
        val intent = Intent(Intent.ACTION_VIEW, uri).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(
            context,
            cat.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
