import 'dart:io';
import 'package:flutter/material.dart';

class ThumbnailImgBox extends StatelessWidget {
  final String filePath;
  final Function onCheck;
  final Function onSelect;
  final int checked;
  ThumbnailImgBox(
      {@required this.filePath,
      @required this.checked,
      @required this.onCheck,
      @required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
          children: [
            Image.file(
              File(filePath),
              width: 200,
              height: 200,
              cacheHeight: 90,
              cacheWidth: 90,
              fit: BoxFit.cover,
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    child: Container(
                      child: Center(
                        child: Text(checked != -1 ? '${checked + 1}' : '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: checked != -1 ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () => onCheck(checked)))
          ],
        ),
        onTap: () => onSelect(checked));
  }
}
