import 'package:flutter/material.dart';

void showMessage(BuildContext context,
    {required String message, required bool isSuccess}) {
  final SnackBar snackbar;
  //moi
  isSuccess
      ? snackbar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[200],
        )
      : snackbar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[200],
        );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

// ANCIENNE VERSION
// void showMessage(String message, bool isSuccess) {
//   final SnackBar snackbar;
//   moi
//   isSuccess
//       ? snackbar = SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green[200],
//         )
//       : snackbar = SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red[200],
//         );

//   ScaffoldMessenger.of(context).showSnackBar(snackbar);
// }