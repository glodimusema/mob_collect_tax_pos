import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mob_collect_tax_pos/Home/description.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';
import 'package:mob_collect_tax_pos/MyClasses/pub_con.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  var jsondata;
  bool loading = true;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _newlist = [];
  final _baseUrl = '${PubCon.cheminApi}fetch_list_contribuable/';
  getdata() async {
    try {
      setState(() {
        loading = true;
      });

      var response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        jsondata = json.decode(response.body)['data'];
        print(jsondata);
      } else {
        print("Error");
      }
      for (var i = 0; i < jsondata.length; i++) {
        _allUsers.add({
          "id": jsondata[i]["id"],
          "prix_categorie": jsondata[i]["prix_categorie"],
          "colQuartier_Ese": jsondata[i]["colQuartier_Ese"],
          "colProprietaire_Ese": jsondata[i]["colProprietaire_Ese"],
          "entreprisePhone1": jsondata[i]["entreprisePhone1"],
        });
      }
      //TO SHOW ALL LIST AT INITIAL
      setState(() {
        _newlist = _allUsers;
        loading = false;
      });
    } catch (ex) {}
  }

  //
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void _searchlist(String value) {
    try {
      setState(() {
        if (value.isEmpty) {
          _newlist = _allUsers;
        } else {
          _newlist = _allUsers
              .where((element) =>
                  element['colProprietaire_Ese']
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()) ||
                  element['entreprisePhone1']
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()))
              .toList();
        }
      });
    } catch (ex) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Search Page"),
      ),
      body: loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        _searchlist(value);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Recherchez ici...",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ListView.builder(
                      itemCount: _newlist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => description(
                            //       context,
                            //       _newlist[index]['colNom_Ese'],
                            //       _newlist[index]['prix_categorie'],
                            //     ),
                            //   ),
                            // );

                            //on recupere le nom et le prix de la categorie
                            setState(() {
                              PubCon.refEntreprise = _newlist[index]['id'];
                              PubCon.DesignationEntreprise =
                                  _newlist[index]['colProprietaire_Ese'];
                              PubCon.PrixEntreprise =
                                  "${_newlist[index]['prix_categorie']}";
                            });

                            if (Navigator.canPop(context)) {
                              Navigator.pop(
                                  context, PubCon.DesignationEntreprise);
                            } else {
                              SystemNavigator.pop();
                            }
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                _newlist[index]['colProprietaire_Ese'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                "${_newlist[index]['prix_categorie'].toString()} \$",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Text(_newlist[index]['colQuartier_Ese']),
                                    Text("Propriétaire:"),
                                    Text(
                                      _newlist[index]['colProprietaire_Ese'],
                                      overflow: TextOverflow.clip,
                                    ),
                                    Row(
                                      children: [
                                        Text("Téléphone:"),
                                        Text(
                                            _newlist[index]['entreprisePhone1'])
                                      ],
                                    ),
                                    Divider()
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
