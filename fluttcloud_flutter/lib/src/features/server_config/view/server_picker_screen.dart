import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ServerPickerScreen extends StatefulWidget {
  const ServerPickerScreen({super.key, this.onServerUrlChanged});

  final VoidCallback? onServerUrlChanged;

  @override
  State<ServerPickerScreen> createState() => _ServerPickerScreenState();
}

class _ServerPickerScreenState extends State<ServerPickerScreen> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: getIt<ServerConfigController>().serverUrl,
    );
  }

  void _saveServerUrl() {
    final url = _controller.text.trim();
    final uri = Uri.tryParse(url);

    if (uri == null) {
      setState(() {
        _errorText = LocaleKeys.server_picker_screen_url_invalid.tr();
      });
      return;
    }

    getIt<ServerConfigController>().setServerUrl(url);
    ToastController.I.show(
      LocaleKeys.server_picker_screen_url_saved.tr(args: [url]),
      type: ToastType.success,
    );
    widget.onServerUrlChanged?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaxSizeContainer(
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.server_picker_screen_title.tr())),
        body: Container(
          padding: 16.all,
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: LocaleKeys.server_picker_screen_server_url.tr(),
                  hintText: 'https://your-api-server.com',
                  errorText: _errorText,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                autofillHints: const [AutofillHints.url],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveServerUrl,
                child: Text(LocaleKeys.save.tr()),
              ),
            ],
          ),
        ).center(),
      ),
    );
  }
}
