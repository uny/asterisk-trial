import client from "ari-client";

client.connect("http://asterisk:8088", "ariuser", "aripass").then((client) => {
  client.on("StasisStart", (event, channel) => {
    console.log(event);
  });
  client.start("myapp");
});
