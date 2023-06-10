class HistoryOrderModel {
  final int idOrders;
  final String idUser;
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
        idOrders: data['id'],
        idUser: data['user_id'],
        namaUser: data['name'],
        namaProduct: data['paket'],
        notelepon: data['phone'],
        alamat: data['message'],
        reservasi: data['date'],
        metodePembayaran: data['metode_pembayaran'],
        buktiTransfer: data['bukti_pembayaran']);
  }
}
