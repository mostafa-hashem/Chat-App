import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/helper_functions.dart';
import '../../widgets/drawer_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String userName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSp().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserEmailFromSp().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style:
              GoogleFonts.novaSquare(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const Drawer(
        child: DrawerTile(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Name: ",
                  style: GoogleFonts.ubuntu(fontSize: 15.sp),
                ),
                Text(
                  userName,
                  style: GoogleFonts.ubuntu(fontSize: 15.sp),
                )
              ],
            ),
            Divider(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email: ",
                  style: GoogleFonts.ubuntu(fontSize: 15.sp),
                ),
                Text(
                  email,
                  style: GoogleFonts.ubuntu(fontSize: 15.sp),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
