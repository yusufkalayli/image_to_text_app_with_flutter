// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";
  late File image;
  late Future<File> imageFile;
  late ImagePicker imagePicker;

  GaleridenSec() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    image = File(pickedFile.path);

    setState(() {
      image;

      performImageLabeling();
    });
  }

  FotoCek() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);

    image = File(pickedFile.path);

    setState(() {
      image;

      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text;

        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += "${element.text} ";
          }
        }

        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    super.initState();

    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.jgp'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            Container(
              height: 280,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/note.jgp'), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/pin.png',
                          height: 240,
                          width: 240,
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        GaleridenSec();
                      },
                      onLongPress: () {
                        FotoCek();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: image != null
                            ? Image.file(
                                image,
                                width: 140,
                                height: 190,
                                fit: BoxFit.fill,
                              )
                            : const SizedBox(
                                width: 240,
                                height: 200,
                                child: Icon(
                                  Icons.camera_front,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
