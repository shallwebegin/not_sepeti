// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  const NotDetay({
    super.key,
    required this.baslik,
  });

  final String baslik;

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  final _formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;
  int secilenKategoriID = 1;
  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorilerGetir().then((kategorileriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length < 0
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Kategori : ',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: secilenKategoriID,
                                items: kategoriItemleriOlustur(),
                                onChanged: (value) {
                                  secilenKategoriID = value!;
                                  setState(() {});
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                    width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )),
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
