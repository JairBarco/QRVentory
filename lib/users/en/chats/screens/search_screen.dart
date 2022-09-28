import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/chats/screens/chats_screen.dart';
import '../../global/global.dart';


class SearchScreen extends StatefulWidget {
  String user;
  SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult =[];
  bool isLoading = false;

  void onSearch()async{
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where("name",isEqualTo: searchController.text).get().then((value){
       if(value.docs.length < 1){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User Found")));
            setState(() {
      isLoading = false;
    });
    return;
       }
       value.docs.forEach((user) {
          if(user.data()['email'] != fAuthUser.currentUser!.email){
               searchResult.add(user.data());
          }
        });
     setState(() {
      isLoading = false;
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization().search),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
           Row(
             children: [
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: TextField(
                     controller: searchController,
                     decoration: InputDecoration(
                       hintText: AppLocalization().typeUsername,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10)
                       )
                     ),
                   ),
                 ),
               ),
               IconButton(onPressed: (){
                  onSearch();
               }, icon: Icon(Icons.search))
             ],
           ),
           if(searchResult.length > 0)
              Expanded(child: ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(searchResult[index]['name']),
                    subtitle: Text(searchResult[index]['email']),
                    trailing: IconButton(onPressed: () async{
                      final friendInfoMap = {
                        "name": searchResult[index]['name'],
                        "email": searchResult[index]['email'],
                        "id": searchResult[index]['id'],
                        "phone": searchResult[index]['phone'],
                      };
                      DocumentReference ref = FirebaseFirestore.instance.collection('users')
                          .doc(fAuthUser.currentUser!.uid).collection('friends').doc(searchResult[index]['id']);
                      ref.set(friendInfoMap);

                      Navigator.push(context, MaterialPageRoute(builder: (c) => ChatsScreen()));
                    }, icon: Icon(Icons.add)),
                  );
                }))
           else if(isLoading == true)
              Center(child: CircularProgressIndicator(),)
        ],
      ),
      
    );
  }
}