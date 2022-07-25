// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// get request from https://api.github.com/users/adgsenpai/repos store in list of repos
// print the name of the repo

void main() {
  runApp(new MaterialApp(home: new HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  GitHubState createState() => new GitHubState();
}

class GitHubState extends State<HomePage> {
  late List _data = [];
  bool isLoading = true;
  Future<String> getData() async {
    var response = await http.get(Uri.parse(
        'https://api.github.com/users/adgsenpai/repos?per_page=10000'));
    setState(() {
      _data = json.decode(response.body);
      isLoading = false;
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('@adgsenpai GitHub Repos'))
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(_data[index]["html_url"]));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _data[index]["name"],
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.blue),
                          ),
                          Text(
                            _data[index]["html_url"],
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Row(children: [
                            Text(
                              _data[index]["stargazers_count"].toString(),
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ]),
                          Row(children: [
                            Text(
                              _data[index]["forks_count"].toString(),
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.call_split,
                              color: Colors.grey,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
