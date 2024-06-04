import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/content_item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditContentScreen extends StatefulWidget {
  final ContentItem contentItem;

  EditContentScreen({required this.contentItem});

  @override
  _EditContentScreenState createState() => _EditContentScreenState();
}

class _EditContentScreenState extends State<EditContentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentTextController;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.contentItem.title);
    _contentTextController = TextEditingController(text: widget.contentItem.contentText);
    _imageBase64 = widget.contentItem.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  Future<void> _updateContentItem() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:5001/api/Courses/UpdateContentItem'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contentItemId': widget.contentItem.contentItemId,
        'title': _titleController.text,
        'contentText': _contentTextController.text,
        'imageUrl': _imageBase64,
        'order': widget.contentItem.order,
        'isDeleted': widget.contentItem.isDeleted,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Контент успешно обновлен')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при обновлении контента')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = File(pickedFile.path).readAsBytesSync();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать контент'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Заголовок'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите заголовок';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentTextController,
                decoration: InputDecoration(labelText: 'Текст контента'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите текст контента';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Выбрать изображение'),
              ),
              if (_imageBase64 != null && (_imageBase64?.length ?? 0) > 100)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.memory(base64Decode(_imageBase64!)),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateContentItem();
                  }
                },
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
