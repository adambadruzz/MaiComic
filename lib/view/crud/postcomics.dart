import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:maicomic/view/home/home.dart';
import 'package:maicomic/view/login/login.dart';
import 'package:maicomic/viewmodel/maicomic_services.dart';

import '../../model/User.dart';

class PostComics extends StatefulWidget {
  int user;
  PostComics({Key? key, required this.user}) : super(key: key);

  @override
  State<PostComics> createState() => _PostComicsState();
}

class _PostComicsState extends State<PostComics> {
  TextEditingController name = TextEditingController();
  TextEditingController episode = TextEditingController();
  TextEditingController studio = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController description = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        title: const Text(
          'MaiComic',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Poppins Bold',
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Home(user: widget.user),
            ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 23),
            child: Column(
              children: [
                const SizedBox(height: 25),
                TextField(
                  controller: name,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Name',
                    hintText: 'Name',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: episode,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Episode',
                    hintText: 'Episode',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: studio,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Studio',
                    hintText: 'Studio',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: status,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Status',
                    hintText: 'Status',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: type,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Type',
                    hintText: 'Type',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: description,
                  style: const TextStyle(
                    fontFamily: 'Poppins Light',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Description',
                    hintText: 'Description',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins Light',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                imageFile == null
                    ? const Icon(Icons.add_photo_alternate)
                    : Column(
                        children: [
                          SizedBox(
                            width: 500,
                            height: 500,
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                uploadData();
                              },
                              child: const Text('Submit')),
                        ],
                      ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: const Text('Pick From Gallery'),
                ),
              ],
            )),
      ),
    );
  }

  _getFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(
          image.path,
        );
      });
    }
  }

  uploadData() async {
    Dio dio = Dio();
    var Emu = ComicService().Emu; //Emu //No Respond HP

    //db.json
    var baseUrlApi = ComicService().baseUrlApi; //Kos
    // var baseUrlApi = 'http://192.168.30.64:3000'; //`Hp
    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile!.path),
    });
    var response = await dio.post('$Emu/upload', data: formData);
    var cover = response.data.toString();
    cover = cover.replaceAll(RegExp('[{name: }]'), '');

    debugPrint(cover);

    var episodes = int.parse(episode.text);
    var studios = int.parse(studio.text);

    Map<String, dynamic> uploadDataData = {
      'cover': 'assets/images/Cover/$cover',
      'name': name.text,
      'episode': episodes,
      'studioId': studios,
      'status': status.text,
      'type': type.text,
      'description': description.text,
      "isFavorite": false,
    };
    var responseApi =
        await dio.post('$baseUrlApi/comics', data: uploadDataData);
    debugPrint(responseApi.data.toString());

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
