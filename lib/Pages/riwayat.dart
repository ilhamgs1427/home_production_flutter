import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Network/Models/history_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/constans.dart';
import 'package:home_production/widget/widget_ilustration.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

class riwayatPage extends StatefulWidget {
  riwayatPage({super.key});

  @override
  State<riwayatPage> createState() => _riwayatPageState();
}

class _riwayatPageState extends State<riwayatPage> {
  // get id user
  List<HistoryOrderModel> list = [];
  String? userID;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfile.idUser);
    });
    getHistory();
  }

  // get data history
  getHistory() async {
    var urlHistory = Uri.parse(BASEURL.history + userID!);
    final response = await get(urlHistory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          for (Map<String, dynamic> item in data) {
            list.add(HistoryOrderModel.fromJson(item));
          }
          print(list[0].idUser);
        } else {
          // Respons JSON kosong, lakukan tindakan yang sesuai
          print("user kosong");
        }
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryButtonColor,
        centerTitle: true,
        title: Text(
          "Riwayat resevervasi",
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: list.length == 0
          ? Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: WidgetIlustration(
                  image: "assets/images/1.jpg",
                  subtitle1: "You dont have history order",
                  subtitle2: "lets shopping now",
                  title: "Oops, there are no history order",
                ),
              ),
            )
          : ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list.reversed.toList()[i];
                return InkWell(
                  child: cartRiwayat(
                    NamaLengkapPesanan: x.namaUser,
                    phonePesanan: x.notelepon,
                    AlamatPesanan: x.alamat,
                    TanggalPesanan: x.reservasi,
                    namaproductPesanan: x.namaProduct,
                    IdPesanan: x.idOrders,
                  ),
                );
              }),
    );
  }
}

class cartRiwayat extends StatelessWidget {
  final String NamaLengkapPesanan;
  final String AlamatPesanan;
  final String phonePesanan;
  final String TanggalPesanan;
  final String namaproductPesanan;
  final String IdPesanan;

  void getPDF() async {
    // buat class pdf
    final pdf = pw.Document();

    var primaryFont = await rootBundle.load("assets/font/Poppins-Bold.ttf");
    var dataFont = await rootBundle.load("assets/font/Poppins-Regular.ttf");

    var primaryText = pw.Font.ttf(primaryFont);
    var dataText = pw.Font.ttf(dataFont);

    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.Container(
                color: PdfColor.fromInt(0xff130160),
                alignment: pw.Alignment.center,
                width: double.infinity,
                child: pw.Text("Home Production",
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: PdfColor.fromInt(0xffFFFFFF),
                      fontWeight: pw.FontWeight.bold,
                      font: primaryText,
                    )),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Jasa Live Streaming dan Video berkualitas di Sidoarjo",
                  style: pw.TextStyle(
                    fontSize: 11,
                    font: dataText,
                  )),
              pw.SizedBox(height: 5),
              pw.Text(" HomeProduction@gmail.com || 089531704945",
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: dataText,
                  )),
              pw.SizedBox(height: 10),
              pw.Text("",
                  style: pw.TextStyle(
                    fontSize: 11,
                    font: dataText,
                  )),
              pw.Divider(
                color: PdfColor.fromInt(0xFF313131),
                height: 10,
                thickness: 1,
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  width: double.infinity,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Nama",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text("No telepon",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text("Reservasi",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text("Layanan",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text("Id Pesanan",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                              ]),
                          pw.SizedBox(width: 10),
                          pw.Column(children: [
                            pw.Text(":",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: dataText,
                                )),
                            pw.SizedBox(height: 10),
                            pw.Text(":",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: dataText,
                                )),
                            pw.SizedBox(height: 10),
                            pw.Text(":",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: dataText,
                                )),
                            pw.SizedBox(height: 10),
                            pw.Text(":",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: dataText,
                                )),
                            pw.SizedBox(height: 10),
                            pw.Text(":",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: dataText,
                                )),
                          ]),
                          pw.SizedBox(width: 10),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(NamaLengkapPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(phonePesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(TanggalPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(namaproductPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(IdPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                              ]),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Text("Alamat :",
                            style: pw.TextStyle(
                              fontSize: 11,
                              font: dataText,
                            )),
                        pw.SizedBox(height: 10),
                        pw.Text(AlamatPesanan,
                            style: pw.TextStyle(
                              fontSize: 11,
                              font: dataText,
                            )),
                      ])),
              pw.SizedBox(height: 20),
              pw.Divider(
                color: PdfColor.fromInt(0xFF313131),
                height: 10,
                thickness: 1,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  "Penyedia layanan setuju menyediakan layanan live streaming video kepada Klien sesuai persyaratan yang disepakati. Klien bertanggung jawab atas informasi acara dan pembayaran yang telah disepakati.*",
                  style: pw.TextStyle(
                    fontSize: 11,
                    font: dataText,
                  )),
              pw.SizedBox(height: 250),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      color: PdfColor.fromInt(0xFF313131),
                      height: 1,
                      width: 130,
                    ),
                    pw.Container(
                      color: PdfColor.fromInt(0xFF313131),
                      height: 1,
                      width: 130,
                    ),
                  ])
            ]);
          }),
    );
    //simpan
    Uint8List bytes = await pdf.save();

    //buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/bukti_reservasi.pdf');

    //timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path, type: "application/pdf");
    print(file.path);
  }

  cartRiwayat({
    required this.NamaLengkapPesanan,
    required this.AlamatPesanan,
    required this.phonePesanan,
    required this.TanggalPesanan,
    required this.namaproductPesanan,
    required this.IdPesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 23,
            child: Material(
              child: Container(
                height: 150.0,
                width: 320.0,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 40,
            child: Container(
              height: 150,
              width: 250,
              child: Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "No Telepon",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Alamat",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Reservasi",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Layanan",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Id Pesanan",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                      ]),
                  SizedBox(width: 5),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          ":",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                      ]),
                  SizedBox(width: 5),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NamaLengkapPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            phonePesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            AlamatPesanan,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            TanggalPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            namaproductPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            IdPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 275,
            child: ElevatedButton(
              onPressed: () => getPDF(),
              style: ElevatedButton.styleFrom(
                primary: primaryButtonColor,
              ),
              child: Text(
                "pdf",
                style: whiteTextStyle.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
