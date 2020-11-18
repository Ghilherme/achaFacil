import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSource extends StatefulWidget {
  const ImagePickerSource({Key key, this.image, this.callback})
      : super(key: key);
  final String image;

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
              icon: Icon(Icons.photo_camera, size: 40, color: Colors.blue),
              onPressed: () {
                showModal(context);
              },
            ),
            Container(width: 20),
            _imageFile == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.cancel, size: 40),
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
        return Image.network(_imageFile.path);
      } else {
        return Semantics(
            child: Image.file(File(_imageFile.path)),
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
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    } finally {
      widget.callback(_imageFile.path);
    }
  }
}
