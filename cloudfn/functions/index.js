const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

exports.helloworld = functions.https.onRequest(async(request, response) => {

    var deviceTokenID = request.query.deviceTokenID;
     var deviceTokenID = request.query.deviceTokenID;

  //  response.send(deviceTokenID)


    var tokens = [deviceTokenID];

    var payload = {
        notification: {
            title: 'Push Title',
            body: 'Push Body',
            sound: 'default',
        },
        data: {
            push_key: 'Push Key Value',
            key1: 'data',
        },
    };
    try {
        await admin.messaging().sendToDevice(tokens, payload);
        response.send('Notification sent successfully')
        console.log('Notification sent successfully');
    } catch (err) {
        response.send(err)

        console.log(err);
    }
});

