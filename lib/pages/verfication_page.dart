import 'package:crud/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../Services/authentication_service.dart';
import '../constants.dart';
import 'Items/items_page.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _smsController = TextEditingController();
  verifyOTP(BuildContext context){
    try {
      Provider.of<AuthenticationService>(context, listen: false)
          .verifyOTP(_smsController.text.toString())
          .then((_) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>const ItemsPage()),(route) => false);
      }).catchError((e) {
        String errorMsg =
            'Cant authentiate you Right now, Try again later!';
        if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
          errorMsg = "Session expired, please resend OTP!";
        } else if (e
            .toString()
            .contains("ERROR_INVALID_VERIFICATION_CODE")) {
          errorMsg = "You have entered wrong OTP!";
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMsg)));
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Verify your phone',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Enter Code',
                  style: TextStyle(color: kBlue, fontSize: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: PinCodeTextField(
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      disabledColor: Colors.grey,
                      activeColor: Colors.grey,
                      selectedColor: Colors.grey,
                      inactiveColor: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  controller: _smsController,
                  appContext: context,
                  length: 6,
                  onChanged: (v) {}),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_smsController.text.length == 6) {
                      verifyOTP(context);
                    }
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kBlue),
                    maximumSize: MaterialStateProperty.all(const Size(150, 50)),
                    minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ))),
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
          ],
        ),
      ),
    );
  }
}
