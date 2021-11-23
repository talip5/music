import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final ImagePicker _picker = ImagePicker();
  var _image;
  String title1='deneme';

  Future<void> listExample1() async {
    FirebaseStorage storage=FirebaseStorage.instance;
    ListResult result = await storage.ref().child('user').listAll();
   // ListResult result = await storage.ref().listAll();
    //print(result.prefixes.last.name);  // veli
    //print(result.prefixes.last.bucket);  //cloud2-f6bda.appspot.com
    //print(result.prefixes.last.fullPath);  //user?veli
    //print(result.prefixes.last.root.name);  //
    // print(result.storage); //   FirebaseStorage(app: [DEFAULT], bucket: cloud2-f6bda.appspot.com)
    result.items.forEach((Reference ref) {
      print('Found file : $ref');
    });
    result.prefixes.forEach((Reference ref) {
      //print(ref.name.runtimeType);
      //print('Found directory : $ref.');
      String directoryName=ref.name;
      print(directoryName);
    });
  }

  Future<void> listExample2() async {
    FirebaseStorage storage=FirebaseStorage.instance;
    ListResult result = await storage.ref().child('user').list(ListOptions(maxResults: 15));
     result.items.forEach((Reference ref) {
     print('Found file : $ref');
    });
    result.prefixes.forEach((Reference ref) {
      //print(ref.name.runtimeType);
      //print('Found directory : $ref.');
      String directoryName=ref.name;
      print(directoryName);
    });
  }

  Future<void> listExample() async {
    FirebaseStorage storage=FirebaseStorage.instance;
    ListResult result = await storage.ref().child('user').list(ListOptions(maxResults: 5));
    if(result.nextPageToken !=null){
      ListResult additionalResults=await storage.ref().list(ListOptions(maxResults: 5,pageToken: result.nextPageToken));
      additionalResults.prefixes.forEach((Reference ref) {
        print(ref.name);
      });
    }

    /*result.items.forEach((Reference ref) {
      print('Found file : $ref');
    });
    result.prefixes.forEach((Reference ref) {
      //print(ref.name.runtimeType);
      //print('Found directory : $ref.');
      String directoryName=ref.name;
      print(directoryName);
    });*/
  }

  Future<void> downloadURLExample() async {
    FirebaseStorage storage=FirebaseStorage.instance;
   String downloadURL=await storage.ref('user/profil435.png').getDownloadURL();
   print(downloadURL);
  }

  Future<void> uploadExample() async{
    //Directory appDocDir=await getApplicationDocumentsDirectory(); //Directory: '/data/user/0/com.example.music/app_flutter'
   // Directory? appDocDir= await getApplicationSupportDirectory(); //Directory: '/data/user/0/com.example.music/files'
   // Directory? appDocDir= await getLibraryDirectory(); //  Unsupported operation: Functionality only available on iOS/macOS
    //Directory? appDocDir= await getTemporaryDirectory(); //Directory: '/data/user/0/com.example.music/cache'
    //Directory? appDocDir= await getExternalStorageDirectory(); //Directory: '/storage/emulated/0/Android/data/com.example.music/files'
    //Directory? appDocDir= await getExternalStorageDirectory();
    //String filePath='${appDocDir.absolute}/file-to-up;oad.png';
   //String appDocDir5='/storage/emulated/0/Android/data/com.example.music/files';
    //String appDocDir5='/storage/emulated/0/Android/data/com.example.music';
    //String appDocDir5='/storage';  // Directory: '/storage/18EF-4207' //Directory: '/storage/emulated' //Directory: '/storage/self'
    List contents=[];
    String appDocDir5='/storage/emulated/0/Android/data/com.example.music';
    final Directory _appDocDirFolder = Directory('${appDocDir5}');
    contents=_appDocDirFolder.listSync();
      contents= _appDocDirFolder.listSync();
      print(contents.length);
      contents.forEach((element) {
        print(element);
      });
      //print(appDocDir);
      //uploadFile(filePath);
    }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    FirebaseStorage storage=FirebaseStorage.instance;
    try {
      await storage.ref('uploads/file-to-upload.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 // listExample();
    //downloadURLExample();
   uploadExample();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'music',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title1),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Music'),
              ElevatedButton(
                  onPressed: () async{
                    print('image Galery');
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
                    setState(() {
                      _image = File(image!.path);
                      title1=_image.toString();
                    });
                    print(image!.path);
                    FirebaseStorage storage=FirebaseStorage.instance;
                    //Reference ref=storage.ref().child('user').child('Galeri735').child('profil735.png');
                    Reference ref=storage.ref().child('user').child('profil435.png');
                    UploadTask uploadTask=ref.putFile(_image);
                    var uri=await(await uploadTask.whenComplete(() => ref.getDownloadURL()));
                    print(uri);
                    //print(image!.path);
                    print('Galeri');
                    print(_image);
                  },
                  child: Text('image Galery'),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                  _image,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
                    : Container(
                  decoration: BoxDecoration(color: Colors.red[200]),
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                      preferredCameraDevice: CameraDevice.front);
                  setState(() {
                    _image = File(image!.path);
                    title1=_image.toString();
                    print(_image);
                  });
                  print('Kamera');
                },
                child: Text('Kameradan resim yukleme'),
              ),
              ElevatedButton(
                onPressed: () async {
                 listExample();
                  print('List');
                },
                child: Text('List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
