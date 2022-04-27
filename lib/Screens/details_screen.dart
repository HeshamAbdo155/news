import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Details extends StatefulWidget {
  final String? url;

  const Details({Key? key, this.url}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffff2b2e44),
        title: const Text(
          'News',
          style: TextStyle(
              color: Colors.yellow, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: WebviewScaffold(
          url: widget.url!,
          scrollBar: true,
          initialChild: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
