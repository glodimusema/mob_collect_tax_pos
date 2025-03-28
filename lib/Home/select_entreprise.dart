import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mob_collect_tax_pos/MyClasses/pub_con.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectEntreprise extends StatefulWidget {
  const SelectEntreprise({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectEntreprise> createState() => _SelectEntrepriseState();
}

class _SelectEntrepriseState extends State<SelectEntreprise> {
  bool isExpandedo = false;
  bool isExpandedo1 = true;
  // We will fetch data from this Rest api
  final _baseUrl = '${PubCon.cheminApi}fetch_list_contribuable/';

  // At the beginning, we fetch the first 20 posts
  int _page = 0;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 10;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
          await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

      setState(() {
        _posts = json.decode(res.body)['data'];
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong...');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res =
            await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body)['data'];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

    isExpandedo = false;
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

//Perform search
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Entreprise'),
        ),
        body: _isFirstLoadRunning
            ? const Center(
                child: const CircularProgressIndicator(
                  color: Color.fromARGB(255, 70, 129, 196),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: _posts.length,
                      itemBuilder: (_, index) => Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              PubCon.refEntreprise = _posts[index]['id'];
                              PubCon.DesignationEntreprise =
                                  _posts[index]['colNom_Ese'];
                              PubCon.PrixEntreprise =
                                  "${_posts[index]['prix_categorie']}";
                            });

                            if (Navigator.canPop(context)) {
                              Navigator.pop(
                                  context, PubCon.DesignationEntreprise);
                            } else {
                              SystemNavigator.pop();
                            }
                          },
                          child: ListTile(
                            title: Text(_posts[index]['colNom_Ese']),
                            subtitle: Text(
                                "${_posts[index]['colGenreActivite_Ese']}\nMontant: ${_posts[index]['prix_categorie']}"),
                            trailing: IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                setState(() {
                                  PubCon.refEntreprise = _posts[index]['id'];
                                  PubCon.DesignationEntreprise =
                                      _posts[index]['colNom_Ese'];
                                  PubCon.PrixEntreprise =
                                      _posts[index]['prix_categorie'];
                                });

                                if (Navigator.canPop(context)) {
                                  Navigator.pop(
                                      context, PubCon.DesignationEntreprise);
                                } else {
                                  SystemNavigator.pop();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // when the _loadMore function is running
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 70, 129, 196)),
                      ),
                    ),

                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Colors.amber,
                      child: const Center(
                        child: Text('You have fetched all of the content...'),
                      ),
                    ),
                ],
              ));
  }
}
