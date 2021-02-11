import 'package:applicationblog/homePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {

  File sampleImage;
  String _myValue;
  String url;
  final formKey =new GlobalKey<FormState>();


  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage=tempImage;
    });
  }

bool ValidateAndSave()
{
  final form = formKey.currentState;
  if(form.validate())
    {
      form.save();
      return true;
    }
  else
    {
      return false;
    }
}

void uploadStatusImage() async
{
  if(ValidateAndSave())
    {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("image url"+url);
      goToHomePage();
      saveToDataBase(url);
    }
}

void saveToDataBase(url)
{
  var dbtimeKey = new DateTime.now();
  var formatDate = new DateFormat('MMM d, yyyy');
  var formatTime = new DateFormat('EEEE, hh:mm aaa');

  String date = formatDate.format(dbtimeKey);
  String time = formatTime.format(dbtimeKey);

  DatabaseReference ref =FirebaseDatabase.instance.reference();
  var data =
  {
  "image": url,
  "description": _myValue,
  "date": date,
  "time": time,
  };

  ref.child("Posts").push().set(data);
}

void goToHomePage()
{
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context){
        return new HomePage();
      })
  );
}



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar
        (
        title: new Text("Upload Image"),
        centerTitle: true,
      ),
      body: new Center
        (
        child: sampleImage==null? Text("SelectImage"): enableUpload(),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload()
  {
  return Container
    (
    child: new Form
      (
        key: formKey,
        child: Column(
          children: <Widget>
          [
            Image.file(sampleImage, height: 330.0, width: 660,),

            SizedBox(height: 15.0,),

            TextFormField
              (
              decoration: new InputDecoration(labelText: 'Descripton'),
              validator: (value)
              {
                return value.isEmpty ? 'Blog Description is required' : null;
              },
              onSaved: (value)
              {
                return _myValue=value;
              },
            ),
            SizedBox(height: 15.0,),
            RaisedButton
              (
              elevation: 10.0,
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: uploadStatusImage,
              child: Text("ADD NEW POST"),
            )
          ],
        )
    ),
    );
  }
}
