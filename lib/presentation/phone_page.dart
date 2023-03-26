import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhonePage extends StatelessWidget {
  PhonePage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneController =
      TextEditingController(text: '+79017795004');

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _key,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gor.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.9,
                  width: width * 0.8,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Авторизация',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _phoneController,
                              validator: (value) {
                                if (value?.trim().isNotEmpty == true) {
                                  return null;
                                }
                                return "Это обязательное поле";
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                labelText: 'Номер телефона',
                                prefixIcon: const Icon(Icons.alternate_email),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: '+79017777777',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _codeController,
                              obscureText: true,
                              // validator: (value) {
                              //   if (value?.trim().isNotEmpty == true) {
                              //     return null;
                              //   }
                              //   return "Это обязательное поле";
                              // },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                labelText: 'Код',
                                prefixIcon: const Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: '_ _ _ _',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                print('все ок');
                                var user = await _auth.verifyPhoneNumber(
                                  verificationCompleted: (PhoneAuthCredential credential) async {
                                    print('!!!!!!!!!!!!!!!!!!!!!completed: $credential');
                                    await _auth.signInWithCredential(credential);
                                  },
                                  verificationFailed: (FirebaseAuthException e){
                                    print('!!!!!!!!!!!!!!${e.code}');
                                    if (e.code == 'invalid-phone-number') {
                                      print('!!!!!!!!!!!!!!!!!!!!!The provided phone number is not valid.');
                                    }
                                  },
                                  codeSent: (String verificationId, int? resendToken) async {
                                    print('!!!!!!!!!!!!!!!!!!!!!codeSent: $verificationId; $resendToken');
                                    // Update the UI - wait for the user to enter the SMS code
                                    String smsCode = 'xxxx';

                                    // Create a PhoneAuthCredential with the code
                                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

                                    // Sign the user in (or link) with the credential
                                    await _auth.signInWithCredential(credential);
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    print('!!!!!!!!!!!!!!!!!!!!!verificationId: $verificationId');
                                      },
                                  phoneNumber: _phoneController.value.text,
                                  timeout: const Duration(seconds: 60),
                                );
                                // ConfirmationResult confirmationResult =
                                //     await _auth.signInWithPhoneNumber(
                                //         _phoneController.value.text);
                                //
                                // UserCredential userCredential =
                                //     await confirmationResult.confirm('651838');
                                // print(userCredential);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25),
                              child: Text(
                                'Войти',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
