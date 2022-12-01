import 'dart:convert';
import 'dart:convert';
import 'package:vigenesia/Models/Motivasi_Model.dart';
import 'package:vigenesia/Screens/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';

class MainScreens extends StatefulWidget {
  final String? idUser;
  final String? nama;
  const MainScreens({Key? key, this.nama, this.idUser}) : super(key: key);
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  String? id;
  var dio = Dio();
  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();
  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.idUser
    }; // [Tambah IDUSER -> Widget.iduser]
    try {
      Response response = await dio.post(
          "$baseurl/vigenesia/api/dev/POSTmotivasi/",
          data: body,
          options: Options(
              contentType: Headers
                  .formUrlEncodedContentType)); // Formatnya Harus Form Data
      print("Respon -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];
  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get(
        '$baseurl/vigenesia/api/Get_motivasi?iduser=${widget.idUser}'); // NGambil by data
    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-type": "application/json"}));
    print(" ${response.data}");
    var resbody = jsonDecode(response.data);
    return resbody;
  }

  Future<List<MotivasiModel>> getData2() async {
    var response = await dio
        .get('$baseurl/vigenesia/api/Get_motivasi'); // Ngambil by ALL USER
    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      listproduk.clear();
      return;
    });
  }

  TextEditingController isiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  String? trigger;
  String? triggeruser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Icon(Icons.stars),
        title: Text('Vigenesia Kelompok 11 | Home'),
      ),
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // <-- Berfungsi untuk atur nilai X jadi tengah
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/logo.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle),
                    ),
                    Text(
                      "MOTIVASI",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      "Visi Generasi Indonesia",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hallo ${widget.nama}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.orange),
                        ),
                        TextButton(
                            child: Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Login()));
                            })
                      ],
                    ),
                    SizedBox(height: 20), // <-- Kasih Jarak Tinggi : 50px
                    FormBuilderTextField(
                      controller: isiController,
                      name: "isi_motivasi",
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.menu_book),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: "Isi Motivasi"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                        label: Text('Submit'),
                        icon: Icon(Icons.done_outline),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: () async {
                          await sendMotivasi(
                            isiController.text.toString(),
                          ).then((value) => {
                                if (value != null)
                                  {
                                    Flushbar(
                                      message: "Berhasil Submit",
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.greenAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                              });
                          _getData();
                          print("Sukses");
                        },
                      ),
                    ),
                    TextButton(
                      child: Icon(
                        Icons.refresh,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _getData();
                      },
                    ),
                    FormBuilderRadioGroup(
                        onChanged: (value) {
                          setState(() {
                            trigger = value;
                            print(
                                " HASILNYA --> ${trigger}"); // hasil ganti value
                          });
                        },
                        name: "_",
                        options: ["Motivasi By All", "Motivasi By User"]
                            .map((e) => FormBuilderFieldOption(
                                value: e, child: Text("${e}")))
                            .toList()),
                    trigger == "Motivasi By All"
                        ? FutureBuilder(
                            future: getData2(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<MotivasiModel>> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: Column(
                                    children: [
                                      for (var item in snapshot.data!)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Container(
                                                  child:
                                                      Text(item.isiMotivasi!)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data!.isEmpty) {
                                return Text("No Data");
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                        : Container(),
                    trigger == "Motivasi By User"
                        ? FutureBuilder(
                            future: getData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<MotivasiModel>> snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    for (var item in snapshot.data!)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Expanded(
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                  Text(item.isiMotivasi!),
                                                  Row(children: [
                                                    TextButton(
                                                      child:
                                                          Icon(Icons.settings),
                                                      onPressed: () {
                                                        String id;
                                                        String isi_motivasi;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  EditPage(
                                                                      id: item
                                                                          .id,
                                                                      isi_motivasi:
                                                                          item.isiMotivasi),
                                                            ));
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Icon(Icons.delete),
                                                      onPressed: () {
                                                        deletePost(item.id!)
                                                            .then((value) => {
                                                                  if (value !=
                                                                      null)
                                                                    {
                                                                      Flushbar(
                                                                        message:
                                                                            "Berhasil Delete",
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                        backgroundColor:
                                                                            Colors.redAccent,
                                                                        flushbarPosition:
                                                                            FlushbarPosition.TOP,
                                                                      ).show(
                                                                          context)
                                                                    }
                                                                });
                                                        _getData();
                                                      },
                                                    )
                                                  ]),
                                                ])),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data!.isEmpty) {
                                return Text("No Data");
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                        : Container(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
