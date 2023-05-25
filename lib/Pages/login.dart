import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/constans.dart';
import 'package:http/http.dart';
import 'package:home_production/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPage> {
  //Fungsi secure text password
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginSubmit() async {
    var loginUrl = Uri.parse(BASEURL.apiLogin);

    final response = await post(loginUrl, body: {
      "email": emailController.text,
      "password": passwordController.text,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String idUser = data['user_id'];
    String name = data['name'];
    String email = data['email'];
    String createdAt = data['created_at'];
    if (value == 1) {
      savePref(idUser, name, email, createdAt);
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text(
                  "informasi",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    color: primaryButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(message,
                    style: textTextStyle.copyWith(
                      fontSize: 14,
                      color: primaryButtonColor,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      },
                      child: Text("ok",
                          style: textTextStyle.copyWith(
                            fontSize: 12,
                            color: primaryButtonColor,
                          )))
                ],
              )));
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text(
                  "informasi",
                  style: textTextStyle.copyWith(
                    fontSize: 18,
                    color: primaryButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(message,
                    style: textTextStyle.copyWith(
                      fontSize: 14,
                      color: primaryButtonColor,
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "kembali",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                          color: primaryButtonColor,
                        ),
                      ))
                ],
              )));
      setState(() {});
    }
  }

  savePref(String idUser, String name, String email, String createdAt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString(PrefProfile.idUser, idUser);
      sharedPreferences.setString(PrefProfile.name, name);
      sharedPreferences.setString(PrefProfile.email, email);
      sharedPreferences.setString(PrefProfile.createAt, createdAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        body: Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Home Production",
                      style: textTextStyle.copyWith(
                          fontSize: 30, fontWeight: bold),
                    ),
                    SizedBox(height: 11),
                    Text(
                      "Live streaming,Cinematic video,and Documentation.",
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //kolom Email
                        SizedBox(height: 15),
                        Text(
                          "Email",
                          style: textTextStyle.copyWith(
                              fontSize: 12, fontWeight: bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor,
                          ),
                          child: TextField(
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            style: textTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "ilhamgusti123@gmail.com",
                                hintStyle: textTextStyle.copyWith(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.6)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 17)),
                          ),
                        ),

                        //kolom password
                        SizedBox(height: 15),
                        Text(
                          "Password",
                          style: textTextStyle.copyWith(
                              fontSize: 12, fontWeight: bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor,
                          ),
                          child: TextField(
                            enableInteractiveSelection: true,
                            obscureText: _secureText,
                            controller: passwordController,
                            style: textTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "••••••••••••••",
                              hintStyle: textTextStyle.copyWith(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.6)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 17),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: _secureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //kolom checkbox remember me
                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "akun bermasalah?hubungi kami",
                      style: greyTextStyle.copyWith(fontSize: 10),
                    ),

                    Text(
                      "HomeProduction@gmail.com",
                      style: textTextStyle.copyWith(fontSize: 10),
                    ),

                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Perhatian !!"),
                                      content: Text(
                                          "Mohon masukkan data dengan benar!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ));
                          } else {
                            loginSubmit();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryButtonColor,
                        ),
                        child: Text(
                          "LOGIN",
                          style: whiteTextStyle.copyWith(fontWeight: bold),
                        ),
                      ),
                    ),

                    //kolom login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun?",
                          style: secondaryTextStyle.copyWith(fontSize: 12),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                                (route) => false);
                          },
                          child: Text(
                            "Sign up",
                            style: tncTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}
