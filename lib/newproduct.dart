import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'main.dart';

class NewProductScreen extends StatefulWidget {
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  ProgressDialog pr;
  double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.png';
  File _image;
  bool _visible = true;
  TextEditingController _prnameController = new TextEditingController();
  TextEditingController _prtypeController = new TextEditingController();
  TextEditingController _prpriceController = new TextEditingController();
  TextEditingController _prqtyController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("KB" + visible.toString());
        if (visible) {
          _visible = false;
        } else {
          _visible = true;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Visibility(
          visible: _visible,
          child: FloatingActionButton.extended(
            label: Text('Post'),
            onPressed: () {
              _postProductDialog();
            },
            icon: Icon(Icons.add),
            backgroundColor: Colors.orange,
          )),
      body: Center(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text("Post Your New Product",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {_onPictureSelectionDialog()},
                    child: Container(
                        height: screenHeight / 2.5,
                        width: screenWidth / 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image),
                            fit: BoxFit.scaleDown,
                          ),
                        )),
                  ),
                  SizedBox(height: 5),
                  Text("Click image to take your product picture",
                      style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      maxLength: 100,
                      // ignore: deprecated_member_use
                      maxLengthEnforced: true,
                      controller: _prnameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Name',
                        hintText: 'Enter Product Name',
                      ),
                      onChanged: (_prnameController) {
                        if (_prnameController.isEmpty) {
                          setState(() {});
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      maxLength: 50,
                      // ignore: deprecated_member_use
                      maxLengthEnforced: true,
                      controller: _prtypeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Type',
                        hintText: 'Enter Product Type',
                      ),
                      onChanged: (_prtypeController) {
                        if (_prtypeController.isEmpty) {
                          setState(() {});
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _prpriceController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                        hintText: 'Price (RM)',
                      ),
                      onChanged: (_prpriceController) {
                        if (_prpriceController.isEmpty) {
                          setState(() {});
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _prqtyController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                        hintText: 'Quantity',
                      ),
                      onChanged: (_prqtyController) {
                        if (_prqtyController.isEmpty) {
                          setState(() {});
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ))),
        ),
      ),
    );
  }

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        color: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        color: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _postProductDialog() {
    String _prname = _prnameController.text.toString();
    String _prtype = _prtypeController.text.toString();
    String _prprice = _prpriceController.text.toString();
    String _prqty = _prqtyController.text.toString();

    if (_image == null ||
        _prname.isEmpty ||
        _prtype.isEmpty ||
        _prprice.isEmpty ||
        _prqty.isEmpty) {
      Fluttertoast.showToast(
          msg: "Image/product details is empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Post your product?"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postProduct(_prname, _prtype, _prprice, _prqty);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _postProduct(
      String prname, String prtype, String prprice, String prqty) async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Posting...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String prname = _prnameController.text.toString();
    String prtype = _prtypeController.text.toString();
    String prprice = _prpriceController.text.toString();
    String prqty = _prqtyController.text.toString();
    http.post(
        Uri.parse("https://hubbuddies.com/271221/myshop/php/newproduct.php"),
        body: {
          "prname": prname,
          "prtype": prtype,
          "prprice": prprice,
          "prqty": prqty,
          "encoded_string": base64Image
        }).then((response) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print(response.body);
      if (response.body == "Success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _image = null;
          _prnameController.text = "";
          _prtypeController.text = "";
          _prpriceController.text = "";
          _prqtyController.text = "";
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MyApp()));
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
