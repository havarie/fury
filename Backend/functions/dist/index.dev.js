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
var memoriesRef = db.collection('memories');
var usersRef = db.collection('users');
exports.scheduledFunction = functions.pubsub.schedule('every 5 minutes').onRun(function (context) {
  var currentTime = new Date();
  return memoriesRef.where('notificationTimestamp', '<', currentTime).where('notificationSent', '==', false).get().then(function (snapshot) {
    var notificationsToSend = [];
    snapshot.forEach(function (doc) {
      var myMemory = doc.data();
      var ownerUid = myMemory.owner;
      var mediaType = myMemory.type;
      var videoName = myMemory.videoName;
      notificationsToSend.push({
        ownerUid: ownerUid,
        mediaType: mediaType,
        videoName: videoName,
        docRef: doc.ref
      });
    });
    console.log("notificationsToSend");
    console.log(notificationsToSend);
    return notificationsToSend;
  }).then(function (notificationsToSend) {
    var promises = [];
    notificationsToSend.forEach(function (notif) {
      promises.push(usersRef.doc(notif.ownerUid).get());
    });
    console.log("promises");
    console.log(promises);
    return Promise.all(promises).then(function (userDatas) {
      for (i = 0; i < userDatas.length; i++) {
        var payload = {
          notification: {
            title: 'Memory',
            body: 'You have a memory'
          },
          data: {
            videoName: notificationsToSend[i].videoName
          }
        };
        var tokens = userDatas[i].data().notificationTokens;
        console.log("tokens");
        console.log(tokens);
        console.log("payload");
        console.log(payload);
        return messaging.sendToDevice(tokens, payload).then(function (response) {
          var results = response.results;
          console.log("results");
          console.log(results); // For each message check if there was an error.

          response.results.forEach(function (result, index) {
            var error = result.error;

            if (error) {
              // Cleanup the tokens who are not registered anymore.
              if (error.code === 'messaging/invalid-registration-token' || error.code === 'messaging/registration-token-not-registered') {// tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
              }
            }
          }); // successfully sent to at least one

          var oneDeviceGotTheMessage = false;
          response.results.forEach(function (result) {
            if (result.messageId !== null) {
              oneDeviceGotTheMessage = true;
            }
          });
          console.log("oneDeviceGotTheMessage");
          console.log(oneDeviceGotTheMessage);

          if (oneDeviceGotTheMessage) {
            var docRef = notificationsToSend[i].docRef;
            docRef.update({
              notificationSent: true
            });
          }

          return null;
        });
      }

      return null;
    });
  });
});