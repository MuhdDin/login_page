import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_page/model/chat.dart';
import 'package:login_page/model/comments.dart';
import 'package:login_page/model/follow.dart';
import 'package:login_page/model/likes.dart';
import 'package:login_page/model/notification.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
// import 'package:login_page/provider/like_provider.dart';
import 'package:uuid/uuid.dart';

class StoreFirebase {
  final storageRef = FirebaseStorage.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<String> dataStorage(Uint8List imagePath, String userName) async {
    const Uuid uuidName = Uuid();
    final String fileName = uuidName.v4();
    final imageref = storageRef.child('images/$userName/$fileName');
    try {
      debugPrint('storing');
      final uploadTask = imageref.putData(imagePath);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      debugPrint('error uploading image');
      return '';
    }
  }

  Future<String?> getBackgroundImageUrl() async {
    try {
      Reference reference = storageRef.child('backgroundImage/space.jpg');

      String downloadURL = await reference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      debugPrint('Error retrieving background image: $e');
      return null;
    }
  }

  Future<void> createUser(Uint8List fileName, String userName, String email,
      int followers, int following, String uid) async {
    String donwloadUrl = await StoreFirebase().dataStorage(fileName, uid);
    String? bgImage = await getBackgroundImageUrl();
    UserInfoOri createUser = UserInfoOri(
        createdAt: DateTime.now(),
        email: email,
        userName: userName,
        profilePicture: donwloadUrl,
        backgroundImage: bgImage,
        followers: followers,
        following: following,
        uid: uid,
        bio: '',
        instagram: '',
        youtube: '',
        twitch: '',
        twitter: '',
        facebook: '');

    await storeUserDatabase(createUser);
  }

  Future<void> storePhotoDatabase(ImagePost imageInfo) async {
    try {
      await _firestore.collection('post').add(imageInfo.toMap());
      debugPrint("data stored succesfully");
    } catch (e) {
      debugPrint('error storing data $e');
    }
  }

  Future<void> storeUserDatabase(UserInfoOri userInfo) async {
    try {
      await _firestore.collection('user').add(userInfo.toMap());
      debugPrint("data stored succesfully");
    } catch (e) {
      debugPrint('error storing data $e');
    }
  }

  Future<List<UserInfoOri>> fetchUserData() async {
    try {
      QuerySnapshot postsSnapshot = await _firestore.collection('user').get();

      List<UserInfoOri> userInfo = [];

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          UserInfoOri user = UserInfoOri.fromMap(data);
          userInfo.add(user);
        }
      } // Now, imagePosts list contains ImagePost objects for each document

