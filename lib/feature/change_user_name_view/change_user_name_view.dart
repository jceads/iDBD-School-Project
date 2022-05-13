import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../../product/utils/validator/validator.dart';

import '../../core/constants/border_radius.dart';

class ChangeUserName extends StatefulWidget {
  const ChangeUserName({Key? key}) : super(key: key);

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> changeName() async {
    if (_controller.text == "") return;

    await FirebaseAuth.instance.currentUser?.updateDisplayName(_controller.text);
    _controller.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Change User Name", style: Theme.of(context).textTheme.headline5),
        ),
        body: Padding(
          padding: context.paddingMedium,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controller,
                  validator: (s) {
                    if (Validator().validateString(s)) {
                      return null;
                    } else {
                      return "Please type anything";
                    }
                  },
                  decoration:
                      InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadiusConst.low)),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.05),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: context.horizontalPaddingHigh,
                        child: ElevatedButton(
                            onPressed: changeName,
                            child: Text(
                              "Apply",
                              style: Theme.of(context).textTheme.button,
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
