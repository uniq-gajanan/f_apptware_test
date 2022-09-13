import 'package:demo_offline/constants/url_constants.dart';
import 'package:demo_offline/database/daos/post_dao.dart';
import 'package:demo_offline/model/post_response_model.dart';
import 'package:demo_offline/network/reachability.dart';
import 'package:demo_offline/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_offline/network/base_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostResponseModel> postsList = [];
  int offSet = 0;

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postsList.length,
            itemBuilder: (context, index) => listView(index),
          ),
        ));
  }

  Widget listView(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailsScreen(responseModel: postsList[index])));
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.black26),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(postsList[index].id!.toString()),
                const Text("."),
                const SizedBox(width: 8),
                Expanded(child: Text(postsList[index].title.toString())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getPosts() async {
    if (await Reachability.isInternetAvailable() == true) {
      posts().then((value) {
        for(var user in value){
          insertInDB(user.id!,user.title!,user.body!);
        }
        getOfflinePost(offSet);
      }).onError((error, stackTrace) {
        debugPrint("Error ${error.toString()}");
      });
    } else {
      debugPrint("No Internet");
      getOfflinePost(offSet);
    }
  }

  Future<List<PostResponseModel>> posts() {
    return BaseClient.instance
        .get(UrlConstants.post)
        .then((value) => postResponseModelFromJson(value));
  }

  insertInDB(int id,String title,String body)async{
    await PostDAO().insert(PostResponseModel(id:id,title: title,body: body));
  }
 getOfflinePost(int offSet)async{
    var result = await PostDAO().getPost(offSet);
    if(result != null){
      setState(() {
        postsList.addAll(result);
      });

    }
  }
}
