import 'dart:io';

import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:flutter/material.dart';

class SelectedProfileImageDialog extends StatefulWidget {
  final File selectedImage;

  const SelectedProfileImageDialog({Key key, this.selectedImage})
      : super(key: key);

  @override
  _SelectedProfileImageDialogState createState() =>
      _SelectedProfileImageDialogState();
}

class _SelectedProfileImageDialogState
    extends State<SelectedProfileImageDialog> {
  EmpDashboardBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = sl<EmpDashboardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Profile Image",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: CircleAvatar(
                            radius: (MediaQuery.of(context).size.width *
                                    0.9 *
                                    0.35) +
                                2,
                            backgroundColor: Colors.black.withOpacity(0.4),
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.9 * 0.7,
                              height:
                                  MediaQuery.of(context).size.width * 0.9 * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.9 *
                                        0.35),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.file(
                                widget.selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
