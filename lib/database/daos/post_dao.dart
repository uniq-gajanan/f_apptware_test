import 'package:demo_offline/database/database_helper.dart';
import 'package:demo_offline/model/post_response_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class PostDAO {
  static const tableName = "post_table";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(PostResponseModel model) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id,title,body) VALUES (?,?,?)",
          [model.id, model.title, model.body]);
      return result;
    } catch (error) {
      debugPrint("error ${error.toString()}");
    }
  }

  Future<List<PostResponseModel>?> getPost(int offSet)async{
    try{
      final db = await _db;
      var result = await db.rawQuery("SELECT * from $tableName");
      if(result.isNotEmpty){
        return List.generate(result.length, (index) => PostResponseModel.fromJson(result[index]));
      }
    }catch(error){
      debugPrint("error ${error.toString()}");
    }
  }
}
