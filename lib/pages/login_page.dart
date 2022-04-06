import 'package:crud/pages/verfication_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/constants.dart';
import '../Services/authentication_service.dart';

final TextEditingController phoneController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  verifyPhone(BuildContext context) {
    try {
      Provider.of<AuthenticationService>(context, listen: false)
          .verifyPhone('+91', phoneController.text)
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const VerificationPage()));
      }).catchError((e) {
        String errorMsg = 'Cant Authenticate you, Try Again Later';
        if (e.toString().contains(
            'We have blocked all requests from this device due to unusual activity. Try again later.')) {
          errorMsg = 'Please wait as you have used limited number request';
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
            const Text('Continue with Phone'),
            InputBar(
                phoneController: phoneController,
                preicon: Icons.local_phone_outlined,
                hint: 'Mobile Number'),
            ElevatedButton(
                onPressed: () {
                  print(phoneController.text);
                  if (_formKey.currentState!.validate()) {
                    verifyPhone(context);
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
                  'CONTINUE',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}

class InputBar extends StatelessWidget {
  const InputBar({
    Key? key,
    required this.phoneController,
    required this.preicon,
    required this.hint,
  }) : super(key: key);
  final IconData preicon;
  final String hint;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: phoneController,
        decoration: InputDecoration(
            labelText: hint,
            filled: true,
            fillColor: kLightBlue,
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: 'Input (+91)',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
            prefixIcon: Icon(
              preicon,
              color: Colors.black,
            )),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please Fill';
          }
          return null;
        },
      ),
    );
  }
}
