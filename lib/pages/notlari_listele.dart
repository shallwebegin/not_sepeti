import 'package:flutter/material.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/pages/not_detay.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.notlariGetir().then((notlariIcerenMapListesi) {
      for (Map<String, dynamic> map in notlariIcerenMapListesi) {
        tumNotlar.add(Not.fromMap(map));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                title: Text(tumNotlar[index].notBaslik),
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Kategori',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(tumNotlar[index].kategoriBaslik!,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Oluşturulma Tarihi',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(tumNotlar[index].notTarih,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('İçerik : ${tumNotlar[index].notIcerik}'),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _notSil(tumNotlar[index].notID);
                              },
                              child: const Text(
                                'Sil',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  _detaySayfasinaGit(context, tumNotlar[index]);
                                },
                                child: const Text(
                                  'Güncelle',
                                  style: TextStyle(color: Colors.greenAccent),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: 'Notu Duzenle',
          duzenlenecekNot: not,
        ),
      ),
    );
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text('Az'),
          backgroundColor: Colors.redAccent.shade100,
        );
      case 1:
        return CircleAvatar(
          child: Text('Orta'),
          backgroundColor: Colors.redAccent.shade400,
        );
      case 2:
        return CircleAvatar(
          child: Text('Acil'),
          backgroundColor: Colors.redAccent.shade700,
        );
      default:
    }
  }

  Future<void> _notSil(int? notID) async {
    await databaseHelper.notSil(notID!);
    databaseHelper.notListesiniGetir();
  }
}
