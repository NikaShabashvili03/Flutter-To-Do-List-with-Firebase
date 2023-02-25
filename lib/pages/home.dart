import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  late String _userToDo;
  List todoList = [];

  @override
  void initState() {
    super.initState();
    todoList.addAll(['Buy Milk','Wash dishes','buy phone']);
  }


  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Menu'),),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }, child: Text("Main")),
            ],
          ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("To-Do List"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: _menuOpen, icon: Icon(
              Icons.menu_outlined,
            ))
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder(
            stream:FirebaseFirestore.instance.collection('items').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key(snapshot.data!.docs[index].id),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("images/list_bg.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          child: Padding(padding: EdgeInsets.only(left: 60), child:
                          ListTile(
                            title: Text(snapshot.data!.docs[index].get('item'),style: TextStyle(color: Colors.black,),),
                            trailing: IconButton(
                              onPressed: (){
                                FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                              },
                              icon: Icon(
                                Icons.delete_sweep,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                      },
                    );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text("Add new"),
                content: TextField(
                  onChanged: (String value){
                    _userToDo = value;
                  },
                ),
                actions: [
                  ElevatedButton(onPressed: () {
                    FirebaseFirestore.instance.collection('items').add({'item': _userToDo});
                    Navigator.of(context).pop();
                  },
                      child: Text("Add")),
                ],
              );
            });
          },
          child: Icon(
            Icons.add_box,
            color: Colors.white,
          ),
        ),
    );
  }
}
