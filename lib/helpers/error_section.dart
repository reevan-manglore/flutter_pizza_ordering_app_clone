import "package:flutter/material.dart";

class ErrorSection extends StatelessWidget {
  final String errMsg;
  final String? actionBtnText;
  final void Function()? actionBtnHandler;

  const ErrorSection({
    required this.errMsg,
    this.actionBtnText,
    this.actionBtnHandler,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("OopsThere was an error"),
        centerTitle: true,
        backgroundColor: Colors.red.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 85,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              errMsg,
              style: const TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            if (actionBtnHandler != null)
              ElevatedButton(
                onPressed: actionBtnHandler,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    shadowColor: Colors.red.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(250, 55)),
                child: Text(
                  actionBtnText ?? "Retry",
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              )
          ],
        ),
      ),
    );
  }
}
