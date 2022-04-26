import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String? message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(message!),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
        ],
      );
    },
  );
}
