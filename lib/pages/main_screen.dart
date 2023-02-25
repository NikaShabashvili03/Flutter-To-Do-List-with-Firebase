import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
        title: Text("To-Do List"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Main Screen", style: TextStyle(color: Colors.white, fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/todo');
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(120,20)),
                child: Text("Next"),),
            ],
          )
        ],
      ),
    );
  }
}
