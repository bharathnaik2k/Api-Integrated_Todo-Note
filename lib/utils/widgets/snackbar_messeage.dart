import 'package:flutter/material.dart';


dynamic snackBarMesseage(String snackbartext, Color snackbarcolor,BuildContext context) {
  SnackBar snackBar = SnackBar(
    content: Text(snackbartext),
    backgroundColor: snackbarcolor,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
