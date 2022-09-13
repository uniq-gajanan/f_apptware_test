import 'package:demo_offline/model/post_response_model.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  PostResponseModel responseModel;
  DetailsScreen({Key? key, required this.responseModel}) : super(key: key);


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.responseModel.title.toString(),style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 16),
            Text(widget.responseModel.body.toString(),style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal
            ),),
          ],
        ),
      ),
    );
  }
}
