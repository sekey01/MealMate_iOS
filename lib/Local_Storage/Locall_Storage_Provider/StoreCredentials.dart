import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mealmate_ios/Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageProvider extends ChangeNotifier {
  /// Just making use of this Provider to get the upgdated value for the notification page
  int notificationLength = 1;
///

  String phoneNumber = '';
  String userName = '' ;
  String  email = '' ;
  String imageUrl = '' ;
  String adminEmail = '';
  String locationName = '';
  String courierId = '';


 Future<void> storePhoneNumber(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/storePhoneNumber.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      phoneNumber = newValue;
print(phoneNumber);
      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing phoneNumber: $e");
      // You can throw the error or handle it as needed
    }
  }

  Future <String>getPhoneNumber() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/storePhoneNumber.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        phoneNumber = contents; // Parse the contents to an integer
        notifyListeners();

        return phoneNumber;
      } else {
        return phoneNumber = 'Add Phone Number'; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
    } catch (e) {
      // Handle any exceptions
      return 'Username';
      //print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }


  Future<void> storeCourierID(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/storeCourierId.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      courierId = newValue;
      print(courierId);
      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing Courier ID: $e");
      // You can throw the error or handle it as needed
    }
  }


  Future <String>getCourierID() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/storeCourierId.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        courierId = contents; // Parse the contents to an integer
        notifyListeners();

        return courierId;
      } else {
        return courierId = '0'; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
    } catch (e) {
      // Handle any exceptions
      return '0';
      //print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }





  Future<void> storeUsername(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/Username.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      userName = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing Username: $e");
      // You can throw the error or handle it as needed
    }
  }


  Future <String>getUsername() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/Username.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        userName = contents; // Parse the contents to an integer
        notifyListeners();

          return userName;
      } else {
      return userName = 'Username'; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
    } catch (e) {
      // Handle any exceptions
      return 'Username';
      //print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }

/// STORE USER EMAIL HERE
  ///
  Future<void> storeEmail(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/email.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      email = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      //print("Error changing email: $e");
      // You can throw the error or handle it as needed
    }
  }

  ///GET EMAIL HERE
  ///
  Future <String>getEmail() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/email.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        email = contents; // Parse the contents to an integer
        notifyListeners();

        return email;
      } else {
        return email = ' mealmate@gmail.com'; // Default value if the file doesn't exist
      }

    } catch (e) {
      // Handle any exceptions
      return '@username';
     // print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }






  /// STORE ADMIN EMAIL HERE
  ///
  Future<void> storeAdminEmail(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/adminEmail.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      adminEmail = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      //print("Error changing email: $e");
      // You can throw the error or handle it as needed
    }
  }

  ///GET EMAIL HERE
  ///
  Future <String>getAdminEmail() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/adminEmail.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        adminEmail = contents; // Parse the contents to an integer
        notifyListeners();

        return adminEmail;
      } else {
        return adminEmail = ' mealmate@gmail.com'; // Default value if the file doesn't exist
      }

    } catch (e) {
      // Handle any exceptions
      return 'adminemail@gmail.com';
      // print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }




  /// STORE LOCATION HERE
  ///
  Future<void> storeLocation(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/location.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      locationName = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      //print("Error changing email: $e");
      // You can throw the error or handle it as needed
    }
  }

  ///GET EMAIL HERE
  ///
  Future <String>getLocationName() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/location.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        locationName = contents; // Parse the contents to an integer
        notifyListeners();

        return locationName;
      } else {
        return locationName = ' Tap to set location'; // Default value if the file doesn't exist
      }

    } catch (e) {
      // Handle any exceptions
      return 'reset location';
      // print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }


  /// STORE IMAGE URL HERE
  ///
  ///

  Future<void> storeImageUrl(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/imageUrl.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      imageUrl = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing imageUrl: $e");
      // You can throw the error or handle it as needed
    }
  }

  ///GET IMAGE HERE
  ///
  Future <String>getImageUrl() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/imageUrl.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        imageUrl = contents; // Parse the contents to an integer

        return imageUrl;
      } else {
        return imageUrl = ' https://th.bing.com/th/id/OIP.8S8nd0rgWBcDRTr1MfPoOQHaHa?w=180&h=180&c=7&r=0&o=5&pid=1.7'; // Default value if the file doesn't exist
      }


    } catch (e) {
      // Handle any exceptions
      return 'https://th.bing.com/th/id/OIP.8S8nd0rgWBcDRTr1MfPoOQHaHa?w=180&h=180&c=7&r=0&o=5&pid=1.7';
     // print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }




  ///  LOCAL STORAGE TO STORE ORDERS

   String fileName = 'orders.json';

   Future<String> get _localPath async {
         final directory = await getApplicationDocumentsDirectory();
         return directory.path;
  }

   Future<File> get _localFile async {
         final path = await _localPath;
         return File('$path/$fileName');
  }

   Future<void> saveOrders(List<StoreOrderLocally> storeOrders) async {
         final file = await _localFile;
         if (!await file.exists()) {
           await file.create(
               recursive: true); // Create the file if it doesn't exist
         }
         final data = storeOrders.map((order) => order.toJson()).toList();
  await file.writeAsString(json.encode(data));
  }

   Future<List<StoreOrderLocally>> loadOrders() async {
  try {
        final file = await _localFile;
        final contents = await file.readAsString();
        final data = json.decode(contents) as List;
              return data.map((item) => StoreOrderLocally.fromJson(item)).toList();
     } catch (e) {
  // If encountering an error, return an empty list
  return [];
            }
  }

   Future<void> addOrder(StoreOrderLocally storeOrders) async {
            final orders = await loadOrders();
                  orders.add(storeOrders);
  await saveOrders(orders);
  }

  Future<void> deleteAllOrders() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete(); // Delete the file
    }
  }



  ///ADMIN LOGIN STATE
///

  Future<void> storeAdminLoginState(bool isLoggedIn) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/adminLoginState.txt';
      final file = File(filepath);

      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      await file.writeAsString(isLoggedIn.toString());
      notifyListeners();
    } catch (e) {
      print("Error storing admin login state: $e");
    }
  }

  Future<bool> getAdminLoginState() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/adminLoginState.txt';
      final file = File(filepath);

      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents == 'true';
      } else {
        return false;
      }
    } catch (e) {
      print("Error retrieving admin login state: $e");
      return false;
    }
  }


  }


