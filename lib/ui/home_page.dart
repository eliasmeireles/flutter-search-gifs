import 'package:flutter/material.dart';
import 'package:funny_giphy/service/giphy_service.dart';
import 'package:share/share.dart';

import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GiphyService giphyService;
  final searchController = TextEditingController();
  int _offSet = 0;
  bool searching = false;
  String url = trending();

  @override
  void initState() {
    super.initState();
    giphyService = GiphyService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _appBody(),
      backgroundColor: Colors.black,
    );
  }

  Widget _appBar() => AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      );

  Widget _appBody() => Column(
        children: <Widget>[
          _searchTextField(),
          _bodyContainer(),
        ],
      );

  Widget _bodyContainer() => Expanded(
        child: FutureBuilder(
            future: giphyService.getGiphys(url),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return _loading();
                default:
                  if (snapshot.hasError) {
                    return _errorContainer();
                  }
                  return _giphyTable(context, snapshot);
              }
            }),
      );

  Widget _errorContainer() => Container(
        alignment: Alignment.center,
        width: 250.0,
        child: Text(
          "Could not complete the service, please try again!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );

  Widget _giphyTable(BuildContext context, AsyncSnapshot snapshot) =>
      GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5,
        ),
        itemCount: _getDataCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          return getItem(snapshot, index);
        },
      );

  // ignore: missing_return
  Widget getItem(AsyncSnapshot snapshot, int index) {
    if (!searching || index < snapshot.data["data"].length) {
      return GestureDetector(
        child: FadeInImage.assetNetwork(
          placeholder: "images/loader.gif",
          image: _getGiphyUrl(snapshot, index),
          height: 300.0,
          fit: BoxFit.cover,
        ),
        onLongPress: () {
          Share.share(_getGiphyUrl(snapshot, index));
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GifPage(snapshot.data["data"][index])),
          );
        },
      );
    } else {
      return Container(
        child: searching && snapshot.data["data"].length > 1
            ? _seeMoreGifs()
            : Container(),
      );
    }
  }

  GestureDetector _seeMoreGifs() => GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
              size: 70,
            ),
            Text(
              "See more...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            )
          ],
        ),
        onTap: () {
          setState(() {
            _offSet += 19;
            url = search(url, offset: _offSet);
            searching = true;
          });
        },
      );

  _getDataCount(List data) {
    return !searching ? data.length : data.length + 1;
  }

  _getGiphyUrl(AsyncSnapshot snapshot, int index) =>
      snapshot.data["data"][index]["images"]["fixed_height"]["url"];

  Widget _searchTextField() => Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
          onSubmitted: (text) {
            if (text != null && text.isNotEmpty) {
              setState(() {
                _offSet = 0;
                url = search(text);
                searching = true;
              });
            } else {
              url = trending();
              setState(() {
                _offSet = 0;
                searching = false;
              });
            }
          },
          decoration: InputDecoration(
            labelText: "Search here",
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      );

  Widget _loading() => Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 5.0,
        ),
      );
}
