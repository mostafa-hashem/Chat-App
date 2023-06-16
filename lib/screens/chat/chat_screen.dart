import 'package:chat_app/screens/group_info/group_info.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/shared/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  final String userName;
  final String groupId;
  final String groupName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chat;
  String adminName = "";

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseServices().getChats(widget.groupId).then((value){
      setState(() {
        chat = value;
      });
    });
    DatabaseServices().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        adminName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 80,
        title: Text(
          widget.groupName,
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: widget.userName,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Center(),
    );
  }
}
