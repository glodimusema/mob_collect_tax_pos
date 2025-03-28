import 'package:flutter/material.dart';
import 'package:mob_collect_tax_pos/Home/search_menage.dart';
import 'package:mob_collect_tax_pos/Home/select_annee.dart';
import 'package:mob_collect_tax_pos/Home/select_mois.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mob_collect_tax_pos/Home/select_entreprise.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_glossaire.dart';
import 'package:mob_collect_tax_pos/MyClasses/pub_con.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddRecette extends StatefulWidget {
  const AddRecette({Key? key}) : super(key: key);

  @override
  State<AddRecette> createState() => _AddRecetteState();
}

class _AddRecetteState extends State<AddRecette> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool saving = false, charging = false;
  TextEditingController _edittxtMontant = TextEditingController(),
      cCode = TextEditingController(),
      _edittxtDesignation = TextEditingController(),
      _edittxtDesignationMois = TextEditingController(),
      _edittxtDesignationAnnee = TextEditingController();
  String? Code = "";

  void getCode() async {
    if (_formKey1.currentState!.validate()) {
      try {
        setState(() {
          charging = true;
          _edittxtDesignation.text = "";
          _edittxtMontant.text = "";
          PubCon.DesignationEntreprise = "";
          PubCon.PrixEntreprise = "";
        });
        await Glossaire.getEseByCode(_scaffoldKey, context, cCode.text);

        setState(() {
          _edittxtDesignation.text = PubCon.DesignationEntreprise;
          _edittxtMontant.text = PubCon.PrixEntreprise;
          charging = false;
        });
      } catch (e) {
        setState(() {
          charging = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un paiement")),
      body: ListView(
        children: [
          Form(
            key: _formKey1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                        onTap: (() async {
                          // Code = await scanner.scan();
                          // cCode.text=Code.toString();
                          try {
                            await Permission.camera.request();
                            final qrCode = await scanner.scan();
                            setState(() {
                              this.Code = qrCode;
                              cCode.text = Code.toString();
                            });
                            getCode();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erreur de scan!')),
                            );
                          }
                        }),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child:
                              Icon(Icons.qr_code, color: MyColors.primaryColor),
                        )),
                    title: TextFormField(
                      controller: cCode,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Code du Menage',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Tapez ou scanner le code" : null,
                      onSaved: (val) => this.Code = val,
                    ),
                  ),
                ),
                Container(
                  child: Divider(
                    color: Colors.blue.shade400,
                  ),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: charging
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
                            //get the code
                            getCode();
                          },
                          child: const Text(
                            'Charger',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
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
                            builder: (context) => searchpage(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtDesignation.text =
                                PubCon.DesignationEntreprise;
                            _edittxtMontant.text = PubCon.PrixEntreprise;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtDesignation,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Menage',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez le menage'" : null,
                      //onSaved: (val) => this.Quartier = val,
                    ),
                  ),
                ),
                Container(
                  child: Divider(
                    color: Colors.blue.shade400,
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(4.0),
                    trailing: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.money, color: Colors.white),
                      ),
                    ),
                    title: TextFormField(
                      controller: _edittxtMontant,
                      enabled: false,
                      validator: (value) {
                        try {
                          double x = double.parse(value!);
                          if (value.toString() == "" || value.isEmpty) {
                            return 'Entrer le montant en dollars (in \$ ).';
                          }
                        } catch (e) {
                          return 'Attention! Mauvais format du montant décimal.';
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Color(0xff49A2B6)),
                      decoration: InputDecoration(
                          labelText: 'Montant en \$',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                    ),
                  ),
                ),
                Container(
                  child: Divider(
                    color: Colors.blue.shade400,
                  ),
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
                            builder: (context) => SelectMois(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtDesignationMois.text =
                                PubCon.DesignationMois;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtDesignationMois,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Mois',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez le Mois'" : null,
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
                            builder: (context) => SelectAnnee(),
                          ),
                        ).then((value) {
                          setState(() {
                            _edittxtDesignationAnnee.text =
                                PubCon.DesignationAnnee;
                          });
                        });
                      }),
                    ),
                    title: TextFormField(
                      enabled: false,
                      controller: _edittxtDesignationAnnee,
                      cursorColor: Colors.black,
                      cursorWidth: 4,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          labelText: 'Année',
                          labelStyle:
                              TextStyle(color: Color(0xff49A2B6), fontSize: 20),
                          border: new OutlineInputBorder(),
                          focusedBorder: new OutlineInputBorder()),
                      validator: (val) =>
                          val?.length == 0 ? "Selectionnez l'Année" : null,
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
                                setState(() {
                                  saving = true;
                                });
                                Glossaire.insert_recette(
                                    context, _edittxtMontant.text);

                                setState(() {
                                  saving = false;
                                });
                              } catch (e) {
                                setState(() {
                                  saving = false;
                                });
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
