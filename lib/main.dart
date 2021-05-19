import 'dart:convert';
import 'package:flutter/material.dart';
import 'newproduct.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(
      title: "App",
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight, screenWidth;
  List _prlist;
  String _titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('My Shop'),
      ),
      body: Center(
        child: Column(children: [
          _prlist == null
              ? Flexible(
                  child: Center(child: Text(_titlecenter)),
                )
              : Flexible(
                  child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (screenWidth / screenHeight) / 0.7,
                    children: List.generate(_prlist.length, (index) {
                      return Padding(
                          padding: EdgeInsets.all(5),
                          child: Card(
                              child: SingleChildScrollView(
                                  child: Column(children: [
                            Container(
                              height: screenHeight / 4.5,
                              width: screenWidth / 1.2,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://hubbuddies.com/271221/myshop/images/product_pictures/${_prlist[index]['prid']}.png",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    new Transform.scale(
                                        scale: 0.5,
                                        child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => new Icon(
                                  Icons.broken_image,
                                  size: screenWidth / 3,
                                ),
                              ),
                            ),
                            Text(_prlist[index]['prname']),
                            Text(_prlist[index]['prtype']),
                            Text("RM " + _prlist[index]['prprice']),
                            Text(_prlist[index]['prqty'] + " unit(s)"),
                          ]))));
                    }),
                  ),
                )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewProductScreen()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _loadProducts() {
    http.post(
        Uri.parse("https://hubbuddies.com/271221/myshop/php/loadproducts.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry, no product available!";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _prlist = jsondata["products"];
        setState(() {});
        print(_prlist);
      }
    });
  }
}
