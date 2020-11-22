import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isDisabled;
  final Function func;

  const SearchBarWidget(
      {Key key,
      this.controller,
      this.hintText,
      this.isDisabled = false,
      this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? func : () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 30) -
                (MediaQuery.of(context).size.width * 1.1 * 0.18 * 0.43) -
                30,
            height: (MediaQuery.of(context).size.width - 15) * 0.13,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    (MediaQuery.of(context).size.width - 15) * 0.13 * 0.05),
                border:
                    Border.all(width: 1, color: Colors.black.withOpacity(0.2))),
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.grey.withOpacity(0.7),
                              size: constraints.maxHeight * 0.625,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextField(
                                enabled: !isDisabled,
                                controller: controller,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: hintText,
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.withOpacity(0.6)),
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    fillColor: Colors.amber),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
