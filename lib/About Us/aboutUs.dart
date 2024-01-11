import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:nuriya_tailers/features/auth/screens/auth_screen.dart';

class AboutUs extends StatefulWidget {
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 28,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: GlobalVariables.primaryColor,
      ),
      body: Center(
        child: Card(
          elevation: 5.3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: GlobalVariables.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'নুরিয়া পাঞ্জাবি টেইলার্স এন্ড ফেব্রিকস',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'মাদ্রাসাপাড়া, আশ্রাফাবাদ, কামরাঙ্গীরচর, ঢাকা-১২১১',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'প্রোপাইটার: মো আসিক জোবায়ের',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Divider(
                  thickness: 1.5,
                  color: GlobalVariables.primaryColor,
                  endIndent: 30,
                  indent: 30,
                ),
                Text(
                  'Developed By: PNC Soft Tech',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  'WhatsApp: +880 17932-78 360',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                //elevated button for logout button
                ElevatedButton(
                  onPressed: () async {
                    LocalStorageInterface prefs =
                        await LocalStorage.getInstance();
                    // prefs.setBool("isLoggedd", false);
                    await prefs.setString('username', 'notLogged');
                    await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: GlobalVariables.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
