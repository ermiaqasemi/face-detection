var AWS = require("aws-sdk");
const bucket = process.env.bucket_name;
const photo = "";

var credentials = new AWS.SharedIniFileCredentials({ profile: "profile-name" });
AWS.config.credentials = credentials;
AWS.config.update({ region: "region-name" });

const client = new AWS.Rekognition();
const params = {
  Image: {
    S3Object: {
      Bucket: bucket,
      Name: photo,
    },
  },
  Attributes: ["ALL"],
};

client.detectFaces(params, function (err, response) {
  if (err) {
    console.log(err, err.stack); // an error occurred
  } else {
    console.log(`Detected faces for: ${photo}`);
    response.FaceDetails.forEach((data) => {
      let low = data.AgeRange.Low;
      let high = data.AgeRange.High;
      console.log(`The detected face is between: ${low} and ${high} years old`);
      console.log("All other attributes:");
      console.log(`  BoundingBox.Width:      ${data.BoundingBox.Width}`);
      console.log(`  BoundingBox.Height:     ${data.BoundingBox.Height}`);
      console.log(`  BoundingBox.Left:       ${data.BoundingBox.Left}`);
      console.log(`  BoundingBox.Top:        ${data.BoundingBox.Top}`);
      console.log(`  Age.Range.Low:          ${data.AgeRange.Low}`);
      console.log(`  Age.Range.High:         ${data.AgeRange.High}`);
      console.log(`  Smile.Value:            ${data.Smile.Value}`);
      console.log(`  Smile.Confidence:       ${data.Smile.Confidence}`);
      console.log(`  Eyeglasses.Value:       ${data.Eyeglasses.Value}`);
      console.log(`  Eyeglasses.Confidence:  ${data.Eyeglasses.Confidence}`);
      console.log(`  Sunglasses.Value:       ${data.Sunglasses.Value}`);
      console.log(`  Sunglasses.Confidence:  ${data.Sunglasses.Confidence}`);
      console.log(`  Gender.Value:           ${data.Gender.Value}`);
      console.log(`  Gender.Confidence:      ${data.Gender.Confidence}`);
      console.log(`  Beard.Value:            ${data.Beard.Value}`);
      console.log(`  Beard.Confidence:       ${data.Beard.Confidence}`);
      console.log(`  Mustache.Value:         ${data.Mustache.Value}`);
      console.log(`  Mustache.Confidence:    ${data.Mustache.Confidence}`);
      console.log(`  EyesOpen.Value:         ${data.EyesOpen.Value}`);
      console.log(`  EyesOpen.Confidence:    ${data.EyesOpen.Confidence}`);
      console.log(`  MouthOpen.Value:        ${data.MouthOpen.Value}`);
      console.log(`  MouthOpen.Confidence:   ${data.MouthOpen.Confidence}`);
      console.log(`  Emotions[0].Type:       ${data.Emotions[0].Type}`);
      console.log(`  Emotions[0].Confidence: ${data.Emotions[0].Confidence}`);
      console.log(`  Landmarks[0].Type:      ${data.Landmarks[0].Type}`);
      console.log(`  Landmarks[0].X:         ${data.Landmarks[0].X}`);
      console.log(`  Landmarks[0].Y:         ${data.Landmarks[0].Y}`);
      console.log(`  Pose.Roll:              ${data.Pose.Roll}`);
      console.log(`  Pose.Yaw:               ${data.Pose.Yaw}`);
      console.log(`  Pose.Pitch:             ${data.Pose.Pitch}`);
      console.log(`  Quality.Brightness:     ${data.Quality.Brightness}`);
      console.log(`  Quality.Sharpness:      ${data.Quality.Sharpness}`);
      console.log(`  Confidence:             ${data.Confidence}`);
      console.log("------------");
      console.log("");
    }); // for response.faceDetails
  } // if
});
