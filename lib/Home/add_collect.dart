import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:mob_collect_tax_pos/Home/search_menage.dart';
import 'package:mob_collect_tax_pos/Home/select_violation.dart';
import 'package:mob_collect_tax_pos/Home/select_auteur.dart';
import 'package:mob_collect_tax_pos/Home/select_genre.dart';
import 'package:mob_collect_tax_pos/Home/select_ethni.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mob_collect_tax_pos/Home/select_entreprise.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_glossaire.dart';
import 'package:mob_collect_tax_pos/MyClasses/pub_con.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddCollect extends StatefulWidget {
  const AddCollect({super.key});

  @override
  State<AddCollect> createState() => _AddCollectState();
}

class _AddCollectState extends State<AddCollect> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool saving = false, charging = false;
  TextEditingController _edittxtMontant = TextEditingController(),
      cCode = TextEditingController(),
      _edittxtCodeViolation = TextEditingController(),
      _edittxtCodeGenre = TextEditingController(),
      _edittxtCodeAuteur = TextEditingController(),
      _edittxtCodeEthni = TextEditingController();
  String? Code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un Enquete")),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.remove_red_eye,
                            color: MyColors.primaryColor),
                      ),
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectGenre(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtCodeGenre.text = PubCon.code_genre;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtCodeGenre,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Genre',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez le Genre" : null,
                      //onSaved: (val) => this.Quartier = val,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.remove_red_eye,
                            color: MyColors.primaryColor),
                      ),
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectViolation(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtCodeViolation.text = PubCon.code_violation;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtCodeViolation,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Type Violation',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) => val?.length == 0
                          ? "Selectionnez le Type Violation'"
                          : null,
                      //onSaved: (val) => this.Quartier = val,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.remove_red_eye,
                            color: MyColors.primaryColor),
                      ),
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectEthni(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtCodeEthni.text = PubCon.code_ethni;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtCodeEthni,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Ethni',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez l'Ethni" : null,
                      //onSaved: (val) => this.Quartier = val,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.remove_red_eye,
                            color: MyColors.primaryColor),
                      ),
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectAuteur(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtCodeAuteur.text = PubCon.code_auteur;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtCodeAuteur,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Auteur',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez l'Auteur" : null,
                      //onSaved: (val) => this.Quartier = val,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: saving
                      ? Center(
                          child: CircularProgressIndicator(
                            color: MyColors.primaryColor,
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(130, 40)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  MyColors.primaryColor)),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              try {
                                // setState(() {
                                //   saving = true;
                                // });
                                Glossaire.insert_enquete(context);
                                // setState(() {
                                //   saving = false;
                                // });
                              } catch (e) {
                                // setState(() {
                                //   saving = false;
                                // });
                              }

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Processing....')),
                              // );
                            }
                          },
                          child: const Text('Enregistrer',
                              style: TextStyle(color: Colors.white)),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
