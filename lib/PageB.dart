import 'package:flutter/material.dart';
import 'MyCard.dart';
import 'main.dart';



class PageB extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page B'),
      ),
        body: Center(
          child: Column(
            children: [
              Text("Sayfa B",style: TextStyle(fontSize: 30),),
            ],
          ),
        )

    );
  }
}

