import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http1;

class ApiDemo extends StatefulWidget {
  const ApiDemo({super.key});

  @override
  State<ApiDemo> createState() => _ApiDemoState();
}

class _ApiDemoState extends State<ApiDemo> {
  var data;

  Future getData() async {
    http1.Response response = await http1.get(
      Uri.parse(
        "https://dummyjson.com/products",
      ),
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("Response------>> ${response.body} ");
    } else {
      print("Response---->> ${response.statusCode}");
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: snapshot.data["products"].length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.3,
                    ),
                    itemBuilder: (context, index) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Image.network(
                                "${snapshot.data["products"][index]["thumbnail"]}"),
                          ),
                          Text("id = ${snapshot.data["products"][index]["id"]}",),
                          Text("title = ${snapshot.data["products"][index]["title"]}",),
                          Text("description = ${snapshot.data["products"][index]["description"]}",),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
