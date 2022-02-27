import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Не удалось получить данные');
  }
}

class Post {
  final int userId, id;
  final String title, body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']
    );
  }

}


class NetworkingScreen extends StatefulWidget {
  const NetworkingScreen({Key? key}) : super(key: key);

  @override
  _NetworkingScreenState createState() => _NetworkingScreenState();
}

class _NetworkingScreenState extends State<NetworkingScreen> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost =fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Заголовок:', style: GoogleFonts.montserrat(fontSize: 28),),
                    Text(snapshot.data!.title, style: GoogleFonts.notoSerif(fontSize: 20),),
                    Text('Сообщение:', style: GoogleFonts.montserrat(fontSize: 28),),
                    Text(snapshot.data!.body, style: GoogleFonts.notoSerif(fontSize: 20),)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}