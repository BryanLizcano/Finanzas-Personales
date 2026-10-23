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
                R.id.btn_quick_entry,
                createDeepLinkIntent(context, "expense", "food", 101)
            )
            views.setOnClickPendingIntent(
                R.id.btn_new_transfer,
                createDeepLinkIntent(context, "transfer", "", 102)
            )
            views.setOnClickPendingIntent(
                R.id.btn_new_income,
                createDeepLinkIntent(context, "income", "salary", 103)
            )
            views.setOnClickPendingIntent(
                R.id.btn_new_expense,
                createDeepLinkIntent(context, "expense", "other_expense", 104)
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
        val uriString = if (cat.isNotEmpty()) {
            "finanzas://quick-add?kind=$kind&cat=$cat"
        } else {
            "finanzas://quick-add?kind=$kind"
        }
        val uri = Uri.parse(uriString)
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
