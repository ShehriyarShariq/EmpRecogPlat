import 'package:flutter/material.dart';

class FeaturedItemWidget extends StatelessWidget {
  final bool isBig;
  final String title, position;

  const FeaturedItemWidget(
      {Key key, this.position, this.isBig = true, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 5),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        if (isBig) ...[
                          Positioned(
                            bottom: 0,
                            child: Column(
                              children: [
                                Container(
                                  width: constraints.maxWidth,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "Shehriyar Shariq",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      Text(
                                        "CTO",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: constraints.maxWidth * 0.25,
                    height: constraints.maxWidth * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                      borderRadius:
                          BorderRadius.circular(constraints.maxWidth * 0.15),
                    ),
                    padding: EdgeInsets.all(isBig ? 25 : 10),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        position,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
        if (!isBig) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Shehriyar Shariq Shariq Shariq",
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.8)),
                  ),
                ),
                Text(
                  "CTO",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ],
    );
  }
}
