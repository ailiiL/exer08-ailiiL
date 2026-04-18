import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpensesApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllExpenses(){
    return db.collection('expenses').snapshots();
  }

  Future<String> addExpense(Map<String, dynamic> expense) async {
    try{
      //await db.collection("expenses").add(expense);

      expense['id'] = db.collection('expenses').doc().id;
      await db.collection("expenses").doc(expense['id']).set(expense);
      
      return "Successfully added an expense!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }


  Future<String> deleteExpense(String id) async {
    try{
      await db.collection("expenses").doc(id).delete();
      
      return "Successfully deleted an expense!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }


  Future<String> editExpense(String id, String name, String desc, String category, int amount) async {
    try{
      await db.collection("expenses").doc(id).update({'name':name, 'id':id, 'desc': desc, 'category': category, 'amount':amount});
      
      return "Successfully edited an expense!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }

  Future<String> toggleStatus(String id, bool status) async {
    try{
      await db.collection("expenses").doc(id).update({'paid':status});
      
      return "Successfully updated status of the expense!";

    } on FirebaseException catch (e){
      return "Error on ${e.code}: ${e.message}";
    }
    
  }

}