      return userInfo;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }

  Future<UserInfoOri> fetchUserDatabyName(String userName) async {
    try {
      QuerySnapshot postsSnapshot = await _firestore
          .collection('user')
          .where('userName', isEqualTo: userName)
          .get();

      UserInfoOri user =
          UserInfoOri(createdAt: DateTime.now(), email: '', userName: userName);

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          user = UserInfoOri.fromMap(data);
        }
      } // Now, imagePosts list contains ImagePost objects for each document

      return user;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return UserInfoOri(
          createdAt: DateTime.now(), email: '', userName: userName);
    }
  }

  Future<UserInfoOri> fetchUserDatabyEmail(String email) async {
    try {
      QuerySnapshot postsSnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      UserInfoOri user =
          UserInfoOri(createdAt: DateTime.now(), email: email, userName: '');

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          user = UserInfoOri.fromMap(data);
        }
      } // Now, imagePosts list contains ImagePost objects for each document

      return user;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return UserInfoOri(createdAt: DateTime.now(), email: email, userName: '');
    }
  }

  Future<UserInfoOri> fetchUserDatabyUid(String uid) async {
    try {
      QuerySnapshot postsSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      UserInfoOri user =
          UserInfoOri(createdAt: DateTime.now(), email: '', userName: '');

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          user = UserInfoOri.fromMap(data);
        }
      } // Now, imagePosts list contains ImagePost objects for each document

      return user;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return UserInfoOri(createdAt: DateTime.now(), email: '', userName: '');
    }
  }

  Future<List<ImagePost>> fetchPostData() async {
    try {
      QuerySnapshot postsSnapshot = await _firestore.collection('post').get();

      List<ImagePost> imagePosts = [];

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          ImagePost imagePost = ImagePost.fromMap(data);
          imagePosts.add(imagePost);
        }
      }
      imagePosts.shuffle();
      debugPrint('ImagePosts: $imagePosts');

      return imagePosts;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }

  Future<List<ImagePost>> fetchPostDataByUsername(String username) async {
    try {
      QuerySnapshot postsSnapshot = await _firestore
          .collection('post')
          .where('userName', isEqualTo: username)
          .get();

      List<ImagePost> imagePosts = [];

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          ImagePost imagePost = ImagePost.fromMap(data);
          imagePosts.add(imagePost);
        }
      } // Now, imagePosts list contains ImagePost objects for each document
      debugPrint('ImagePosts: $imagePosts');

      return imagePosts;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }

  Future<ImagePost> fetchPostDataById(String id) async {
    try {
      QuerySnapshot postsSnapshot =
          await _firestore.collection('post').where('id', isEqualTo: id).get();

      ImagePost imagePost = ImagePost(
          uid: '',
          userName: '',
          caption: '',
          address: '',
          date: DateTime.now(),
          imageUrl: '');

      for (QueryDocumentSnapshot document in postsSnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          imagePost = ImagePost.fromMap(data);
        }
      } // Now, imagePosts list contains ImagePost objects for each document

      return imagePost;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return ImagePost(
          uid: '',
          userName: '',
          caption: '',
          address: '',
          date: DateTime.now(),
          imageUrl: '');
    }
  }

  Future<void> editUser(
    String originaUsername,
    String userName,
    String email,
    int followers,
    int following,
    String uid,
    String bio, {
    Uint8List? bgImage,
    Uint8List? fileName,
  }) async {
    String? donwloadUrl;
    String? bgDownloadUrl;
    if (fileName != null) {
      donwloadUrl = await StoreFirebase().dataStorage(fileName, uid);
    }

    if (bgImage != null) {
      bgDownloadUrl = await StoreFirebase().dataStorage(bgImage, uid);
    }

    // String bgDownloadUrl = await StoreFirebase().dataStorage(bgImage!, uid);

    UserInfoOri createUser = UserInfoOri(
      createdAt: DateTime.now(),
      email: email,
      uid: uid,
      userName: userName,
      bio: bio,
      profilePicture: donwloadUrl,
      backgroundImage: bgDownloadUrl,
      followers: followers,
      following: following,
    );
    debugPrint("storing");

    await storeEditUserInfo(originaUsername, createUser);
    if (originaUsername != userName) {
      debugPrint('changeusername');
      await updateUsername(originaUsername, userName);
    }
  }

  Future<void> updateUsername(
      String usernameOriginal, String newUsername) async {
    try {
      debugPrint('process of updating username');
      QuerySnapshot userSnapshot = await _firestore
          .collection('post')
          .where('userName', isEqualTo: usernameOriginal)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Loop through each document and update the userName field
        for (QueryDocumentSnapshot doc in userSnapshot.docs) {
          DocumentReference userDocRef = doc.reference;
          await userDocRef.update(
            {'userName': newUsername},
          );
        }
        print("username updated successfully for all matching documents");
      }
    } catch (e) {
      debugPrint('error updating username: $e');
    }
  }

  Future<void> storeEditUserInfo(
      String usernameOriginal, UserInfoOri userInfo) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('userName', isEqualTo: usernameOriginal)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = userSnapshot.docs.first.reference;

        await userDocRef.update(userInfo.toMap());
      }
      debugPrint("data stored succesfully");
    } catch (e) {
      debugPrint('error edit data: $e');
    }
  }

  Future<List<UserInfoOri>> filterUserAccount(String search) async {
    if (search == '') {
      return [];
    } else {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
          .collection('user')
          .where('userName', isGreaterThanOrEqualTo: search)
          .where('userName', isLessThan: '${search}z')
          .get();

      List<UserInfoOri> accounts = userSnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> document) =>
              UserInfoOri.fromMap(document.data()!))
          .toList();
      return accounts;
    }
  }

  Future<List<FollowingUser>> filterChatAccount(
      String search, String id) async {
    if (search == '') {
      return [];
    } else {
      print('1, $id');
      List<FollowingUser> accounts = [];
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: id)
          // .where('userName', isLessThan: '${search}z')
          .get();
      print('2');
      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference postDocument = userSnapshot.docs.first.reference;
        CollectionReference followingCollection =
            postDocument.collection('following');
        QuerySnapshot followingSnapshot = await followingCollection
            .where('username', isGreaterThanOrEqualTo: search)
            .where('username', isLessThan: '${search}z')
            .get();
        print('3');
        for (QueryDocumentSnapshot document in followingSnapshot.docs) {
          print('4');
          Map<String, dynamic> followingData =
              document.data() as Map<String, dynamic>;
          FollowingUser account = FollowingUser.fromMap(followingData);
          print('5');
          accounts.add(account);
        }
      } else {
        print('no account found');
        return [];
      }
      return accounts;
    }
  }

