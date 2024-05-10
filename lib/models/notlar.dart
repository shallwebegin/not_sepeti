// ignore_for_file: public_member_api_docs, sort_constructors_first
class Not {
  int? notID;
  late int kategoriID;
  String? kategoriBaslik;
  late String notBaslik;
  late String notIcerik;
  late String notTarih;
  late int notOncelik;

  Not(this.kategoriID, this.notBaslik, this.notIcerik, this.notTarih,
      this.notOncelik); // verileri yazarken

  Not.withID(this.notID, this.kategoriID, this.notBaslik, this.notIcerik,
      this.notOncelik, this.notTarih); //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.kategoriID = map['kategoriID'];
    this.notBaslik = map['notBaslik'];
    this.kategoriBaslik = map['kategoriBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notOncelik = map['notOncelik'];
    this.notTarih = map['notTarih'];
  }

  @override
  String toString() {
    return 'Not(notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik)';
  }
}
