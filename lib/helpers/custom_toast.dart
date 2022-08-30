import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  final BuildContext context;
  final FToast _ftoast = FToast();

  CustomToast(this.context) {
    _ftoast.init(context);
  }

  void showToast(String message) {
    _ftoast.showToast(
      child: _CustomToastLayout(message),
    );
  }

  void hideCurrentToast() {
    _ftoast.removeCustomToast();
  }
}

class _CustomToastLayout extends StatelessWidget {
  final String msg;
  const _CustomToastLayout(this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        msg,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
