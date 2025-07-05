import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeTabsScreen extends WatchingWidget {
  const HomeTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<FileListController>();
    final canPop = watchPropertyValue(
      (FileListController value) => value.currentPath != '/',
    );

    return Scaffold(
      body: MaxSizeContainer(
        child: PopScope(
          canPop: canPop,
          onPopInvokedWithResult: (_, _) async {
            if (controller.currentPath != '/') {
              final path = controller.currentPath
                  .split('/')
                  .sublist(0, controller.currentPath.split('/').length - 1)
                  .join('/');
              await controller.fetchFiles(path);
              return;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: const ProfileBtn(),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(42),
                child: FilesBar(),
              ),
            ),
            body: const FileList(),
          ),
        ),
      ),
    );
  }
}
