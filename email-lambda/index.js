import { SESv2Client, SendEmailCommand } from "@aws-sdk/client-sesv2";

const ses = new SESv2Client({});

const FROM_EMAIL = "baby@nguyenbytes.com";
const TO_EMAIL = "vera.zh195@gmail.com";
const SUBJECT = "Thinking of you";
const MESSAGES = [
  "I love you so much.",
  "You mean the world to me.",
  "I am so lucky to have you.",
  "You make every day brighter.",
  "I am thinking about you and smiling.",
  "You are my favorite person.",
  "I love you more than words can say.",
  "You make my life better just by being in it."
];

export const handler = async () => {
  const textBody = MESSAGES[Math.floor(Math.random() * MESSAGES.length)];

  const command = new SendEmailCommand({
    FromEmailAddress: FROM_EMAIL,
    Destination: {
      ToAddresses: [TO_EMAIL],
    },
    Content: {
      Simple: {
        Subject: {
          Data: SUBJECT,
        },
        Body: {
          Text: {
            Data: textBody,
          },
        },
      },
    },
  });

  const response = await ses.send(command);

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Email sent",
      textBody,
      messageId: response.MessageId,
    }),
  };
};
