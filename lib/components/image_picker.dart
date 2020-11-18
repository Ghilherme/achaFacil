import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSource extends StatefulWidget {
  const ImagePickerSource(
      {Key key, this.image, this.callback, this.isAvatar = false})
      : super(key: key);
  final String image;
  final bool isAvatar;

  final Function(String) callback;

  @override
  _ImagePickerSourceState createState() => _ImagePickerSourceState(image);
}

class _ImagePickerSourceState extends State<ImagePickerSource> {
  _ImagePickerSourceState(this.image);
  final String image;
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  bool kIsWeb = true;

  @override
  void initState() {
    super.initState();
    if (this.image != null && this.image.isNotEmpty)
      _imageFile = PickedFile(this.image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _previewImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.photo_camera, size: 35, color: Colors.blue),
              onPressed: () {
                showModal(context);
              },
            ),
            Container(width: 20),
            _imageFile == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.cancel, size: 35),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                  ),
          ],
        ),
      ],
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        return widget.isAvatar
            ? CircleAvatar(
                radius: 50,
                backgroundImage: loadImage().image,
              )
            : loadImage();
      } else {
        return Semantics(
            child: widget.isAvatar
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: Image.file(File(_imageFile.path)).image,
                  )
                : Image.file(File(_imageFile.path)),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Container();
    }
  }

  Image loadImage() {
    return Image.network(_imageFile.path, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    });
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> showModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add_a_photo, size: 40, color: Colors.blue),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera, context: context);
                    kIsWeb = false;
                    Navigator.of(context).pop();
                  },
                ),
                Container(width: 20),
                IconButton(
                  icon: Icon(Icons.collections, size: 40, color: Colors.blue),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                    kIsWeb = false;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile =
          await _picker.getImage(source: source, imageQuality: 45);
      setState(() {
        _imageFile = pickedFile;
      });
      if (pickedFile != null) widget.callback(_imageFile.path);
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
}
