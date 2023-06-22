import 'package:chat_app/screens/chats/frinds_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/database_services.dart';
import '../../shared/styles/app_colors.dart';
import '../../widgets/widgets.dart';

class SearchOnFriendsScreen extends StatefulWidget {
  const SearchOnFriendsScreen({super.key});

  @override
  State<SearchOnFriendsScreen> createState() => _SearchOnFriendsScreenState();
}

class _SearchOnFriendsScreenState extends State<SearchOnFriendsScreen> {
  TextEditingController searchOnFriendsController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool isFriend = false;
  String? friendId;
  String? friendName;
  String? bio;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Search",
          style: GoogleFonts.ubuntu(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchOnFriendsController,
                    style: GoogleFonts.ubuntu(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search On Friend....",
                      hintStyle: GoogleFonts.novaFlat(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    searchOnFriendsMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor),
                )
              : hasUserSearched
                  ? searchSnapshot != null
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: searchSnapshot!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Text(
                                    searchSnapshot!.docs[index]["fullName"]
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  searchSnapshot!.docs[index]["fullName"],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: InkWell(
                                  onTap: () async {
                                    await DatabaseServices(uid: user!.uid)
                                        .toggleFriendOrNot(friendId!, friendName!, );
                                    if (isFriend) {
                                      setState(() {
                                        isFriend = !isFriend;
                                      });
                                      showSnackBar(
                                          context, Colors.green, "Successfully Added friend");
                                      Future.delayed(const Duration(seconds: 2), () {
                                        nextScreen(
                                            context,
                                            FriendsChatScreen(
                                                friendName: friendName ??"",
                                                bio: bio??"", friendId: friendId??"",));
                                      });
                                    } else {
                                      setState(() {
                                        isFriend = !isFriend;
                                        showSnackBar(context, Colors.red, "Unfriend $widget");
                                      });
                                    }
                                  },
                                  child: isFriend
                                      ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text("Friend",
                                        style: GoogleFonts.ubuntu(color: Colors.white)),
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primaryColor,
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text("Add Friend",
                                        style: GoogleFonts.ubuntu(color: Colors.white)),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            "No results found.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                  : Container(),
        ],
      ),
    );
  }

  void searchOnFriendsMethod() async {
    setState(() {
      isLoading = true;
      hasUserSearched = false;
    });

    await DatabaseServices()
        .searchFriendsByName(searchOnFriendsController.text)
        .then((snapshot) {
      searchSnapshot = snapshot;
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
  }

  friendOrNot(String friendName, String friendId,
      String adminName) async {
    await DatabaseServices(uid: user!.uid)
        .isUserFriend(friendName, friendId)
        .then((value) {
      setState(() {
        isFriend = value;
      });
    });
  }
}