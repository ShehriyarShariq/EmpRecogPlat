import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/core/ui/search_bar.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/featured_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeHome extends StatefulWidget {
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Color.fromRGBO(242, 242, 242, 1),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 1.1 * 0.18 * 0.215),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 1.1 * 0.18 * 0.215),
                  onTap: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (_) => NotificationList()));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius:
                        MediaQuery.of(context).size.width * 1.1 * 0.18 * 0.215,
                    child: Icon(
                      Icons.notifications_none,
                      color: Color.fromRGBO(27, 94, 121, 1),
                      size: MediaQuery.of(context).size.width *
                          0.87 *
                          0.18 *
                          0.37,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 2),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.125),
                    ),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.25 * 0.7,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shehriyar Shariq",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 30,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder: (context, index) => Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rank",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "41",
                            style: TextStyle(fontSize: 32),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SearchBarWidget(
              controller: TextEditingController(),
              hintText: "Search for Employee",
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Featured",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                Divider(),
              ],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Global Rankings',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FeaturedItemWidget(
                            position: '1st',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '2nd',
                                  isBig: false,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '3rd',
                                  isBig: false,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Categorical Rankings',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '1st',
                                  isBig: false,
                                  title: "Test",
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '1st',
                                  isBig: false,
                                  title: "Test",
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '1st',
                                  isBig: false,
                                  title: "Test",
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '1st',
                                  isBig: false,
                                  title: "Test",
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FeaturedItemWidget(
                                  position: '1st',
                                  isBig: false,
                                  title: "Test",
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Opacity(
                                  opacity: 0,
                                  child: FeaturedItemWidget(
                                    position: '1st',
                                    isBig: false,
                                    title: "Test",
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
