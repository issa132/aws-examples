
# docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html#cfn-ecs-cluster-capacityproviders
# docs.aws.amazon.com/cli/latest/reference/elastictranscoder/
# awscli.amazonaws.com/v2/documentation/api/latest/reference/elastictranscoder/index.html

AWS Elastic Transcoder
AWS Elastic Transcoder is a fully-managed video-transcoding service that converts Videos from one format to another for Video on Demand (VOD) or streaming video.

AWS Elastic Transcoder cannot be used via AWS CFN

If you need to automate you need to use the AWS SDK or AWS CLI


Create a pipeline

    Create a job

        Choose a preset (determines what to cover the file to)
        Choose source and destination bucket



Audio/Video System Presets

Audio AAC - 256k, 160k, 128k, 64k
Audio MP3 - 320k, 192k, 160k, 128k
Audio WAV 44100 Hz, 16 bit, 8 bit
Amazon Kindle Fire HDX, HD 8.9, HD...
Apple TV 3G, 2G Roku HD/2 XD
FLAC - CD
Full HD 1080i50/i60, 1080i50/i60 XD...
Generic 1080p, 720p, 480p 16:9, 480... 4:3, 320x240
Gif (Animated)
HLS v3 (lots of variants)
MPEG-DASH Audio 128 k
MPEG-DASH Video 600/1200/2400/...
NTSC
PAL
Smooth Streaming 3/2/1.5/1 mib/s...
Smooth Streaming 800, 600, 500, 400...
Web: Facebook, SmugMug, Vimeo...


AWS Elemental MediaConvert is modern version of Elastic Transcoder. AWS Elastic Transcoder exists for legacy customers who have not migrated to MediaConvert

## Create Content Buckets upload test video

aws s3 mb s3://srcvideos.example1254124.com --region us-east-1
aws s3 mb s3://videos.example1254124.com --region us-east-1

aws s3 cp App2Container.mp4 s3://srcvideos.example1254124.com/video.mp4 --region us-east-1

## Download Test Video MP4 File
https://file-examples.com/index.php/sample-video-files/sample-mp4-files/#google_vignette


# awscli.amazonaws.com/v2/documentation/api/latest/reference/elastictranscoder/create-pipeline.html#examples
## Create Pipeline

```sh
aws elastictranscoder create-pipeline \
--name my-transcoder-pipeline \
--input-bucket videos.example1254124.com \
--role arn:aws:iam::982383527471:role/Elastic_Transcoder_Default_Role \
--content-config file://content-config.json \
--thumbnail-config file://thumbnail-config.json \
--region us-east-1
```

# awscli.amazonaws.com/v2/documentation/api/latest/reference/elastictranscoder/create-job.html

## Create Job
```sh
aws elastictranscoder create-job \
--pipeline-id 1713880324699-qws2vn \
--inputs file://inputs.json \
--outputs file://outputs.json \
--output-key-prefix "videos/" \
--user-metadata file://user-metadata.json \
--region us-east-1 \
--query Job.Id
```

## Job Details

```sh
aws elastictranscoder read-job --id 1713880774155-kwck2z --region us-east-1
```

