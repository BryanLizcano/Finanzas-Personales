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
                R.id.btn_income_quick,
                createDeepLinkIntent(context, "income", "salary", 201)
            )
            views.setOnClickPendingIntent(
                R.id.btn_expense_quick,
                createDeepLinkIntent(context, "expense", "food", 202)
            )

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun createDeepLinkIntent(
        context: Context,
        kind: String,
        cat: String,
        requestCode: Int
    ): PendingIntent {
        val uri = Uri.parse("finanzas://quick-add?kind=$kind&cat=$cat")
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
