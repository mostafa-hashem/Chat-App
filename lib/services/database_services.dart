import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;

  DatabaseServices({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference friendCollection =
      FirebaseFirestore.instance.collection("friends");

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid) .set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "friends": [],
      "profilePic": "",
      "uid": uid,
      "bio": "",
    });
  }

  //get user data
  // Future gettingUserData() async {
  //   return await userCollection.doc(uid).get();
  // }
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserCollection() async {
    return userCollection.doc(uid).snapshots();
  }

  //create a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    //update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]),
    });
  }


  //add friend
  Future<void> addFriend(String friendName, String friendId) async {
    DocumentReference<Object?> friendDocumentReference =
    await friendCollection.add({
      "friendIcon": "",
      "friendName": "${friendId}_$friendName",
      "friendBio": "",
      "friendId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await friendDocumentReference.update({
      "friendId": friendDocumentReference.id,
    });

    DocumentReference<Object?> userDocumentReference =
    userCollection.doc(uid);
    await userDocumentReference.update({
      "friends": FieldValue.arrayUnion(["${friendDocumentReference.id}_$friendName"]),
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  //get group members
  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search on groups by name
  searchGroupsByName(String groupName) {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  //search on users by name
  searchFriendsByName(String fullName) {
    return userCollection.where("fullName", isEqualTo: fullName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isUserFriend(String friendId, String friendName) async {
    DocumentSnapshot<Object?> documentSnapshot =
    await userCollection.doc(uid).get();
    List<dynamic> friends = documentSnapshot['friends'];
    return friends.contains("${friendId}_$friendName");
  }

// toggling the group join/exit
  Future toggleGroupJoinExit(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"]),
      });
      await groupDocumentReference.collection("members").doc(uid).delete();
      // DatabaseReference firebaseDatabaseReference = FirebaseDatabase.instance.reference();
      // firebaseDatabaseReference.child("groups").child(groupId).child("members").child(uid).remove();
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

// toggling the friend or not
  Future<void> toggleFriendOrNot(String friendId, String friendName, bool isFriend) async {
    DocumentReference<Object?> userDocumentReference =
    userCollection.doc(uid);

    if (isFriend) {
      await userDocumentReference.update({
        "friends": FieldValue.arrayRemove(["${friendId}_$friendName"]),
      });
    } else {
      await userDocumentReference.update({
        "friends": FieldValue.arrayUnion(["${friendId}_$friendName"]),
      });
    }
  }

  // send message to group
  sendMessageToGroup(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  sendMessageToFriend(String userId, Map<String, dynamic> chatMessageData) async {
    userCollection.doc(userId).collection("messages").add(chatMessageData);
    friendCollection.doc(userId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // delete message
  Future deleteMessageForAllGroups(String groupId, String messageId) async {
    await groupCollection
        .doc(groupId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
  Future deleteMessageForAllFriends(String friendId, String messageId) async {
    await friendCollection
        .doc(friendId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  // delete user
 Future deleteUser(String groupId) async {
   DocumentReference groupDocumentReference = groupCollection.doc(groupId);
   await groupDocumentReference.collection("members").doc(uid).delete();
 }



  Future<void> updateGroupName(String groupId, String groupName) async {
    DocumentReference<Object?> groupDocumentReference =
    groupCollection.doc(groupId);
    await groupDocumentReference.update({"groupName": groupName});

    DocumentReference<Object?> userDocumentReference =
    userCollection.doc(uid);
    await userDocumentReference.update({
      "groups": FieldValue.arrayRemove([groupId]),
    });
    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupId}_$groupName"]),
    });
  }

  Future<void> updateFriendName(String friendId, String friendName) async {
    DocumentReference<Object?> friendDocumentReference =
    friendCollection.doc(friendId);
    await friendDocumentReference.update({"friendName": friendName});

    DocumentReference<Object?> userDocumentReference =
    userCollection.doc(uid);
    await userDocumentReference.update({
      "friends": FieldValue.arrayRemove(["${friendId}_$friendName"]),
    });
    await userDocumentReference.update({
      "friends": FieldValue.arrayUnion(["${friendId}_$friendName"]),
    });
  }
}
