import 'package:fluttcloud_server/src/future_calls/future_calls_list.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SharedLinksCleanupFutureCall extends FutureCall<SharedLink> {
  @override
  Future<void> invoke(Session session, SharedLink? object) async {
    await SharedLink.db.deleteWhere(
      session,
      where: (p0) => p0.deleteAfter.between(DateTime(2000), DateTime.now()),
    );

    // Schedule next task
    await server.serverpod.futureCallWithDelay(
      FutureCallsList.sharedLinkCleanup.name,
      null,
      const Duration(minutes: 5),
    );

    await session.close();
  }
}
