import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Image.network(
          _gifData["images"]["fixed_height"]["url"],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _appBar() => AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _gifData["title"],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
        centerTitle: true,
      );
}
