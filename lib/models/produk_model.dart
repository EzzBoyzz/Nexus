import 'dart:convert';

List<ProdukModel> produkModelFromJson(String str) => List<ProdukModel>.from(
    json.decode(str).map((x) => ProdukModel.fromJson(x)));

String produkModelToJson(List<ProdukModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProdukModel {
  ProdukModel({
    this.idMenu,
    this.namaMenu,
    this.idUser,
    this.gambar,
    this.tanggalInput,
    this.deskrispsi,
    this.harga,
    this.stock,
  });

  String? idMenu;
  String? namaMenu;
  String? idUser;
  String? gambar;
  DateTime? tanggalInput;
  String? deskrispsi;
  String? harga;
  String? stock;

  factory ProdukModel.fromJson(Map<String, dynamic> json) => ProdukModel(
      idMenu: json["id_menu"],
      namaMenu: json["nama_menu"],
      idUser: json["iduser"],
      gambar: json["gambar"],
      harga: json["harga"],
      deskrispsi: json["deskrispsi"],
      tanggalInput: DateTime.parse(json["tanggal_input"]),
      stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
        "id_menu": idMenu,
        "nama_menu": namaMenu,
        "iduser": idUser,
        "gambar": gambar,
        "tanggal_input": tanggalInput?.toIso8601String(),
        "stock": stock,
        "deskrispsi": deskrispsi,
        "harga": harga,
      };
}
