import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:flutter/material.dart';

class FeaturedItemWidget extends StatelessWidget {
  final bool isBig;
  final String title, position;
  final EmployeeModel employee;

  const FeaturedItemWidget(
      {Key key, this.isBig = true, this.title, this.employee, this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
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
                    elevation: employee?.imageURL != null ? 0 : 1,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        if (isBig) ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  employee?.imageURL != null ? 0 : 2),
                              color: employee?.imageURL != null
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(0.05),
                            ),
                            clipBehavior: Clip.hardEdge,
                            alignment: Alignment.center,
                            child: employee?.imageURL != null
                                ? OverflowBox(
                                    minWidth: 0,
                                    minHeight: 0,
                                    maxHeight: double.infinity,
                                    child: Image.network(
                                      employee.imageURL,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            30) *
                                        0.5,
                                    height: (MediaQuery.of(context).size.width -
                                            30) *
                                        0.5,
                                    child: Image.asset("imgs/user.png")),
                          ),
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
                                          employee.name,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      Text(
                                        employee.designation,
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
                        ] else ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: employee?.imageURL != null
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(0.05),
                            ),
                            clipBehavior: Clip.hardEdge,
                            alignment: Alignment.center,
                            child: employee?.imageURL != null
                                ? OverflowBox(
                                    minWidth: 0,
                                    minHeight: 0,
                                    maxHeight: double.infinity,
                                    child: Image.network(
                                      employee.imageURL,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            30) *
                                        0.45 *
                                        0.3,
                                    height: (MediaQuery.of(context).size.width -
                                            30) *
                                        0.45 *
                                        0.3,
                                    child: Image.asset("imgs/user.png")),
                          ),
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
                    employee.name,
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.8)),
                  ),
                ),
                Text(
                  employee.designation,
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
