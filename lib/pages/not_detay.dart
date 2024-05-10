// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_is_empty, must_be_immutable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/pages/not_listesi.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  NotDetay({super.key, required this.baslik, this.duzenlenecekNot});

  final String baslik;
  Not? duzenlenecekNot;

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  final _formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;
  late int secilenKategoriID;
  late int secilenOncelik;
  static final _oncelikDegerleri = ['Düşük', 'Orta', 'Yüksek'];
  late String notBaslik, notIcerik;
  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorilerGetir().then((kategorileriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      if (widget.duzenlenecekNot != null) {
        secilenKategoriID = widget.duzenlenecekNot!.kategoriID;
        secilenOncelik = widget.duzenlenecekNot!.notOncelik;
      } else {
        secilenKategoriID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Kategori : ',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: secilenKategoriID,
                              items: kategoriItemleriOlustur(),
                              onChanged: (value) {
                                setState(() {
                                  secilenKategoriID = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notBaslik
                            : '',
                        validator: (value) {
                          if (value!.length < 3) {
                            return 'Lütfen 3 karakterden büyük bir başlık Giriniz';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          notBaslik = newValue!;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Not başlığını giriniz',
                            labelText: 'Başlık',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notIcerik
                            : '',
                        onSaved: (newValue) {
                          notIcerik = newValue!;
                        },
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'Not içeriğini giriniz',
                            labelText: 'İçerik',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Öncelik : ',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _oncelikDegerleri.map((oncelik) {
                                return DropdownMenuItem<int>(
                                  value: _oncelikDegerleri.indexOf(oncelik),
                                  child: Text(
                                    oncelik,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                              value: secilenOncelik,
                              onChanged: (value) {
                                secilenOncelik = value!;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            'Vazgeç',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (widget.duzenlenecekNot == null) {
                                databaseHelper
                                    .notEkle(Not(
                                      secilenKategoriID,
                                      notBaslik,
                                      notIcerik,
                                      DateFormat('hh:mm a')
                                          .format(DateTime.now())
                                          .toString(),
                                      secilenOncelik,
                                    ))
                                    .then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NotListesi(),
                                        ),
                                      ).then((value) => setState(() {})),
                                    );
                              } else {
                                databaseHelper
                                    .notGuncelle(
                                      Not.withID(
                                        widget.duzenlenecekNot!.notID,
                                        secilenKategoriID,
                                        notBaslik,
                                        notIcerik,
                                        secilenOncelik,
                                        DateFormat('hh:mm a').format(
                                          DateTime.now(),
                                        ),
                                      ),
                                    )
                                    .then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NotListesi(),
                                        ),
                                      ).then((value) => setState(() {})),
                                    );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text('Kaydet',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {
    return tumKategoriler
        .map(
          (kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(
              kategori.kateogriBaslik!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        )
        .toList();
  }
}
