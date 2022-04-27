import 'package:flutter/material.dart';
import 'package:news/Models/News.dart';
import 'package:news/Network/NewsApi.dart';
import 'package:news/Screens/details_screen.dart';
import 'package:news/components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String country = 'eg';
  int selected = 0;
  bool isVisible = false;
  int chosenIndex = 0;
  Future<News>? futureArticle;

  @override
  void initState() {
    super.initState();
    NewsApi api = NewsApi(category: 'general', country: 'eg');
    futureArticle = api.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffff2B2E44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'News App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      iconSize: 30,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                      hint: const Text(
                        'Choose Country',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: <String>['Egypt', 'Brazil', 'France', 'Australia']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (selectedCounty) {
                        setState(() {
                          country =
                              selectedCounty!.toLowerCase().substring(0, 2);
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                                chosenIndex = index;
                              });
                            },
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          AssetImage(photos[index]),
                                    ),
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: selected == index
                                              ? Colors.black54
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: selected == index
                                                  ? Colors.pink
                                                  : Colors.transparent,
                                              width: 2)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${categories[index]}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              FutureBuilder(
                future:
                    NewsApi(country: country, category: categories[chosenIndex])
                        .fetchArticles(),
                builder: (context, AsyncSnapshot<News> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Expanded(
                        flex: 5,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  snapshot.data!.articles![index].urlToImage ==
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            height: 200,
                                            width: double.infinity,
                                            child: const Image(
                                                height: 200,
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    'image/general.jpg')),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Details(
                                                          url: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .url!,
                                                        )));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: Image(
                                                  height: 200,
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    "${snapshot.data!.articles![index].urlToImage}",
                                                  ),
                                                )),
                                          ),
                                        ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${snapshot.data!.articles![index].title}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data!.articles!.length,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
