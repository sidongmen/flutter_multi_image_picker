import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_image_picker/component/thumbnailImgBox.dart';
import 'package:flutter_multi_image_picker/util/file.dart';
import 'package:storage_path/storage_path.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<FileModel> files;
  List<String> checkedList;
  FileModel selectedModel;
  String image;
  int currentIdx;
  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    currentIdx = -1;
    checkedList = [];
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList() ?? [];
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                        child: Icon(Icons.clear),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<FileModel>(
                      items: getItems(),
                      onChanged: (FileModel d) {
                        assert(d.files.length > 0);
                        image = d.files[0];
                        setState(() {
                          selectedModel = d;
                          checkedList = [];
                          currentIdx = -1;
                        });
                      },
                      value: selectedModel,
                    ))
                  ],
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Next (${checkedList.length})',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, checkedList);
                  },
                ),
              ],
            ),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  children: [
                    image != null
                        ? Image.file(File(image),
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width)
                        : Container(),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            child: Container(
                              child: Center(
                                child: Text(
                                    currentIdx != -1 ? '${currentIdx + 1}' : '',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: currentIdx != -1
                                    ? Colors.blue
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (currentIdx != -1) {
                                  checkedList.removeAt(currentIdx);
                                  currentIdx = -1;
                                } else {
                                  currentIdx = checkedList.length;
                                  checkedList.add(image);
                                }
                              });
                            }))
                  ],
                )),
            Divider(),
            selectedModel == null && selectedModel.files.length < 1
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: GridView.builder(
                      itemCount: selectedModel.files.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0),
                      itemBuilder: (_, i) {
                        var file = selectedModel.files[i];
                        return ThumbnailImgBox(
                          filePath: file,
                          checked: checkedList.indexOf(file),
                          onCheck: (idx) {
                            setState(() {
                              if (idx != -1) {
                                checkedList.removeAt(idx);
                                currentIdx = -1;
                              } else {
                                currentIdx = checkedList.length;
                                checkedList.add(file);
                              }
                              image = file;
                            });
                          },
                          onSelect: (idx) {
                            setState(() {
                              image = file;
                              currentIdx = idx;
                            });
                          },
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}
