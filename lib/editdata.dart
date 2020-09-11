import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Editdata extends StatefulWidget {
  final index;
  final String kodeBarang, namaBarang, jumlahBarang, hargaBarang;

  const Editdata(
      {Key key,
      this.index,
      this.kodeBarang,
      this.namaBarang,
      this.jumlahBarang,
      this.hargaBarang})
      : super(key: key);
  @override
  _EditdataState createState() => _EditdataState();
}

class _EditdataState extends State<Editdata> {
  final _kodeBarang = new TextEditingController();
  final _namaBarang = new TextEditingController();
  final _jumlahBarang = new TextEditingController();
  final _hargaBarang = new TextEditingController();

  void setValueForm(){
    _kodeBarang.text = widget.kodeBarang;
    _namaBarang.text = widget.namaBarang;
    _jumlahBarang.text = widget.jumlahBarang;
    _hargaBarang.text = widget.hargaBarang;
  }

  void prosesEdit(){
    Firestore.instance.runTransaction((Transaction tr) async {
      DocumentSnapshot snapshot = await tr.get(widget.index);
      await tr.update(snapshot.reference, {
        "kodeBarang" : _kodeBarang.text,
        "namaBarang" : _namaBarang.text,
        "jumlahBarang" : _jumlahBarang.text,
        "hargaBarang" : _hargaBarang.text
      });
    });

    print("Data Barang sudah berhasil diupdate");
  }

  @override
  void initState() {
    setValueForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
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
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _namaBarang,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _jumlahBarang,
                decoration: InputDecoration(
                  labelText: "Jumlah Barang",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _hargaBarang,
                decoration: InputDecoration(
                  labelText: "Harga Barang",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              OutlineButton(
                child: Text("Simpan"),
                onPressed: () => prosesEdit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
