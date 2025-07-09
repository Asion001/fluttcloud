import 'package:fluttcloud_server/src/future_calls/links_cleanup.dart';
import 'package:serverpod/serverpod.dart';

enum FutureCallsList {
  sharedLinkCleanup;

  FutureCall get futureCall => futureCallsListMap[this]!;
}

final Map<FutureCallsList, FutureCall> futureCallsListMap = {
  FutureCallsList.sharedLinkCleanup: SharedLinksCleanupFutureCall(),
};
