import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/leaderboard_ranker_model.dart';
import 'package:flutter/material.dart';

class LeaderboardRankersWidget extends StatelessWidget {
  final LeaderboardRankerModel ranker;
  final bool isBig;
  final String position;
  final bool isLocked;

  const LeaderboardRankersWidget(
      {Key key,
      this.isBig = false,
      this.position,
      this.ranker,
      this.isLocked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Opacity(
              opacity: isLocked ? 0.4 : 1,
              child: SizedBox(
                width: constraints.maxWidth * 0.5,
                child: Text(
                  ranker != null
                      ? FirebaseInit.auth.currentUser.uid == ranker.empID
                          ? "You"
                          : ranker.name
                      : "None",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: isBig ? 17 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Stack(
                children: [
                  Opacity(
                    opacity: isLocked ? 0.4 : 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: constraints.maxWidth *
                              (isBig ? 0.18 : 0.23) *
                              0.25),
                      child: Container(
                        width: constraints.maxWidth * (isBig ? 0.18 : 0.23) * 2,
                        height:
                            constraints.maxWidth * (isBig ? 0.18 : 0.23) * 2,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: ranker?.imageURL != null
                              ? Border.all(width: 0)
                              : Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 2),
                          borderRadius: BorderRadius.circular(
                            constraints.maxWidth * (isBig ? 0.18 : 0.23),
                          ),
                        ),
                        child: ranker?.imageURL != null
                            ? FadeInImage(
                                image: NetworkImage(ranker.imageURL),
                                placeholder: AssetImage("imgs/user.png"),
                                fit: BoxFit.cover)
                            : Image.asset("imgs/user.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: isLocked ? 0.5 : 1,
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
                  ),
                  if (isLocked) ...[
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Icon(
                          Icons.lock,
                          size:
                              constraints.maxWidth * (isBig ? 0.4 : 0.56) * 0.5,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
