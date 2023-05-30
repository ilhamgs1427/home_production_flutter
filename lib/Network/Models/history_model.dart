class HistoryOrderModel {
  final String idOrders;
  final String idUser;
  final String idProduct;
  final String namaUser;
  final String namaProduct;
  final String notelepon;
  final String alamat;
  final String reservasi;
  final String metodePembayaran;
  final String buktiTransfer;

  HistoryOrderModel({
    required this.idOrders,
    required this.idUser,
    required this.idProduct,
    required this.namaUser,
    required this.namaProduct,
    required this.notelepon,
    required this.alamat,
    required this.reservasi,
    required this.metodePembayaran,
    required this.buktiTransfer,
  });

  factory HistoryOrderModel.fromJson(Map<String, dynamic> data) {
    return HistoryOrderModel(
        idOrders: data['id_orders'],
        idUser: data['id_user'],
        idProduct: data['id_product'],
        namaUser: data['nama_user'],
        namaProduct: data['nama_product'],
        notelepon: data['phone'],
        alamat: data['alamat'],
        reservasi: data['reservasi'],
        metodePembayaran: data['metode_pembayaran'],
        buktiTransfer: data['bukti_pembayaran']);
  }
}