/////////////////////////
/////LIKES FUNCTION//////
/////////////////////////

  Future<void> likeImage(LikeImage likes, String id) async {
    QuerySnapshot userSnapshot =
        await _firestore.collection('post').where('id', isEqualTo: id).get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentReference postDocument = userSnapshot.docs.first.reference;

      CollectionReference likesSubcollection = postDocument.collection('likes');
      await likesSubcollection.add(likes.toMap());
    } else {
      debugPrint('No documnet id found');
    }
  }

  // Future<bool> fetchLike(String postId, String userId, WidgetRef ref) async {
  //   QuerySnapshot userSnapshot = await _firestore
  //       .collection('post')
  //       .where('id', isEqualTo: postId)
  //       .get();
  //   DocumentReference postDocument = userSnapshot.docs.first.reference;
  //   CollectionReference likesCollectionRef = postDocument.collection('likes');

  //   QuerySnapshot likeQuerySnapshot =
  //       await likesCollectionRef.where('userId', isEqualTo: userId).get();

  //   if (likeQuerySnapshot.docs.isNotEmpty) {
  //     ref.read(imageLikesProvider(postId).notifier).likeImage(true, userId);
  //     return true;
  //   } else {
  //     ref.read(imageLikesProvider(postId).notifier).likeImage(false, userId);
  //     return false;
  //   }
  // }

  Future<int> getTotalLikesCount(String postId) async {
    try {
      // Use the 'where' method to filter documents based on 'id'
      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('id', isEqualTo: postId)
          .get();

      if (postSnapshot.docs.isNotEmpty) {
        // Get the first document from the result
        QueryDocumentSnapshot firstDocument = postSnapshot.docs.first;

        // Access the 'likes' field, which should be a collection
        CollectionReference likesCollection =
            firstDocument.reference.collection('likes');

        // Get the documents within the 'likes' collection
        QuerySnapshot likesSnapshot = await likesCollection.get();

        int totalLikesCount = likesSnapshot.size;
        debugPrint('likes: $totalLikesCount');
        return totalLikesCount;
      } else {
        debugPrint('No document found with postId: $postId');
        return 0; // Handle the case where no document is found
      }
    } catch (e) {
      debugPrint('Error getting total likes count: $e');
      return 0; // Handle the error or return a default value
    }
  }

  Future<Map<String, dynamic>> fetchLikeAndTotalLikesCount(
      String postId, String userId, WidgetRef ref) async {
    try {
      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('id', isEqualTo: postId)
          .get();

      if (postSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot firstDocument = postSnapshot.docs.first;
        CollectionReference likesCollection =
            firstDocument.reference.collection('likes');

        QuerySnapshot likeCount = await likesCollection.get();
        QuerySnapshot likesSnapshot =
            await likesCollection.where('userId', isEqualTo: userId).get();

        int totalLikesCount = likeCount.size;
        bool isLiked = likesSnapshot.docs.isNotEmpty;

        // ref.read(imageLikesProvider(postId).notifier).setImageLiked(isLiked);

        return {'totalLikesCount': totalLikesCount, 'isLiked': isLiked};
      } else {
        // ref.read(imageLikesProvider(postId).notifier).setImageLiked(false);
        return {'totalLikesCount': 0, 'isLiked': false};
      }
    } catch (e) {
      // ref.read(imageLikesProvider(postId).notifier).setImageLiked(false);
      print('Error fetching likes and total likes count: $e');
      return {'totalLikesCount': 0, 'isLiked': false};
    }
  }

  Future<void> unlikeImage(String postId, String userId) async {
    QuerySnapshot userSnapshot = await _firestore
        .collection('post')
        .where('id', isEqualTo: postId)
        .get();
    DocumentReference postDocument = userSnapshot.docs.first.reference;
    CollectionReference likesCollectionRef = postDocument.collection('likes');

    QuerySnapshot likeQuerySnapshot =
        await likesCollectionRef.where('userId', isEqualTo: userId).get();

    if (likeQuerySnapshot.docs.isNotEmpty) {
      DocumentReference likeDocRef = likeQuerySnapshot.docs.first.reference;

      await likeDocRef.delete();
    } else {
      debugPrint('No matching like document found for userId: $userId');
    }
  }

