const functions = require('firebase-functions');
const admin= require('firebase-admin');
admin.initializeApp(functions.config().functions);

exports.orderTrigger=functions.firestore.document('notifcation/{ordersId}').onCreate(
    async (snapshot,context)=> 
    {
      const name=snapshot.get('name');
      const topic=snapshot.get('topic');
        var payLoad= {notification: {body:topic, title: 'from' +name,sound:'default',
        icon:'default'},
         data: 
        {click_action: 'FLUTTER_NOTIFICATION_CLICK',}}
      const response=await  admin.messaging().sendToTopic('Admin',payLoad);
    }
);


exports.deviceNotifcationTrigger=functions.firestore.document('deviceNotifcation/{deviceNotifcationId}').onCreate(
  async (snapshot,context)=> 
  {
    const name=snapshot.get('name');
    const topic=snapshot.get('topic');
    var tokens=[];
    tokens.push(snapshot.data().devtoken);
      var payLoad= {notification: {body:topic, title: 'from' +name,sound:'default'}, data: 
      {click_action: 'FLUTTER_NOTIFICATION_CLICK',}}
    const response=await  admin.messaging().sendToDevice(tokens,payLoad);
  }
);