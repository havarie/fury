"use strict";

/* eslint-disable no-loop-func */

/* eslint-disable promise/no-nesting */
var functions = require('firebase-functions');

var admin = require('firebase-admin');

var serviceAccount = require("./diary-7919f-firebase-adminsdk-xp9f8-c1c1052d38.json");

var app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://diary-7919f.firebaseio.com"
});
var db = admin.firestore(app);
var messaging = admin.messaging(app);

var cors = require("cors")({
  origin: true
});

var express = require('express');

var appMemories = express();
/* Forces user to have
    Authorization: Bearer {idToken}
    in the header when they call firebase functions that use
*/

var authenticate = function authenticate(req, res, next) {
  if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
    console.log('Unauthorized');
    res.status(203).json({
      error: {
        message: "No authorization information sent.",
        status: "UNAUTHENTICATED"
      },
      message: "No authorization information sent."
    });
    return;
  }

  var idToken = req.headers.authorization.substring('Bearer '.length);
  admin.auth().verifyIdToken(idToken).then(function (userInfo) {
    req.uid = userInfo.uid;
    return next();
  })["catch"](function (error) {
    console.log("Error, prob not authenticated");
    res.status(203).json({
      error: {
        message: "Not authorized",
        status: "UNAUTHENTICATED"
      },
      message: "Not authorized"
    });
    return;
  });
};

appMemories.use(authenticate);
appMemories.post('/newVideo', function (req, res) {
  cors(req, res, function () {
    return res.status(200).json({
      isError: false,
      signedUrl: url
    });
  });
}); // const expiresAtMs = Date.now() + 60000 * 10; // Link expires in 1 minute

var memoriesRef = db.collection('memories');
var usersRef = db.collection('users'); // exports.scheduledFunction = functions.pubsub.schedule('every 1 minutes').onRun((context) => {

exports.helloWorld = functions.https.onRequest(function (request, response) {
  return memoriesRef.where('notificationSent', '==', false).get().then(function (snapshot) {
    var notificationsToSend = [];
    snapshot.forEach(function (doc) {
      var myMemory = doc.data();
      var ownerUid = myMemory.owner;
      var mediaType = myMemory.type;
      var videoName = myMemory.videoName;
      notificationsToSend.push({
        ownerUid: ownerUid,
        mediaType: mediaType,
        videoName: videoName
      });
    });
    return notificationsToSend;
  }).then(function (notificationsToSend) {
    var promises = [];
    notificationsToSend.forEach(function (notif) {
      console.log("add to list " + notif.ownerUid);
      promises.push(usersRef.doc(notif.ownerUid).get());
    });
    return Promise.all(promises).then(function (userDatas) {
      console.log("userDatas");
      console.log(userDatas);

      for (i = 0; i < userDatas.length; i++) {
        var payload = {
          notification: {
            title: 'Test!',
            body: "".concat(notificationsToSend[i].videoName, " notifs.")
          }
        };
        console.log("userDatas[i]");
        console.log(i);
        console.log(userDatas[i]);
        console.log(userDatas[i].data());
        var tokens = userDatas[i].data().notificationTokens;
        console.log("gooooo");
        console.log(payload);
        console.log(tokens);
        return messaging.sendToDevice(tokens, payload).then(function (response) {
          console.log("notif-response");
          console.log(response);
          var results = response.results;
          console.log("results");
          console.log(results);
          console.log("resultend"); // // For each message check if there was an error.
          // const tokensToRemove = [];

          response.results.forEach(function (result, index) {
            var error = result.error;
            console.log("error");
            console.log(error);
            console.log("enderror"); //     if (error) {
            //     // Cleanup the tokens who are not registered anymore.
            //         if (error.code === 'messaging/invalid-registration-token' ||
            //             error.code === 'messaging/registration-token-not-registered') {
            //             // tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
            //         }
            //     }
          });
          return "fssdfff";
        });
      }

      return "asdffff";
    });
  }); // const snapshot = memoriesRef.where('notificationSent', '==', false).get();
  // if (snapshot.empty) {
  //     console.log('No matching documents.');
  //     return;
  // }  
  // snapshot.forEach(doc => {
  //     console.log(doc.id, '=>', doc.data());
  //     db.collection('memories').add({
  //         owner: 'send not to '+ doc.data().owner,
  //         place: 'lol ' + doc.data().type
  //     });
  // });
}); // exports.addVideo = functions.https.onRequest((request, response) => {
//     // Add a new document with a generated id.
//     db.collection('memories').add({
//         owner: 'Tokyo',
//         country: 'Japan'
//     });
//     // response.send("Hello from Firebase " + res.id + "!");
// });
// exports.helloWorld = functions.https.onRequest((request, response) => {
//     // Add a new document with a generated id.
//     db.collection("cities").add({
//         name: "Tokyo",
//         country: "Japan"
//     });
//     response.send("Hello from Firebase dude!");
// });