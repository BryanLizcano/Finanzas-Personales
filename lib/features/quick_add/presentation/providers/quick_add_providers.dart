import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/widget_data_service_impl.dart';
import '../../domain/services/widget_data_service.dart';
import '../../domain/usecases/parse_quick_add_link.dart';
import '../../domain/usecases/update_widget_data.dart';

final widgetDataServiceProvider = Provider<WidgetDataService>((ref) {
  return const SharedPreferencesWidgetDataService();
});

final parseQuickAddLinkUseCaseProvider = Provider<ParseQuickAddLink>((ref) {
  return const ParseQuickAddLink();
});

final updateWidgetDataUseCaseProvider = Provider<UpdateWidgetData>((ref) {
  return UpdateWidgetData(ref.watch(widgetDataServiceProvider));
});
