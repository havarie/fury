/* eslint-disable no-loop-func */
/* eslint-disable promise/no-nesting */
const functions = require('firebase-functions');
const admin = require('firebase-admin');


var serviceAccount = require("./diary-7919f-firebase-adminsdk-xp9f8-c1c1052d38.json");
var app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://diary-7919f.firebaseio.com"
});
var db = admin.firestore(app);
var messaging = admin.messaging(app);

const memoriesRef = db.collection('memories');
const usersRef = db.collection('users');
exports.scheduledFunction = functions.pubsub.schedule('every 5 minutes').onRun((context) => {
    const currentTime = new Date();
    return memoriesRef.where('notificationTimestamp', '<', currentTime).where('notificationSent', '==', false).get().then((snapshot) => {
        var notificationsToSend = []
        snapshot.forEach(doc => {
            const myMemory = doc.data()
            const ownerUid = myMemory.owner
            const mediaType = myMemory.type
            const videoName = myMemory.videoName
            notificationsToSend.push({
                ownerUid: ownerUid,
                mediaType: mediaType,
                videoName: videoName,
                docRef: doc.ref
            })
        });
        console.log("notificationsToSend")
        console.log(notificationsToSend)
        return notificationsToSend;
    }).then((notificationsToSend) => {
        var promises = []
        notificationsToSend.forEach(notif => {
            promises.push(usersRef.doc(notif.ownerUid).get())
        });
        console.log("promises")
        console.log(promises)
        return Promise.all(promises).then((userDatas) => {
            for (i = 0; i < userDatas.length; i++) { 
                const payload = {
                    notification: {
                        title: 'Memory',
                        body: 'You have a memory'
                    },
                    data: {
                        videoName: notificationsToSend[i].videoName
                    }
                };
                const tokens = userDatas[i].data().notificationTokens                
                console.log("tokens")
                console.log(tokens)
                console.log("payload")
                console.log(payload)
                return messaging.sendToDevice(tokens, payload).then((response) => {
                    var results = response.results
                    console.log("results")
                    console.log(results)
                    // For each message check if there was an error.
                    response.results.forEach((result, index) => {
                        const error = result.error;
                        if (error) {
                            // Cleanup the tokens who are not registered anymore.
                            if (error.code === 'messaging/invalid-registration-token' ||
                                error.code === 'messaging/registration-token-not-registered') {
                                // tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
                            }
                        }
                    });
                    // successfully sent to at least one
                    var oneDeviceGotTheMessage = false
                    response.results.forEach((result) => {
                        if (result.messageId !== null) {
                            oneDeviceGotTheMessage = true
                        }
                    });
                    console.log("oneDeviceGotTheMessage")
                    console.log(oneDeviceGotTheMessage)
                    if (oneDeviceGotTheMessage) {
                        const docRef = notificationsToSend[i].docRef
                        docRef.update({notificationSent: true});
                    }
                    return null;
                });
            }
            return null;
        })
    });
});