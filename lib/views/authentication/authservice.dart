import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseAuth firebaseauth = FirebaseAuth.instance;

  registerUserWithEmailAndPassword(
      String firstname,
      String lastname,
      String phone,
      String email,
      String designation,
      String department,
      String password,
      String confirmpassword) async {
    try {
      await firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(
              () => firebaseauth.currentUser?.updateDisplayName(firstname));

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e;
    }
  }

  Future<bool> storeDataInFirestore(
      String firstname,
      String lastname,
      String phone,
      String email,
      String designation,
      String department,
      String password,
      String confirmpassword,
      String id,
      String companyName) async {
    FirebaseFirestore.instance
        .collection("User")
        .doc('${firstname.trim()} ${lastname.trim()}')
        .set({
      "CompanyName": companyName,
      "FirstName": firstname,
      "LastName": lastname,
      "Phone Number": phone,
      "Email": email,
      "Designation": designation,
      "Department": department,
      "Password": password,
      "ConfirmPassword": confirmpassword,
      'Employee Id': id,
      "fullName": '${firstname.trim()} ${lastname.trim()}'
    });

    FirebaseFirestore.instance
        .collection("unAssignedRole")
        .doc('$firstname $lastname')
        .set({
      "alphabet": firstname[0].toUpperCase(),
      "position": "unAssigned",
      "FirstName": firstname.trim(),
      "LastName": lastname.trim(),
      "Phone Number": phone,
      "Email": email,
      "Designation": designation,
      "Department": department,
      "CompanyName": companyName,
      "Password": password,
      "ConfirmPassword": confirmpassword,
      'Employee Id': id,
      "fullName": "${firstname.trim()} ${lastname.trim()}"
    });

    FirebaseFirestore.instance
        .collection("TotalUsers")
        .doc('$firstname $lastname')
        .set({
      "alphabet": firstname[0].toUpperCase(),
      "position": "unAssigned",
      "FirstName": firstname,
      "LastName": lastname,
      "Phone Number": phone,
      "Email": email,
      "Designation": designation,
      "Department": department,
      "CompanyName": companyName,
      "Password": password,
      "ConfirmPassword": confirmpassword,
      'Employee Id': id,
      "fullName": "$firstname $lastname",
    });

    return true;
  }

  Future<String> getCurrentCompanyName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String data = sharedPreferences.getString('companyName').toString();
    return data;
  }

  Future storeCompanyName(String companyName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('companyName', companyName);
  }

  Future storeEmployeeId(String employeeId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('employeeId', employeeId);
  }

  Future storeUserRole(String role) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('role', role);
  }

  Future<String> getUserRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String data = sharedPreferences.getString('role') ?? "";
    return data;
  }

  Future storeDepoList(List<String> depotList) async {
    try {
      final shared = await SharedPreferences.getInstance();
      shared.setStringList("depotList", depotList);
      print("depotList Stored - $depotList");
    } catch (e) {
      print("Error While Storing AssginedDepots - $e");
    }
  }

    Future storeCityList(List<String> cityList) async {
    try {
      final shared = await SharedPreferences.getInstance();
      shared.setStringList("cityList", cityList);
      print("cityList Stored - $cityList");
    } catch (e) {
      print("Error While Storing AssginedCities - $e");
    }
  }

  bool verifyAssignedDepot(String depotName, List<String> assignedDepots) {
    bool isEligibleUser = false;
    if (assignedDepots.contains(depotName)) {
      isEligibleUser = true;
    }
    return isEligibleUser;
  }

  Future<List<String>> getDepotList() async {
    final shared = await SharedPreferences.getInstance();
    List<String> depotList = shared.getStringList("depotList")!;
    return depotList;
  }

    Future<List<String>> getCityList() async {
    final shared = await SharedPreferences.getInstance();
    List<String> cityList = shared.getStringList("cityList")!;
    return cityList;
  }

  Future<String> getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String data = sharedPreferences.getString('employeeId').toString();
    return data;
  }
}
