import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class OfferAppliedAlert extends StatefulWidget {
  final String offerCode;
  final int discount;

  const OfferAppliedAlert({
    Key? key,
    required this.offerCode,
    required this.discount,
  }) : super(key: key);

  @override
  State<OfferAppliedAlert> createState() => _OfferAppliedAlertState();
}

class _OfferAppliedAlertState extends State<OfferAppliedAlert> {
  late final ConfettiController controller;
  @override
  void initState() {
    super.initState();
    controller = ConfettiController(
      duration: const Duration(milliseconds: 100),
    );
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 7.0,
            left: 20.0,
            bottom: 15.0,
            right: 15.0,
          ),
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: const Icon(Icons.close_rounded),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "\"${widget.offerCode}\" offer applied",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "₹${widget.discount} Savings With This Coupon",
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Yay!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 230,
        child: ConfettiWidget(
          confettiController: controller,
          emissionFrequency: 0.6,
          colors: [
            Colors.red,
            Colors.orange,
            Colors.purpleAccent,
            Colors.yellow
          ],
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 50,
        ),
      ),
    ]);
  }
}
