import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpensesApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllExpenses(){
    return db.collection('expenses').snapshots();
  }

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try{
      //await db.collection("todos").add(todo);
      
      todo['id'] = db.collection('todos').doc().id;
      await db.collection("todos").doc(todo['id']).set(todo);
      
      return "Successfully added todo!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }


  Future<String> deleteTodo(String id) async {
    try{
      await db.collection("todos").doc(id).delete();
      
      return "Successfully deleted todo!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }


  Future<String> editTodo(String id, String title) async {
    try{
      await db.collection("todos").doc(id).update({'title':title, 'id':id});
      
      return "Successfully edited todo!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }

  Future<String> toggleStatus(String id, bool status) async {
    try{
      await db.collection("todos").doc(id).update({'completed':status});
      
      return "Successfully updated status of the todo!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }

}