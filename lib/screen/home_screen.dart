import 'package:demo_offline/constants/url_constants.dart';
import 'package:demo_offline/database/daos/post_dao.dart';
import 'package:demo_offline/model/post_response_model.dart';
import 'package:demo_offline/network/reachability.dart';
import 'package:demo_offline/screen/details_screen.dart';
import 'package:demo_offline/screen/loader.dart';
import 'package:flutter/material.dart';
import 'package:demo_offline/network/base_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<PostResponseModel> postsList = [];
  int offSet = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        debugPrint("scroll is $offSet");
        offSet++;
        setState((){
          isLoading = true;
        });
        getOfflinePost(offSet);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Loader(isCallInProgress: isLoading, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
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
      setState((){
        isLoading = true;
      });
      posts().then((value) {
        for (var user in value) {
          insertInDB(user.id!, user.title!, user.body!);
        }
        getOfflinePost(offSet);
        setState((){
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState((){
          isLoading = false;
        });
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

  insertInDB(int id, String title, String body) async {
    await PostDAO().insert(PostResponseModel(id: id, title: title, body: body));
  }

  getOfflinePost(int offSet) async {
    var result = await PostDAO().getPost(offSet);
    if (result != null) {
      setState(() {
        postsList.addAll(result);
      });
    }
    setState((){
      isLoading = false;
    });
  }
}
