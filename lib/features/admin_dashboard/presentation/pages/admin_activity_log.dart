import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/features/credentials/presentation/pages/sign_in.dart';
import 'package:flutter/material.dart';

class AdminActivityLog extends StatefulWidget {
  @override
  _AdminActivityLogState createState() => _AdminActivityLogState();
}

class _AdminActivityLogState extends State<AdminActivityLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignInBodyWidget()));
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Color.fromRGBO(27, 94, 121, 1),
                          size: MediaQuery.of(context).size.width *
                              0.87 *
                              0.18 *
                              0.37,
                        ),
                        Text(
                          "LogOut",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(27, 94, 121, 1),
                          ),
                        )
                      ],
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
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Greetings,",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Shehriyar Shariq",
                            style: TextStyle(fontSize: 18),
                          ),
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
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Employee Activity Log",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => _buildLogItem(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.06),
                    ),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.12 * 0.7,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Shehriyar Shariq",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6), fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                indent: 10 + MediaQuery.of(context).size.width * 0.12,
                endIndent: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 2,
                      bottom: 8,
                      left: 10 + MediaQuery.of(context).size.width * 0.12),
                  child: Text(
                    "Cheered for Emp#24 - Shehriyar",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