/////////////////////////
////COMMENTS FUNCTION////
/////////////////////////

  Future<void> commentImage(UsersComments comment, String id) async {
    QuerySnapshot userSnapshot =
        await _firestore.collection('post').where('id', isEqualTo: id).get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentReference postDocument = userSnapshot.docs.first.reference;

      CollectionReference commentsSubcollection =
          postDocument.collection('comments');
      await commentsSubcollection.add(comment.toMap());
    } else {
      debugPrint('No documnet id found');
    }
  }

  Future<List<UsersComments>> fetchComment(String id) async {
    QuerySnapshot userSnapshot =
        await _firestore.collection('post').where('id', isEqualTo: id).get();

    try {
      List<UsersComments> comments = [];
      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference postDocument = userSnapshot.docs.first.reference;

        CollectionReference commentsSubcollection =
            postDocument.collection('comments');
        // await commentsSubcollection.add(comment.toMap());
        QuerySnapshot commentsSnapshot = await commentsSubcollection.get();

        for (QueryDocumentSnapshot commentDocument in commentsSnapshot.docs) {
          Map<String, dynamic> commentData =
              commentDocument.data() as Map<String, dynamic>;

          // Convert each comment document to UsersComments and add it to the list
          UsersComments comment = UsersComments.fromMap(commentData);
          comments.add(comment);
        }
      } else {
        debugPrint('No documnet id found');
      }
      return comments;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return [];
    }
  }

  Future<UsersComments?> fetchPreviewComment(String id) async {
    QuerySnapshot postSnapshot = await _firestore
        .collection('post')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    try {
      if (postSnapshot.docs.isNotEmpty) {
        DocumentReference postDocument = postSnapshot.docs.first.reference;

        CollectionReference commentsSubcollection =
            postDocument.collection('comments');

        QuerySnapshot commentsSnapshot = await commentsSubcollection.get();

        // Assuming UsersComments.fromMap is a factory constructor for a single comment
        if (commentsSnapshot.docs.isNotEmpty) {
          DocumentSnapshot commentDoc = commentsSnapshot.docs.first;
          if (commentDoc.exists) {
            Map<String, dynamic>? commentData =
                commentDoc.data() as Map<String, dynamic>?;

            if (commentData != null) {
              UsersComments comment = UsersComments.fromMap(commentData);
              return comment;
            } else {
              debugPrint(
                  'Comment data is null for document ID: ${commentDoc.id}');
              return null;
            }
          } else {
            debugPrint(
                'Comment document does not exist for document ID: ${commentDoc.id}');
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

/////////////////////////
////FOLLOW FUNCTION////
/////////////////////////

  Future<void> followUser(FollowingUser followerUserInfo, String ownerId,
      FollowingUser followedUserInfo, String followedId) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: ownerId)
          .get();
      print("following: $ownerId");
      QuerySnapshot followerSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: followedId)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference postDocument = userSnapshot.docs.first.reference;
        CollectionReference followingSubcollection =
            postDocument.collection('following');
        await postDocument.update({'following': FieldValue.increment(1)});

        await followingSubcollection.add(followerUserInfo.toMap());
        if (followerSnapshot.docs.isNotEmpty) {
          DocumentReference postDocument2 =
              followerSnapshot.docs.first.reference;

          CollectionReference followingSubcollection2 =
              postDocument2.collection('follower');
          await postDocument2.update({'followers': FieldValue.increment(1)});
          await followingSubcollection2.add(followedUserInfo.toMap());
        } else {
          debugPrint('No documnet follower found');
        }
      } else {
        debugPrint('No documnet owner id found');
      }
    } catch (e) {
      debugPrint('error while following: $e');
    }
  }

  Future<void> unfollowUser(String ownerId, String followedId) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: ownerId)
          .get();
      QuerySnapshot followerSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: followedId)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference postDocument = userSnapshot.docs.first.reference;
        CollectionReference followingSubcollection =
            postDocument.collection('following');
        QuerySnapshot unfollowSnapshot = await followingSubcollection
            .where('uid', isEqualTo: followedId)
            .get();

        if (unfollowSnapshot.docs.isNotEmpty) {
          DocumentReference unfollowDocRef =
              unfollowSnapshot.docs.first.reference;
          await postDocument.update({'following': FieldValue.increment(-1)});
          await unfollowDocRef.delete();
        } else {
          debugPrint('No matching like document found for userId: $followedId');
        }
        if (followerSnapshot.docs.isNotEmpty) {
          DocumentReference postDocument2 =
              followerSnapshot.docs.first.reference;
          CollectionReference followingSubcollection2 =
              postDocument2.collection('follower');
          QuerySnapshot unfollowSnapshot2 = await followingSubcollection2
              .where('uid', isEqualTo: ownerId)
              .get();
          if (unfollowSnapshot2.docs.isNotEmpty) {
            DocumentReference unfollowDocRef2 =
                unfollowSnapshot2.docs.first.reference;
            await postDocument2.update({'followers': FieldValue.increment(-1)});
            await unfollowDocRef2.delete();
          } else {
            debugPrint(
                'No matching like document found for userId2: $followedId');
          }
        } else {
          debugPrint('No documnet follower found');
        }
      } else {
        debugPrint('No documnet owner id found');
      }
    } catch (e) {
      debugPrint('error while following: $e');
    }
  }

  Future<bool> checkFollow(String userId, String followerId) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot firstDocument = userSnapshot.docs.first;
        CollectionReference followingCollection =
            firstDocument.reference.collection('following');

        QuerySnapshot followingSnapshot =
            await followingCollection.where('uid', isEqualTo: followerId).get();

        bool isFollowing = followingSnapshot.docs.isNotEmpty;
        return isFollowing;
      } else {
        debugPrint('Error during checking follower');
        return false;
      }
    } catch (e) {
      debugPrint('Check follower bug: $e');
      return false;
    }
  }

