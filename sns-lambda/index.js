const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");

const sns = new SNSClient({});

const PHONE_NUMBER_ENV = "PHONE_NUMBER";
const MESSAGES = [
  "I love you so much, my darling angel.",
  "I love you more than words can say, my darling angel.",
  "You are my darling angel, and I love you so much.",
  "My darling angel, I love you with all my heart.",
  "I am thinking of you and loving you so much, my darling angel.",
  "My darling angel, you mean everything to me and I love you so much.",
  "I love you so deeply, my sweet darling angel.",
  "My darling angel, every day I love you more.",
  "I love you so much, my beautiful darling angel.",
  "My darling angel, you are my heart and I love you so much.",
];

exports.handler = async () => {
  const phoneNumber = process.env[PHONE_NUMBER_ENV];

  if (!phoneNumber) {
    throw new Error(`Missing required environment variable: ${PHONE_NUMBER_ENV}`);
  }

  const message = MESSAGES[Math.floor(Math.random() * MESSAGES.length)];
  const response = await sns.send(
    new PublishCommand({
      PhoneNumber: phoneNumber,
      Message: message,
    }),
  );

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "SMS sent",
      textBody: message,
      snsMessageId: response.MessageId,
    }),
  };
};
