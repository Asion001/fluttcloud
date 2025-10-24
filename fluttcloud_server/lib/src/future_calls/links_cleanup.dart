import 'package:fluttcloud_server/src/future_calls/future_calls_list.dart';
import 'package:fluttcloud_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SharedLinksCleanupFutureCall extends FutureCall<SharedLink> {
  @override
  Future<void> invoke(Session session, SharedLink? object) async {
    final deletedLinks = await SharedLink.db.deleteWhere(
      session,
      where: (p0) => p0.deleteAfter.between(DateTime(1000), DateTime.now()),
    );

    session.log(
      'Deleted ${deletedLinks.length} expired shared links.',
      level: LogLevel.info,
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
