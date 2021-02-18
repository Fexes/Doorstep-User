const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

exports.orderAcceptedNotification = functions.https.onRequest(async(request, response) => {

    // var notificationTitle = request.query.notificationTitle;
    // var notificationBody = request.query.notificationBody;
    var deviceTokenID = request.query.deviceTokenID;

  //  response.send(deviceTokenID)


    var tokens = [deviceTokenID];

    var payload = {
        notification: {
            title: "Order Accepted",
            body: "Your Order is being prepared",
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


exports.orderReadyNotification = functions.https.onRequest(async(request, response) => {

    // var notificationTitle = request.query.notificationTitle;
    // var notificationBody = request.query.notificationBody;
    var deviceTokenID = request.query.deviceTokenID;

    //  response.send(deviceTokenID)


    var tokens = [deviceTokenID];

    var payload = {
        notification: {
            title: "Order Ready",
            body: "Your Order is Ready. The rider is picking up your order.",
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


exports.orderArrivedNotification = functions.https.onRequest(async(request, response) => {

    // var notificationTitle = request.query.notificationTitle;
    // var notificationBody = request.query.notificationBody;
    var deviceTokenID = request.query.deviceTokenID;

    //  response.send(deviceTokenID)


    var tokens = [deviceTokenID];

    var payload = {
        notification: {
            title: "New Order",
            body: "We have a new Order. Lets prepared it",
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
