// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  int? kategoriID;
  String? kateogriBaslik;

  Kategori(
      this.kateogriBaslik); // Kategori eklerken kullan, çünkü id db tarafından oluşturuluyor

  Kategori.withID(this.kategoriID,
      this.kateogriBaslik); // Kategorileri dbden okurken kullanılır

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kateogriBaslik;

    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map['kategoriID'];
    this.kateogriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() =>
      'Kategori(kategoriID: $kategoriID, kateogriBaslik: $kateogriBaslik)';
}
