import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualizador de Imagenes',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Imagenes desde API'),
        ),
        body: FutureBuilder<List<ImageData>>(
          future: fetchImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var image = snapshot.data![index];
                return ListTile(
                  title: Text(image.title),
                  leading: Image.network(image.url, width: 100, height: 100),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<ImageData>> fetchImages() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map((json) => ImageData.fromJson(json)).toList();
    } else {
      throw Exception('Fallo en cargar imagenes');
    }
  }
}

class ImageData {
  final String url;
  final String title;

  ImageData({required this.url, required this.title});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['thumbnailUrl'], 
      title: json['title'],
    );
  }
}
