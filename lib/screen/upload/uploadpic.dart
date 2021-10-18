import 'dart:convert';
import 'dart:io';
import 'package:LAP/screen/profile.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:LAP/utilities/function.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class UploadPic extends StatefulWidget {
  @override
  _UploadPicState createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      /*toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It'*/
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() => showModalBottomSheet(
          enableDrag: false,
          // isDismissible: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          barrierColor: Colors.grey.withOpacity(0.35),
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo_outlined),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_imageFile != null) ...[
                ListTile(
                  leading: Icon(Icons.crop),
                  title: Text('Crop'),
                  onTap: _cropImage,
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                  onTap: _clear,
                ),
              ]
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Picture',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),

      // Preview the image and crop it
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_imageFile == null)
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "$ROOT_URL/file/image/" +
                                      accountInfo["account_id"].toString()),
                              backgroundColor: Colors.transparent,
                              radius: 120,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: RawMaterialButton(
                                  onPressed: showBottomSheet,
                                  elevation: 2.0,
                                  fillColor: Color(0xFFF5F6F9),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      if (_imageFile != null) ...[
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: FileImage(_imageFile),
                              radius: 120,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: RawMaterialButton(
                                  onPressed: showBottomSheet,
                                  elevation: 2.0,
                                  fillColor: Color(0xFFF5F6F9),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      ] else
                        ...[],
                    ],
                  ),

                  // SizedBox(height: 20,),
                  /*Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 111,
                          height: 50,
                          child: FlatButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            color: Color.fromRGBO(13, 68, 148, 1),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.photo_camera, size: 30, color: Colors.white,),
                                Text("Camera", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 111,
                          height: 50,
                          child: FlatButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            color: Color.fromRGBO(13, 68, 148, 1),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.photo_camera, size: 30, color: Colors.white,),
                                Text("Gallery", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),*/
                  // SizedBox(height: 20,),

/*                  if (_imageFile != null) ...[Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 111,
                          height: 50,
                          child: FlatButton(
                            onPressed: _cropImage,
                            color: Color.fromRGBO(13, 68, 148, 1),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.crop, size: 30, color: Colors.white,),
                                Text("Crop", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 111,
                          height: 50,
                          child: FlatButton(
                            onPressed: _clear,
                            color: Color.fromRGBO(13, 68, 148, 1),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.delete, size: 30, color: Colors.white,),
                                Text("Delete", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),

*/ /*                        FlatButton(
                          color: Color.fromRGBO(13, 68, 148, 1),
                          child: Icon(
                            Icons.crop,
                            color: Colors.white,
                          ),
                          onPressed: _cropImage,
                        ),
                        FlatButton(
                          color: Color.fromRGBO(13, 68, 148, 1),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: _clear,
                        ),*/ /*
                      ],
                    ),
                  ] else
                    ...[],*/
                ],
              ),
            ),
          ),
          Container(
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  Upload(_imageFile);
                  imageCache.clear();
                  imageCache.clearLiveImages();
                  Navigator.of(context).pop(MaterialPageRoute(
                    builder: (context) => Profile(),
                  ));
                });
              },
              padding: EdgeInsets.all(0.0),
              child: Ink(
                color: Color.fromRGBO(13, 68, 148, 1),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Upload",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Upload(File imageFile) async {
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var url = ROOT_URL + "/file/upload";
  var uri = Uri.parse(url);

  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));
  //contentType: new MediaType('image', 'png'));

  request.files.add(multipartFile);
  request.fields['accountID'] = accountInfo["account_id"];
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}
