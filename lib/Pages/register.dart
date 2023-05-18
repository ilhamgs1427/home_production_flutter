import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Pages/login.dart';
import 'package:home_production/constans.dart';
import 'package:http/http.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controller
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //fungsi secure text password
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  registerSubmit() async {
    var registerUrl = Uri.parse(BASEURL.apiRegister);

    final response = await post(registerUrl, body: {
      "fullname": fullNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "password": passwordController.text,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
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
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      },
                      child: Text(
                        "ok",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                          color: primaryButtonColor,
                        ),
                      ))
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
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        body: Center(
            child: ListView(
          children: [
            Container(
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
                      height: 64,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //kolom nama
                        SizedBox(height: 15),
                        Text(
                          "Nama Lengkap",
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
                            controller: fullNameController,
                            style: textTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "alex widodo",
                                hintStyle: textTextStyle.copyWith(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.6)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 17)),
                          ),
                        ),

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
                            controller: emailController,
                            style: textTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "example123@gmail.com",
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

                    SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (fullNameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Warning !!"),
                                      content: Text("Please, enter the fields"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ));
                          } else {
                            registerSubmit();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryButtonColor,
                        ),
                        child: Text(
                          "REGISTER",
                          style: whiteTextStyle.copyWith(fontWeight: bold),
                        ),
                      ),
                    ),

                    //kolom login
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "do you already have an account?",
                          style: secondaryTextStyle.copyWith(fontSize: 12),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: Text(
                            "Log in",
                            style: tncTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        )));
  }
}
