import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseGeolocationProviderDialog extends StatelessWidget {
  final List<String> supportedGeolocationProviders;
  final String currentGeolocationProvider;
  final Function(String name) onSet;

  const ChooseGeolocationProviderDialog(
      {super.key,
      required this.supportedGeolocationProviders,
      required this.currentGeolocationProvider,
      required this.onSet});

  @override
  Widget build(BuildContext context) {
    closeDialog() => context.pop();

    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: supportedGeolocationProviders.length,
          itemBuilder: (context, index) {
            final geoProvider = supportedGeolocationProviders[index];
            final isSelected = geoProvider == currentGeolocationProvider;

            return ListTile(
                title: Text(geoProvider),
                trailing: isSelected ? Icon(CupertinoIcons.check_mark) : null,
                selected: isSelected,
                onTap: () {
                  onSet(geoProvider);
                  closeDialog();
                });
          },
        ),
      ),
    );
  }
}
