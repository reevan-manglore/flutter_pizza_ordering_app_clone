const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {validateWebhookSignature} = require("razorpay/dist/utils/razorpay-utils");

admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
// //
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});

//   response.send("Hello from Firebase!");
// });


exports.paymentSuccess = functions
    .https
    .onRequest(async (req, res) => {
      const razorpayWebhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET;
      const razorPaySignature = req.get("x-razorpay-signature");
      const isValidRequest = validateWebhookSignature(JSON.stringify(req.body), razorPaySignature, razorpayWebhookSecret);
      if (!isValidRequest) {
        functions.logger.info("some invalid request recieved!", {structuredData: true});
        return res.end();
      }
      const orderId = req.body["payload"]["order"]["entity"]["id"];
      const orderDocument =await db
          .collection("orders")
          .where("razorPayOrderId", "==", orderId)
          .limit(1)
          .get();
      const orderDocId = orderDocument.docs[0].id;
      const userId = orderDocument.docs[0].data()["uid"];
      const userDoc = await db
          .collection("users")
          .doc(userId)
          .get();
      const fcmToken = userDoc.data()["fcmToken"];
      db.collection("orders").doc(orderDocId).update({"isPaymentDone": true});
      messaging.send({data: {
        "orderDocId": orderDocId,
      },
      token: fcmToken,
      });
      res.end();
    });

