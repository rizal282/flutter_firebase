import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/editdata.dart';

class TampilData extends StatefulWidget {
  @override
  _TampilDataState createState() => _TampilDataState();
}

class _TampilDataState extends State<TampilData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Barang"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: Firestore.instance.collection("dataBarang").snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ItemBarang(listBarang: snapshot.data.documents,);
          },
        ),
      ),
    );
  }
}

class ItemBarang extends StatelessWidget {
  final List<DocumentSnapshot> listBarang;
  String menuPilihan;

  static const menuItems = <String>[
    "Edit",
    "Hapus"
  ];

  final List<PopupMenuItem<String>> _popupMenuItems = menuItems
  .map(
    (String val) => PopupMenuItem<String>(
      value: val,
      child: Text(val),
    )).toList();

  ItemBarang({this.listBarang});

  void hapusData(index){
    Firestore.instance.runTransaction((Transaction tr) async {
      DocumentSnapshot snapshot = await tr.get(index);
      await tr.delete(snapshot.reference);
    });

    print("Data barang berhasil dihapus");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listBarang == null ? 0 : listBarang.length,
      itemBuilder: (context, i){
        String kodeBarang = listBarang[i].data["kodeBarang"].toString();
        String namaBarang = listBarang[i].data["namaBarang"].toString();
        String jumlahBarang = listBarang[i].data["jumlahBarang"].toString();
        String hargaBarang = listBarang[i].data["hargaBarang"].toString();

        return ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
                      child: Row(
              children: <Widget>[
                Text("Kode Barang : $kodeBarang"),
                SizedBox(width: 10,),
                Text("Nama Barang : $namaBarang")
              ],
            ),
          ),
          subtitle: Row(
            children: <Widget>[
              Text("Jumlah Barang : $jumlahBarang"),
              SizedBox(width: 10,),
              Text("Harga Barang : $hargaBarang"),
            ],
          ),
          trailing: PopupMenuButton<String>(
                onSelected: (String newVal){
                  menuPilihan = newVal;

                  if(menuPilihan == "Edit"){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Editdata(
                        index: listBarang[i].reference,
                        kodeBarang: kodeBarang,
                        namaBarang: namaBarang,
                        jumlahBarang: jumlahBarang,
                        hargaBarang: hargaBarang,
                      ))
                    );
                  }else{
                    hapusData(listBarang[i].reference);
                  }
                },
                itemBuilder: (context) => _popupMenuItems,
              ),
        );
      },
    );
  }
}