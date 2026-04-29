AWS Elemental Media Convert
AWS Media Convert is a fully-managed video-transcoding service that converts videos from one format to another for Video on Demand (VOD) or streaming video in addition to applying lots of additional processing options
Video Correction

    Color space
    Sample range
    Timecode source
    Embedded timecode override
    Rotation
    Scan Type
    Pad Video

Input Filtering

    Sharpening
    Adding Texture

Other features

    Select audio tracks to be inputted
    Select caption tracks to be inputted
    Transcode only portions of the video (clips)
    Video Cropping
    Black barring
    Video overlaying
    Inserting images
    Adding signaling
    Partner integrations
    Media Convert you define a job, input and outputs.
    Media Convert will pull videos from a source bucket, transcode and place them in a destination bucket

Pub/Sub
What is Pub/Sub?
Publish–subscribe pattern commonly implemented in messaging systems.
In a pub/sub system the sender of messages (publishers) does not send their messages directly to receivers.
They instead send their messages to an event bus. The event bus categorizes their messages into groups.
Then receivers of messages (subscribers) subscribe to these groups.
Whenever new messages appear within their subscription the messages are immediately delivered to them.

Publisher  ─┐                 Subscriber
Publisher  ─→  Event Bus  ─→  Subscriber
Publisher  ─┘                 Subscriber
 

Publishers have no knowledge of who their subscribers are.
Subscribers do not pull for messages.
Messages are instead automatically and immediately pushed to subscribers.
Messages and events are interchangeable terms in pub/sub




