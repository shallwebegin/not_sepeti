import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/pages/kategori_islemleri.dart';
import 'package:not_sepeti/pages/not_detay.dart';
import 'package:not_sepeti/pages/notlari_listele.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class NotListesi extends StatefulWidget {
  const NotListesi({super.key});

  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Not Sepeti'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Kategoriler'),
                    onTap: _kategorilerSayfasinaGit,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return _kategoriEkleDialog(context);
                },
              );
            },
            heroTag: 'KategoriEkle',
            tooltip: 'Kategori Ekle',
            mini: true,
            child: const Icon(
              Icons.add_circle,
            ),
          ),
          FloatingActionButton(
            tooltip: 'Not Ekle',
            heroTag: 'NotEkle',
            onPressed: () {
              _detaySayfasinaGit(context);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Notlar(),
    );
  }

  SimpleDialog _kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    late String yeniKategoriAdi;

    return SimpleDialog(
      shape: const BeveledRectangleBorder(),
      title: Text(
        'Kategori Ekle',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (yeniDeger) {
                yeniKategoriAdi = yeniDeger!;
              },
              validator: (girilenKategoriAdi) {
                if (girilenKategoriAdi!.length < 3) {
                  return 'Kategori Adı en az 3 harften oluşmalı';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Kategori Adı', border: OutlineInputBorder()),
            ),
          ),
        ),
        ButtonBar(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Vazgeç',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  databaseHelper.kategoriEkle(Kategori(yeniKategoriAdi)).then(
                        (value) => Navigator.pop(context),
                      );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child:
                  const Text('Kaydet', style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  void _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: 'Yeni Not',
        ),
      ),
    );
  }

  void _kategorilerSayfasinaGit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Kategoriler(),
      ),
    );
  }
}
