# Amazon Rekognition

Amazon Rekognition is image and video recognition service. Analyze images and videos to detect and label objects, people, celebrities.
Amazon Rekognition has the following prebuilt models:

    Object Detection
    Face Detection
    Searching Faces in Connection
    People pathing
    Detecting personal protective equipment
    Recognizing celebrities
    Moderating content
    Detecting text
    Detecting video segments
    Detecting face liveness

For Images requirements:

    Jpg or pngs
    Base64 encoding when passed via the HTTP API

        AWS SDKs for Java, Javascript, Python and PHP will automatically base64 encoded.

    Can access images from S3 bucket

Amazon Rekognition Custom Labels can identify the objects, logos, and scenes in images that are specific to your business needs.

# Amazon Rekognition – Object Detection

Detecting objects using the detect_labels
ruby
bucket = 'bucket' # the bucket name without s3://
photo  = 'photo' # the name of file
client = Aws::Rekognition::Client.new
attrs = {
  image: {s3_object: {bucket: bucket,name: photo},
  }, max_labels: 10
}
response = client.detect_labels attrs
puts "Detected labels for: #{photo}"
response.labels.each do |label|
  puts "Label:      #{label.name}"
  puts "Confidence: #{label.confidence}"
  puts "Instances:"
  label['instances'].each do |instance|
    box = instance['bounding_box']
    puts "  Bounding box:"
    puts "    Top:        #{box.top}"
    puts "    Left:       #{box.left}"
    puts "    Width:      #{box.width}"
    puts "    Height:     #{box.height}"
    puts "  Confidence: #{instance.confidence}"
  end
  puts "Parents:"
  label.parents.each do |parent|
    puts "  #{parent.name}"
  end
  puts "------------"
  puts ""
end



# Amazon Rekognition – Face Detection

Detecting faces using the detect_faces
ruby
bucket = 'bucket' # the bucketname without s3://
photo  = 'input.jpg' # the name of file
client = Aws::Rekognition::Client.new
attrs = {
  image: {
    s3_object: {bucket: bucket,name: photo},
  },attributes: ['ALL']
}
response = client.detect_faces attrs
puts "Detected faces for: #{photo}"
response.face_details.each do |face_detail|
  low  = face_detail.age_range.low
  high = face_detail.age_range.high
  puts "The detected face is between: #{low} and #{high} years old"
  puts "All other attributes:"
  puts "  bounding_box.width:  #{face_detail.bounding_box.width}"
  puts "  bounding_box.height: #{face_detail.bounding_box.height}"
  puts "  bounding_box.left:   #{face_detail.bounding_box.left}"
  puts "  bounding_box.top:    #{face_detail.bounding_box.top}"
  puts "  mustache.value:      #{face_detail.mustache.value}"
  puts "  mustache.confidence: #{face_detail.mustache.confidence}"
  puts "  eyes_open.value:     #{face_detail.eyes_open.value}"
  # ... many more options...
  puts "  confidence:          #{face_detail.confidence}"
  puts "------------"
  puts ""
end

## 
# gemfile
ruby# frozen_string_literal: true

source "https://rubygems.org"

# gem "rails"
gem 'aws-sdk-rekognition'
gem 'ox'
gem 'pry'

puis tu fais bundle install
#  https://docs.https://docs.aws.amazon.com/rekognition/latest/dg/what-is.html
# https://docs.aws.amazon.com/rekognition/latest/dg/labels-detect-labels-image.html

# policy 
{

  "Version": "2012-10-17",

  "Statement": [

    {

      "Sid": "AllowRekognitionServiceToReadBucket",

      "Effect": "Allow",

      "Principal": {

        "Service": "rekognition.amazonaws.com"

      },

      "Action": "s3:GetObject",

      "Resource": "arn:aws:s3:::rekog-example-1421/*",

      "Condition": {

        "StringEquals": {

          "aws:SourceAccount": "982383527471"

        }

      }

    }

  ]

}

# # Create bucket and upload file

aws s3 mb s3://rekog-example-1421 --region us-east-1
aws s3 cp andrew.jpg s3://rekog-example-1421