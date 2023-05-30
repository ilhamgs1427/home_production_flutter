import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_production/home.dart';

import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:home_production/Network/Api/url_api.dart';
import 'package:home_production/Network/Models/history_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:home_production/Network/Models/pref_profile_model.dart';
import 'package:home_production/constans.dart';
import 'package:home_production/widget/widget_ilustration.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

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
    final response = await http.get(urlHistory);
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
                    metodepembayaran: x.metodePembayaran,
                    buktipembayaran: x.buktiTransfer,
                  ),
                );
              }),
    );
  }
}

class cartRiwayat extends StatefulWidget {
  final String NamaLengkapPesanan;
  final String AlamatPesanan;
  final String phonePesanan;
  final String TanggalPesanan;
  final String namaproductPesanan;
  final String metodepembayaran;
  final String IdPesanan;
  final String buktipembayaran;

  cartRiwayat({
    required this.NamaLengkapPesanan,
    required this.AlamatPesanan,
    required this.phonePesanan,
    required this.TanggalPesanan,
    required this.namaproductPesanan,
    required this.IdPesanan,
    required this.metodepembayaran,
    required this.buktipembayaran,
  });

  @override
  State<cartRiwayat> createState() => _cartRiwayatState();
}

class _cartRiwayatState extends State<cartRiwayat> {
  Future<void> requestStoragePermission() async {
    // Cek izin akses penyimpanan sebelum membuka file PDF
    bool hasStoragePermission = await checkStoragePermission();
    if (hasStoragePermission) {
      // Lakukan tindakan untuk membuka file PDF
      getPDF();
    } else {
      // Izin akses penyimpanan belum diberikan, minta izin
      requestStoragePermission();
    }
  }

  dialogDelete() {
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
            content:
                Text("Apakah kamu yakin untuk menghapus riwayat pesananmu ini?",
                    style: textTextStyle.copyWith(
                      fontSize: 14,
                      color: primaryButtonColor,
                    )),
            actions: [
              InkWell(
                onTap: () {
                  deleteRiwayat();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
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

  //method delete riwayat
  Future<void> deleteRiwayat() async {
    Uri deleteRiwayatUrl = Uri.parse(BASEURL.deleteRiwayat);
    final response = await http
        .post(deleteRiwayatUrl, body: {"id_orders": widget.IdPesanan});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        print(pesan);
      });
    } else {
      print(pesan);
    }
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      // Izin sudah diberikan sebelumnya
      return true;
    } else {
      // Izin belum diberikan
      return false;
    }
  }

  //upload image ke api
  PostImage() async {
    try {
      var stream = http.ByteStream(_imageFile!.openRead());
      var length = await _imageFile!.length();
      var uri = Uri.parse(BASEURL.transfer);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_orders'] = widget.IdPesanan;
      request.files.add(http.MultipartFile("bukti_pembayaran", stream, length,
          filename: path.basename(_imageFile!.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    @override
    dynamic noSuchMethod(Invocation invocation) =>
        super.noSuchMethod(invocation);
  }

  //get image
  File? _imageFile;

  Future<void> getImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920,
      maxWidth: 1080,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // method get and post image
  Future<void> uploadImageAndPost() async {
    await getImage(); // Jalankan metode getImage() terlebih dahulu untuk mendapatkan gambar

    if (_imageFile != null) {
      await PostImage(); // Jika imagename tidak null, jalankan metode postImageName()
    } else {
      print("error");
    }
  }

  // method PDF
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
                                pw.Text(widget.NamaLengkapPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(widget.phonePesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(widget.TanggalPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(widget.namaproductPesanan,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      font: dataText,
                                    )),
                                pw.SizedBox(height: 10),
                                pw.Text(widget.IdPesanan,
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
                        pw.Text(widget.AlamatPesanan,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: 270,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 23,
            child: Material(
              child: Container(
                height: 240.0,
                width: 350.0,
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
              height: 300,
              width: 280,
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
                        SizedBox(height: 1),
                        Text(
                          "Pembayaran",
                          style: textTextStyle.copyWith(
                            fontSize: 11,
                            color: primaryButtonColor,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "Bukti(Transfer)",
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
                            widget.NamaLengkapPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.phonePesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.AlamatPesanan,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.TanggalPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.namaproductPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.IdPesanan,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.metodepembayaran,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTextStyle.copyWith(
                              fontSize: 11,
                              color: primaryButtonColor,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            widget.buktipembayaran,
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
            bottom: 13,
            left: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => uploadImageAndPost(),
                  child: Text(
                    'Upload',
                    style: textTextStyle.copyWith(
                      fontSize: 12,
                      color: whiteColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: primaryButtonColor,
                  ),
                ),
                SizedBox(width: 10),
                _imageFile != null
                    ? Text(
                        "berhasil",
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      )
                    : Text(
                        'Upload Transfer',
                        style: textTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            bottom: 208,
            left: 308,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
              child: ElevatedButton(
                onPressed: () {
                  dialogDelete();
                },
                style: ElevatedButton.styleFrom(
                  primary: primaryButtonColor,
                ),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 13,
            left: 300,
            child: ElevatedButton(
              onPressed: () => requestStoragePermission(),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(10, 5),
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
