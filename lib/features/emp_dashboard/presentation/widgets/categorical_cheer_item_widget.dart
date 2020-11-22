import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class CategoricalCheerItemWidget extends StatefulWidget {
  final String trait, traitCount;
  final bool isSelf;
  bool isDisabled;
  final Function func;

  CategoricalCheerItemWidget(
      {Key key,
      this.trait,
      this.traitCount,
      this.isDisabled,
      this.func,
      this.isSelf})
      : super(key: key);

  @override
  _CategoricalCheerItemWidgetState createState() =>
      _CategoricalCheerItemWidgetState();
}

class _CategoricalCheerItemWidgetState
    extends State<CategoricalCheerItemWidget> {
  EmpDashboardBloc _bloc;

  @override
  void initState() {
    _bloc = sl<EmpDashboardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _bloc,
      builder: (context, state) {
        if (state is UpdateCheerIcon) {
          widget.isDisabled = true;
        }

        return _buildBody(context);
      },
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  Constant.TRAIT_LABELS[widget.trait],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    right: widget.isSelf
                        ? BorderSide.none
                        : BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                  ),
                ),
                child: Center(
                  child: Text(widget.traitCount,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            if (!widget.isSelf) ...[
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.isDisabled) {
                        _bloc.add(UpdateCheerIconEvent());
                        widget.func();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.isDisabled
                              ? Colors.white
                              : Theme.of(context).primaryColor.withOpacity(0.8),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: widget.isDisabled
                            ? Colors.transparent
                            : Colors.white,
                      ),
                      child: Icon(
                        widget.isDisabled
                            ? Icons.do_not_disturb_alt
                            : Icons.exposure_plus_1,
                        color: widget.isDisabled
                            ? Colors.white
                            : Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
