import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:home_production/constans.dart';
import 'package:home_production/widget/widget_ilustration.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
      userID == null ? sessionLogout() : sessionLogin();
    });
  }

  sessionLogout() {}
  sessionLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            WidgetIlustration(
              image: 'assets/images/1.jpg',
              title: "Solusi terbaik buat\nlive streaming",
              subtitle1: "nikmati layanan kami",
              subtitle2:
                  "   tersedia beberapa paket  \n         murah dan terbaik",
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryButtonColor,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Text(
                  "RESERVASI SEKARANG",
                  style: whiteTextStyle.copyWith(fontWeight: bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
