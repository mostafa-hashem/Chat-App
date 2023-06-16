import 'package:chat_app/screens/group_info/group_info.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/shared/constants/app_colors.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  String adminName = "";

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseServices().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseServices().getGroupAdmin(widget.groupId).then((value) {
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
                      adminName: adminName,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: GoogleFonts.ubuntu(
                        color: Colors.white, fontSize: 14.sp),
                    border: InputBorder.none,
                  ),
                )),
                SizedBox(
                  width: 0.1.sw,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 0.057.sh,
                    width: 0.12.sw,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sendByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                })
            : Container();
      },
    );
  }

  void sendMessage() {
    if(messageController.text.isNotEmpty){
      Map<String,dynamic>chapMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseServices().sendMessage(groupId, chatMessageData);
    }
  }
}
