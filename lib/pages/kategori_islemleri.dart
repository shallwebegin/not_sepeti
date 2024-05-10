import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:path/path.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumKategoriler = [];
    _kategoriListesiniGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
      ),
      body: ListView.builder(
        itemCount: tumKategoriler.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => _kategoriGuncelle(tumKategoriler[index], context),
            title: Text(tumKategoriler[index].kateogriBaslik!),
            trailing: IconButton(
              onPressed: () =>
                  _kategoriSil(tumKategoriler[index].kategoriID, context),
              icon: const Icon(Icons.delete),
            ),
            leading: const Icon(Icons.category),
          );
        },
      ),
    );
  }

  void _kategoriListesiniGuncelle() async {
    List<Kategori> kategorileriIcerenList =
        await databaseHelper.kategoriListesiniGetir();
    setState(() {
      tumKategoriler = kategorileriIcerenList;
    });
  }

  _kategoriSil(int? kategoriID, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kategori Sil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Bu kategoriyi Sildiginizde bununla ilgili tüm notlarda silinecektir emin misiniz?'),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Vazgeç'),
                  ),
                  TextButton(
                    onPressed: () {
                      databaseHelper.kategoriSil(kategoriID!).then((value) {
                        if (value != 0) {
                          setState(() {
                            _kategoriListesiniGuncelle();
                            Navigator.of(context).pop();
                          });
                        }
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Kategoriyi Sil',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _kategoriGuncelle(Kategori guncellenecekKategori, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          _kategoriGuncelleDialog(context, guncellenecekKategori),
    );
  }

  SimpleDialog _kategoriGuncelleDialog(
      BuildContext context, Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();
    late String guncellenecekKategoriAdi;

    return SimpleDialog(
      shape: const BeveledRectangleBorder(),
      title: Text(
        'Kategori Güncelle',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: guncellenecekKategori.kateogriBaslik,
              onSaved: (yeniDeger) {
                guncellenecekKategoriAdi = yeniDeger!;
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
                  databaseHelper.kategoriGuncelle(Kategori.withID(
                      guncellenecekKategori.kategoriID,
                      guncellenecekKategoriAdi));
                  _kategoriListesiniGuncelle();
                  Navigator.of(context).pop();
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
}
