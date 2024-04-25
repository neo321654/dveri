import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(
  Config(
    'customCacheManager',
    stalePeriod: const Duration(days: 14),
    maxNrOfCacheObjects: 400
  )
);