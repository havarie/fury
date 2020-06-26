/* eslint-disable promise/no-nesting */
const functions = require('firebase-functions');
const admin = require('firebase-admin');


var serviceAccount = require("./diary-7919f-firebase-adminsdk-xp9f8-c1c1052d38.json");
var app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://diary-7919f.firebaseio.com"
});
var db = admin.firestore(app);

const cors = require("cors")({ origin: true });
const express = require('express');
const appMemories = express();

/* Forces user to have
    Authorization: Bearer {idToken}
    in the header when they call firebase functions that use
*/
const authenticate = (req, res, next) => {
    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
        console.log('Unauthorized');
        res.status(203).json({ error: { message: "No authorization information sent.", status: "UNAUTHENTICATED" }, message: "No authorization information sent." });
        return;
    }
    const idToken = req.headers.authorization.substring('Bearer '.length);
    admin.auth().verifyIdToken(idToken).then((userInfo) => {
        req.uid = userInfo.uid;
        return next();
    }).catch((error) => {
        console.log("Error, prob not authenticated");
        res.status(203).json({ error: { message: "Not authorized", status: "UNAUTHENTICATED" }, message: "Not authorized" });
        return;
    });

};


appMemories.use(authenticate);

appMemories.post('/newVideo', (req, res) => {
    cors(req, res, () => {
        return res.status(200).json({
            isError: false,
            signedUrl: url
        });


    });

});
// const expiresAtMs = Date.now() + 60000 * 10; // Link expires in 1 minute
const memoriesRef = db.collection('memories');
const usersRef = db.collection('users');
exports.scheduledFunction = functions.pubsub.schedule('every 1 minutes').onRun((context) => {
    
    return memoriesRef.where('notificationSent', '==', false).get().then((snapshot) => {
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
            })
        });
        return notificationsToSend;
    }).then((notificationsToSend) => {
        var promises = []
        notificationsToSend.forEach(notif => {
            console.log("add to list "+notif.ownerUid)
            promises.push(usersRef.doc(notif.ownerUid).get())
        });
        return Promise.all(promises).then((userDatas) => {
            console.log("userDatas")
            console.log(userDatas)
            for (i = 0; i < userDatas.length; i++) { 
                const payload = {
                    notification: {
                        title: 'Test!',
                        body: `${notificationsToSend[i].videoName} notifs.`
                    }
                };
                console.log("userDatas[i]");
                console.log(i);
                console.log(userDatas[i]);
                console.log(userDatas[i].data());
                const tokens = userDatas[i].data().notificationTokens                
                console.log("gooooo");
                console.log(payload);
                console.log(tokens);
                const response = admin.messaging().sendToDevice(tokens, payload);
                console.log(response);
            }
            return null;
        })
    });

    
    // const snapshot = memoriesRef.where('notificationSent', '==', false).get();
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
  });

// exports.addVideo = functions.https.onRequest((request, response) => {
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
