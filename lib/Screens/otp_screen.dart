import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:video_downloader/Screens/phone_screen.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late TextEditingController textEditingController1;

  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String comingSms;
    try {
      comingSms = (await AltSmsAutofill().listenForSms)!;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms;
      print("====>Message: ${_comingSms}");
      print("${_comingSms[32]}");
      textEditingController1.text = _comingSms[32] +
          _comingSms[33] +
          _comingSms[34] +
          _comingSms[35] +
          _comingSms[36] +
          _comingSms[
              37]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  void initState() {
    textEditingController1 = TextEditingController();
    initSmsListener();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = '';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Phone Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'We need to register your phone without getting started ',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                validator: (s) {
                  // return s == '222222' ? null : 'Pin is incorrect';
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) => print(pin),
                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: PhoneScreen.verify,
                              smsCode: code);

                      await auth.signInWithCredential(credential);

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'HomeScreen', (route) => false);
                    } catch (e) {
                      print("Wrong OTP");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Verify Phone Number'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'PhoneScreen', (route) => false);
                      },
                      child: const Text(
                        "Edit Phone number",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
