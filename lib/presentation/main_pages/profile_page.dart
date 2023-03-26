import 'package:firebase_auth2/presentation/di/app_module.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("${AppModule.getProfileHolder().profile.surname} ${AppModule.getProfileHolder().profile.name}", style: TextStyle(fontSize: 24),),
                ),
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Почта: ${AppModule.getProfileHolder().profile.email}", style: TextStyle(fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