/////////////////////////////
////NOTIFICATION FUNCTION////
////////////////////////////

  Future<void> createNotification(
      NotificationModel notification, String uid) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDocument = userSnapshot.docs.first.reference;
        CollectionReference userReference =
            userDocument.collection('notification');
        await userReference.add(notification.toMap());
      } else {
        debugPrint('document not found');
      }
    } catch (e) {
      debugPrint('Error caught notfication: $e');
    }
  }

  Future<List<NotificationModel>> fetchNotification(String uid) async {
    try {
      List<NotificationModel> notifications = [];
      DateTime twentyFourHoursAgo =
          DateTime.now().subtract(const Duration(days: 1));
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDocument = userSnapshot.docs.first.reference;
        CollectionReference userReference =
            userDocument.collection('notification');
        QuerySnapshot notificationSnapshot = await userReference
            .where('createdAt', isGreaterThan: twentyFourHoursAgo)
            .orderBy('createdAt', descending: true)
            .get();
        for (QueryDocumentSnapshot notificationDocument
            in notificationSnapshot.docs) {
          Map<String, dynamic> notificationData =
              notificationDocument.data() as Map<String, dynamic>;

          NotificationModel notification =
              NotificationModel.fromMap(notificationData);

          notifications.add(notification);
        }
      } else {
        debugPrint('no notification');
      }
      return notifications;
    } catch (e) {
      debugPrint('error fetching notification: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> fetchOldNotification(String uid) async {
    try {
      List<NotificationModel> notifications = [];
      DateTime twentyFourHoursAgo =
          DateTime.now().subtract(const Duration(days: 1));

      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDocument = userSnapshot.docs.first.reference;
        CollectionReference userReference =
            userDocument.collection('notification');

        QuerySnapshot notificationSnapshot = await userReference
            .where('createdAt', isLessThan: twentyFourHoursAgo)
            .orderBy('createdAt',
                descending: true) // Sort from newest to oldest
            .limit(10)
            .get();

        for (QueryDocumentSnapshot notificationDocument
            in notificationSnapshot.docs) {
          Map<String, dynamic> notificationData =
              notificationDocument.data() as Map<String, dynamic>;
          NotificationModel notification =
              NotificationModel.fromMap(notificationData);
          notifications.add(notification);
        }
      } else {
        debugPrint('no notification');
      }
      return notifications;
    } catch (e) {
      debugPrint('error fetching notification: $e');
      return [];
    }
  }

  Future<void> storeChat(
      String ownerId, String friendId, String message) async {
    Chat sender = Chat(
        friendUid: friendId,
        messageType: 'sender',
        createdAt: DateTime.now(),
        message: message);
    Chat receiver = Chat(
        friendUid: ownerId,
        messageType: 'receive',
        createdAt: DateTime.now(),
        message: message);
    QuerySnapshot userSnapshot = await _firestore
        .collection('user')
        .where('uid', isEqualTo: ownerId)
        .get();
    QuerySnapshot friendSnapshot = await _firestore
        .collection('user')
        .where('uid', isEqualTo: friendId)
        .get();

    if (userSnapshot.docs.isNotEmpty && friendSnapshot.docs.isNotEmpty) {
      DocumentReference chatDocument = userSnapshot.docs.first.reference;
      DocumentReference chatDocument2 = friendSnapshot.docs.first.reference;
      CollectionReference subCollection = chatDocument.collection('chats');
      CollectionReference subCollection2 = chatDocument2.collection('chats');
      CollectionReference messagesSubCollection =
          subCollection.doc(friendId).collection('messages');
      CollectionReference messagesSubCollection2 =
          subCollection2.doc(ownerId).collection('messages');

      await messagesSubCollection.add(sender.toMap());
      await messagesSubCollection2.add(receiver.toMap());
    }
  }

  Future<List<Chat>> fetchChat(String ownerId, String friendId) async {
    try {
      List<Chat> messages = [];
      QuerySnapshot userSnapshot = await _firestore
          .collection('user')
          .where('uid', isEqualTo: ownerId)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference chatDocument = userSnapshot.docs.first.reference;
        CollectionReference chatReference = chatDocument
            .collection('chats')
            .doc(friendId)
            .collection('messages');
        QuerySnapshot messageSnapshot =
            await chatReference.orderBy('createdAt', descending: true).get();

        for (QueryDocumentSnapshot documentSnapshot in messageSnapshot.docs) {
          Map<String, dynamic> messageData =
              documentSnapshot.data() as Map<String, dynamic>;
          Chat message = Chat.fromMap(messageData);

          messages.add(message);
        }
      }
      return messages;
    } catch (e) {
      return [];
    }
  }
}
