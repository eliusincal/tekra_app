import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog2 {
  final BuildContext context;
  ProgressDialog2(this.context);

  void show() {
    showCupertinoDialog(
        context: this.context,
        builder: (_) => Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            ));
  }

  void showWithText(text) {
    showCupertinoDialog(
        context: this.context,
        builder: (_) => Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            ));
  }

  void dismiss() {
    Navigator.pop(context);
  }
}
