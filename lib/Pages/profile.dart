import 'package:flutter/material.dart';
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/Pages/login.dart';
import 'package:home_production/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fullname, createdDate, email;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      fullname = sharedPreferences.getString(PrefProfile.name);
      email = sharedPreferences.getString(PrefProfile.email);
      createdDate = sharedPreferences.getString(PrefProfile.createAt);
    });
  }

  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(PrefProfile.idUser);
    sharedPreferences.remove(PrefProfile.name);
    sharedPreferences.remove(PrefProfile.email);
    sharedPreferences.remove(PrefProfile.createAt);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  dialogSignOut() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: whiteColor,
            title: Text(
              "Perhatian",
              style: textTextStyle.copyWith(
                fontSize: 18,
                color: primaryButtonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Apakah kamu yakin untuk keluar akun ini?",
                style: textTextStyle.copyWith(
                  fontSize: 14,
                  color: primaryButtonColor,
                )),
            actions: [
              InkWell(
                onTap: () {
                  signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Text(
                  "Iya",
                  style: textTextStyle.copyWith(
                    fontSize: 12,
                    color: primaryButtonColor,
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Tidak",
                    style: textTextStyle.copyWith(
                      fontSize: 12,
                      color: primaryButtonColor,
                    ),
                  )),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        title: Text('My Profile'),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right: kDefaultPadding / 2),
              child: Row(children: [
                InkWell(
                    onTap: () {
                      dialogSignOut();
                    },
                    child: Icon(Icons.logout_sharp)),
                kHalfSizedBox,
                Text(
                  'logout',
                  style: textTextStyle.copyWith(
                    color: whiteColor,
                    fontSize: 12,
                  ),
                )
              ]),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                color: primaryButtonColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(kDefaultPadding * 2),
                  bottomRight: Radius.circular(kDefaultPadding * 2),
                )),
            child: Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  maxRadius: 50.0,
                  minRadius: 50.0,
                  backgroundColor: kSecondaryColor,
                  backgroundImage: AssetImage('assets/images/2.jpg'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullname?.toString() ?? '',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: whiteColor,
                          ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'customer || Home Production',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 14.0,
                            color: whiteColor,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          ProfileDetailColumn(
            title: 'Nama Lengkap',
            value: fullname?.toString() ?? '',
          ),
          ProfileDetailColumn(
            title: 'Email',
            value: email?.toString() ?? '',
          ),
          ProfileDetailColumn(
            title: 'Tanggal Bergabung ',
            value: createdDate?.toString() ?? '',
          ),
        ],
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn(
      {Key? key, required this.title, required this.value})
      : super(key: key);
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
      padding: EdgeInsets.all(10),
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTextStyle.copyWith(
                  color: primaryButtonColor,
                  fontSize: 15,
                ),
              ),
              kHalfSizedBox,
              Text(value, style: Theme.of(context).textTheme.caption),
              kHalfSizedBox,
              SizedBox(
                width: 200,
                child: Divider(
                  thickness: 1,
                ),
              )
            ],
          ),
          Icon(
            Icons.lock_outline,
            size: 20,
            color: primaryButtonColor,
          ),
        ],
      ),
    );
  }
}
