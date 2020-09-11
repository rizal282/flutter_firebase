import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/tampildata.dart';

class TambahData extends StatefulWidget {
  final FirebaseUser user;

  const TambahData({Key key, this.user}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _jumlahBarang = new TextEditingController();
  final _hargaBarang = new TextEditingController();

  Future<Null> _logoutUser() async {
    FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  void _simpanBarang() {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = Firestore.instance.collection("dataBarang");
      await reference.add({
        "kodeBarang" : _kodeBarang.text,
        "namaBarang" : _namaBarang.text,
        "jumlahBarang" : _jumlahBarang.text,
        "hargaBarang" : _hargaBarang.text
      });
    });

    print("Data barang sudah disimpan!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app), onPressed: () => _logoutUser())
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _kodeBarang,
                decoration: InputDecoration(
                  labelText: "Kode Barang",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _namaBarang,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _jumlahBarang,
                decoration: InputDecoration(
                  labelText: "Jumlah Barang",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _hargaBarang,
                decoration: InputDecoration(
                  labelText: "Harga Barang",
                ),
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    child: Text("Simpan"),
                    onPressed: () => _simpanBarang(),
                  ),
                  OutlineButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TampilData())
                    ),
                    child: Text("Lihat Data"),
                  )
                ],
              ),
  
            ],
          ),
        ),
      ),
    );
  }
}
