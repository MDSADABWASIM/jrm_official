const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


//new article notification.
exports.newArticles = functions.firestore.document("Articles/{any}")
.onCreate((change, context) => 
{   
    const title = change.data().title;
    const author = change.data().author;
    const notificationContent = {
        notification: {
            title: "Read "+ title,
            body:"written by  "+ author,
            icon: "default",
            sound: "default"
        }
    };

     return admin.messaging().sendToTopic("notifs", notificationContent)
    .then(function(result){
        console.log("Notification sent!");
        return null;
    })
    .catch(function(error){
        console.log('Notification sent failed:', error);
        return null;
   });
});
