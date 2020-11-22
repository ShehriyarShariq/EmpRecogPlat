import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_search_repository.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeSearch extends SearchDelegate {
  EmpDashboardBloc _bloc = sl<EmpDashboardBloc>();

  List<EmployeeModel> queriedEmployees = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _bloc.add(LoadQueriedEmployees(
        func: () => sl<EmployeeSearchRepository>().getQueriedEmployees(query)));
    return BlocBuilder(
      cubit: _bloc,
      builder: (context, state) {
        if (state is Searching || state is Initial || state is Error) {
          return LoadingWidget();
        } else if (state is Searched) {
          queriedEmployees = state.queriedEmployees;
        }

        return Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: queriedEmployees
                        .map<Widget>((employee) => GestureDetector(
                              onTap: () {
                                close(context, employee.uid);
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  // vertical: 15,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          employee.name,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
