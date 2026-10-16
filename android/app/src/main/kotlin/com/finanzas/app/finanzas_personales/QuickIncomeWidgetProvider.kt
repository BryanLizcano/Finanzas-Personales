package com.finanzas.app.finanzas_personales

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class QuickIncomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_quick_income)

            views.setOnClickPendingIntent(
                R.id.btn_income_salary,
                createDeepLinkIntent(context, "income", "salary")
            )
            views.setOnClickPendingIntent(
                R.id.btn_income_business,
                createDeepLinkIntent(context, "income", "drinks_business")
            )
            views.setOnClickPendingIntent(
                R.id.btn_income_deliveries,
                createDeepLinkIntent(context, "income", "deliveries")
            )
            views.setOnClickPendingIntent(
                R.id.btn_income_other,
                createDeepLinkIntent(context, "income", "other_income")
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
