import 'package:flutter/material.dart';

class LeaderboardRankersWidget extends StatelessWidget {
  final bool isBig;
  final String position;

  const LeaderboardRankersWidget({Key key, this.isBig = false, this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.5,
              child: Text(
                "Shehriyar Shariq",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: isBig ? 17 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: constraints.maxWidth *
                            (isBig ? 0.18 : 0.23) *
                            0.25),
                    child: Container(
                      width: constraints.maxWidth * (isBig ? 0.18 : 0.23) * 2,
                      height: constraints.maxWidth * (isBig ? 0.18 : 0.23) * 2,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 2),
                        borderRadius: BorderRadius.circular(
                          constraints.maxWidth * (isBig ? 0.18 : 0.23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: constraints.maxWidth * (isBig ? 0.18 : 0.23),
                        height: constraints.maxWidth * (isBig ? 0.18 : 0.23),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black.withOpacity(0.2), width: 2),
                          borderRadius: BorderRadius.circular(
                              constraints.maxWidth *
                                  (isBig ? 0.18 : 0.23) *
                                  0.5),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(child: Text(position)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
