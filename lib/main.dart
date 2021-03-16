import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    color: Colors.cyan[300],
    title: "covid_tracker",
    home: homepage(),
  ));
}

class homepage extends StatefulWidget {
  @override
  homeState createState() => homeState();
}

class homeState extends State<homepage> {
  Future<List> dataset;
  Future<Map> predata;
  Future<Map> getData() async {
    var response =
        await Dio().get("https://api.rootnet.in/covid19-in/stats/latest");
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    predata = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent[300],
        title: Text("covid_tracker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Newspage()));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: predata,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: SweepGradient(colors: [
                      Colors.blue[50],
                      Colors.blue[100],
                      Colors.blue[200]
                    ]),
                  ),
                  width: double.infinity,
                  height: 100,
                  child: Card(
                      color: Colors.white,
                      elevation: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: SweepGradient(colors: [
                            Colors.blue[50],
                            Colors.blue[100],
                            Colors.blue[200]
                          ]),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data["data"]["regional"][index]["loc"]
                                    .toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("TOTAL-CONFIRMED"),
                                  Text(
                                    snapshot.data["data"]["regional"][index]
                                            ["totalConfirmed"]
                                        .toString(),
                                    style: TextStyle(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("TOTAL-DEATHS"),
                                  Text(
                                    snapshot.data["data"]["regional"][index]
                                            ["deaths"]
                                        .toString(),
                                    style: TextStyle(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
              itemCount: snapshot.data["data"]["regional"].length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

var _controller = TextEditingController();

class Newspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://r1.ilikewallpaper.net/iphone-x-wallpapers/download/38891/blue-gradient-iphone-x-wallpaper-ilikewallpaper_com.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue[100],
            ),
            height: 250,
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Simp!y News",
                  style: TextStyle(fontFamily: "Comic Sans MS", fontSize: 28),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                FlatButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => newspage(
                              query: _controller.text,
                            )));
                  },
                )
              ],
            ),
          ))),
    );
  }
}

class newspage extends StatefulWidget {
  var query;

  newspage({this.query});
  _newState createState() => _newState();
}

class _newState extends State<newspage> {
  var Query = _controller.text;
  Future<Map> news;
  Future<Map> getData() async {
    var response = await Dio().get("https://newsapi.org/v2/everything?q=" +
        Query +
        "&apiKey=dc592e81074a47e2ab160b7803904c0b");
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    news = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: news,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data["articles"].length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data["articles"][index]["title"]),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
